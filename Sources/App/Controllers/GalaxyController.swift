import Fluent
import Vapor

struct GalaxyController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let galaxies = routes.grouped("galaxies")
        galaxies.get(use: index)
        galaxies.post(use: create)
        galaxies.group(":galaxyID") { galaxy in
            galaxy.delete(use: delete)
        }
    }

    func index(req: Request) throws -> EventLoopFuture<[Galaxy]> {
        return Galaxy.query(on: req.db).with(\.$stars).all()
    }

    func create(req: Request) throws -> EventLoopFuture<Galaxy> {
        let galaxy = try req.content.decode(Galaxy.self)
        return galaxy.save(on: req.db).map {
            galaxy
        }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Galaxy.find(req.parameters.get("galaxyID"), on: req.db)
                     .unwrap(or: Abort(.notFound))
                     .flatMap {
                         $0.delete(on: req.db)
                     }
                     .transform(to: .ok)
    }
}
