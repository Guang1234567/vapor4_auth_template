import Fluent
import Vapor
import Swift_Coroutine_NIO2
import RxSwift
import QueuesRedisDriver
import Queues


struct EmailController: RouteCollection {

    static func configure(_ app: Application) throws {
        try app.queues.use(.redis(url: "redis://127.0.0.1:6379"))
        //Register jobs
        let emailJob = EmailJob()
        app.queues.add(emailJob)
    }

    func boot(routes: RoutesBuilder) throws {
        let emails = routes.grouped("emails")
        emails.post(use: send)
    }

    func send(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        try Email.Create.validate(content: req)
        let create = try req.content.decode(Email.Create.self)

        return req
                .queues(.emails)
                .dispatch(
                        EmailJob.self,
                        Email(to: create.to, message: create.message),
                        maxRetryCount: 3
                ).map {
                    HTTPStatus.ok
                }
    }
}

extension QueueName {
    static let emails = QueueName(string: "emails")
}

struct Email: Codable {
    let to: String
    let message: String
}

extension Email {
    struct Create: Content {
        let to: String
        let message: String
    }
}

extension Email.Create: Validatable {

    enum CodingKeys: String, CodingKey {
        case to
        case message = "msg"
    }

    static func validations(_ validations: inout Validations) {
        validations.add(ValidationKey(stringLiteral: CodingKeys.to.rawValue), as: String.self, is: .email)
        validations.add(ValidationKey(stringLiteral: CodingKeys.message.rawValue), as: String.self, is: !.empty)
    }

}

class EmailJob: Job {
    typealias Payload = Email

    var _sent: [Payload]

    init() {
        _sent = []
    }

    func dequeue(_ context: QueueContext, _ payload: Payload) -> EventLoopFuture<Void> {
        // This is where you would send the email
        _sent.append(payload)
        context.logger.info("sending email \(payload.message) to \"\(payload.to)\" success !")
        return context.eventLoop.future()
    }

    func error(_ context: QueueContext, _ error: Error, _ payload: Payload) -> EventLoopFuture<Void> {
        context.logger.error("sending email \(payload.message) to \"\(payload.to)\" fail !")
        return context.eventLoop.future()
    }
}
