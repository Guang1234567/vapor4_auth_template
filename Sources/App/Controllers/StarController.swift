import Fluent
import Vapor

struct StarController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let stars = routes.grouped("stars")
        stars.get(use: index)
        stars.post(use: create)
        stars.group(":starID") { star in
            star.delete(use: delete)
        }
    }

    func index(req: Request) throws -> EventLoopFuture<[Star]> {
        return Star.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<Star> {
        let galaxy = try req.content.decode(Star.self)
        return galaxy.save(on: req.db).map {
            galaxy
        }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Star.find(req.parameters.get("starID"), on: req.db)
                     .unwrap(or: Abort(.notFound))
                     .flatMap {
                         $0.delete(on: req.db)
                     }
                     .transform(to: .ok)
    }
}
