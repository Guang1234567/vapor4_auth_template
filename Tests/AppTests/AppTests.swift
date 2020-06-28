@testable import App
import XCTVapor

final class AppTests: XCTestCase {
    func testHelloWorld() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        let testEnv = try app.testable(method: .inMemory)
        //let testEnv = try app.testable(method: .running)
        //let testEnv = try app.testable(method: .running(port: 8123))

        try testEnv.test(.GET, "hello") { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertEqual(res.body.string, "Hello, world!")
        }
    }
}
