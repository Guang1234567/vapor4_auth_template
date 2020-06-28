import Fluent
import Vapor
import Swift_Coroutine_NIO2


/// Creates new users and logs them in.
struct UserController: RouteCollection {

    static func passwordProtected(_ routes: RoutesBuilder) -> RoutesBuilder {
        routes.grouped(User.authenticator())
              .grouped(User.guardMiddleware())
    }

    static func passwordAndTokenProtected(_ routes: RoutesBuilder) -> RoutesBuilder {
        routes.grouped(User.authenticator())
              .grouped(UserToken.authenticator())
              .grouped(User.guardMiddleware())
    }

    static func tokenProtected(_ routes: RoutesBuilder) -> RoutesBuilder {
        routes.grouped(UserToken.authenticator())
              .grouped(User.guardMiddleware())
    }

    static func sessionProtected(_ routes: RoutesBuilder) -> RoutesBuilder {
        routes.grouped(User.sessionAuthenticator())
    }

    func boot(routes: RoutesBuilder) throws {
        let users = routes.grouped("users")
        users.post(use: create)

        // basic / password auth protected routes
        /*
        let passwordProtected = UserController.passwordProtected(routes)
        passwordProtected.post("login", use: login)
        */

        // https://docs.vapor.codes/4.0/authentication/#composing-methods
        // This composition of authenticators results in a route that can be accessed by either password or token.
        // Such a route could allow a user to login and generate a token,
        // then continue to use that token to generate new tokens
        let passwordAndTokenProtected = UserController.passwordAndTokenProtected(routes)
        passwordAndTokenProtected.post("login", use: login)

        // bearer / token auth protected routes
        let tokenProtected = UserController.tokenProtected(routes)
        tokenProtected.post("logout", use: logout)
        tokenProtected.get("me", use: me)
    }

    func create(req: Request) throws -> EventLoopFuture<User.Get> {

        try User.Create.validate(req)
        let create = try req.content.decode(User.Create.self)
        guard create.password == create.confirmPassword else {
            throw Abort(.badRequest, reason: "Passwords did not match")
        }

        return req.password.async
                .hash(create.password)
                .map { (digest: String) -> User in
                    User(
                            name: create.name,
                            email: create.email,
                            passwordHash: digest
                    )
                }
                .flatMap { user in
                    user.save(on: req.db)
                        .flatMapThrowing {
                            try User.Get(
                                    id: user.requireID(),
                                    name: user.name,
                                    email: user.email)
                        }
                }
    }

    /*
    func login(req: Request) throws -> EventLoopFuture<UserToken> {
        let user = try req.auth.require(User.self)
        let userTokenBeDeleted = req.auth.get(UserToken.self)

        return req.application.threadPool
                .runIfActive(eventLoop: req.eventLoop, user.generateToken)
                .flatMap { token in
                    let saveToken = token.save(on: req.db)
                                         .map {
                                             token
                                         }

                    if let userTokenBeDeleted = userTokenBeDeleted {
                        return UserToken.query(on: req.db)
                                        .filter(\.$value == userTokenBeDeleted.value)
                                        .delete(force: true)
                                        .flatMap {
                                            saveToken
                                        }
                    } else {
                        return saveToken
                    }
                }
    }
    */

    func login(req: Request) throws -> EventLoopFuture<UserToken> {

        let user = try req.auth.require(User.self)
        let userTokenBeDeleted = req.auth.get(UserToken.self)

        let eventLoop = req.eventLoop
        let ioThreadPool = req.application.threadPool
        return EventLoopFuture<UserToken>.coroutine(eventLoop) { co in

            try co.continueOn(ioThreadPool)

            let token = try user.generateToken()

            try co.continueOn(eventLoop)

            if let userTokenBeDeleted = userTokenBeDeleted {
                try UserToken.query(on: req.db)
                             .filter(\.$value == userTokenBeDeleted.value)
                             .delete(force: true)
                             .await(co)
            }

            return try token.save(on: req.db)
                            .map {
                                token
                            }
                            .await(co)
        }
    }

    func logout(req: Request) throws -> EventLoopFuture<UserToken> {
        let user = try req.auth.require(User.self)
        let userTokenBeDeleted = try req.auth.require(UserToken.self)
        req.auth.logout(User.self)

        return UserToken.query(on: req.db)
                        .filter(\.$value == userTokenBeDeleted.value)
                        .delete(force: true)
                        .flatMapThrowing {
                            try UserToken(
                                    id: userTokenBeDeleted.id,
                                    value: userTokenBeDeleted.value,
                                    userID: userTokenBeDeleted.user.requireID())
                        }
    }

    func me(req: Request) throws -> EventLoopFuture<User.Get> {
        let myself = try req.auth.require(User.self)
        return try req.eventLoop.makeSucceededFuture(
                User.Get(id: myself.requireID(),
                         name: myself.name,
                         email: myself.email)
        )
    }
}


extension User {

    /// DTO : for creating(registing) a user
    struct Create: Content {
        var name: String
        var email: String
        var password: String
        var confirmPassword: String
    }

    /// DTO : for avoiding response sensitive field (eg. User.passwordHash)
    struct Get: Content {
        var id: UUID
        var name: String
        var email: String
    }

}


extension User.Create: Validatable {

    static func validations(_ validations: inout Validations) {
        validations.add("name", as: String.self, is: !.empty)
        validations.add("email", as: String.self, is: .email)
        validations.add("password", as: String.self, is: .count(6...))
    }

}


extension User: ModelAuthenticatable {
    static let usernameKey = \User.$email
    static let passwordHashKey = \User.$passwordHash

    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.passwordHash)
    }
}


extension User {
    func generateToken() throws -> UserToken {
        try .init(
                value: [UInt8].random(count: 16).base64,
                userID: self.requireID()
        )
    }
}


extension UserToken: ModelTokenAuthenticatable {
    static let valueKey = \UserToken.$value
    static let userKey = \UserToken.$user

    var isValid: Bool {
        guard let expiresAt = self.expiresAt else {
            return false
        }

        return expiresAt > .init()
    }
}


// Allow this model to be persisted in sessions.
extension User: ModelSessionAuthenticatable {}
