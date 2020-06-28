import App
import Vapor

// vapor run serve --env development.custom_name --log debug
// vapor run serve --env production.custom_name --log info

// vapor run serve --env development
// vapor run serve --env production
// vapor run serve --env staging
// vapor run serve --env testing

var env = try Environment.detect()
try LoggingSystem.bootstrap(from: &env)
let app = Application(env)
defer {
    app.shutdown()
}
try configure(app)
try app.run()
