import Fluent

struct CreateTodo: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Todo.schema)
                       .id()
                       .field("title", .string, .required)
                       .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Todo.schema).delete()
    }
}
