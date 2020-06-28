import Fluent
import Vapor

struct CreateUserToken: Migration {

    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("user_tokens")
                .id()
                .field("value", .string, .required)
                .field("user_id", .uuid, .required)
                .field("created_at", .string)
                .field("updated_at", .string)
                .field("expires_at", .string)
                .unique(on: "value")
                .foreignKey("user_id", references: "users", "id", onDelete: .cascade) // auto delete user_token when delete user
                .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("user_tokens").delete()
    }
}