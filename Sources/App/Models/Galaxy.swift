import Fluent
import Vapor


final class Galaxy: Model, Content {

    static let schema = "galaxies"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String

    @Children(for: \.$galaxy)
    var stars: [Star]

    init() {}

    init(id: UUID?, name: String) {
        self.id = id
        self.name = name
    }

}
