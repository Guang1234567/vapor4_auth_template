import Fluent
import Vapor

struct CreateUser: Migration {

    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(User.schema)
                .id()
                .field("name", .string, .required)
                .field("email", .string, .required)
                .field("password_hash", .string, .required)
                .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(User.schema).delete()
    }
}