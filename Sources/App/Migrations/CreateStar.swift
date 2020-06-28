import Fluent

struct CreateStar: Migration {
    // Prepares the database for storing Star models.
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Star.schema)
                .id()
                .field("name", .string, .required)
                .field("galaxy_id", .uuid, .references(Galaxy.schema, "id"))
                .create()
    }

    // Optionally reverts the changes made in the prepare method.
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Star.schema).delete()
    }
}
