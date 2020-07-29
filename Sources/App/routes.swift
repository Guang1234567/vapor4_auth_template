import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }

    try app.register(collection: EnvController())
    try app.register(collection: UserController())
    try app.register(collection: TodoController())
    try app.register(collection: GalaxyController())
    try app.register(collection: StarController())
    try app.register(collection: EmailController())
}
