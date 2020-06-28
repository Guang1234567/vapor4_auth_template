import Fluent
import Vapor

final class UserToken: Model, Content {
    static let schema = "user_tokens"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "value")
    var value: String

    @Parent(key: "user_id")
    var user: User

    @Timestamp(key: "created_at", on: .create, format: .iso8601(withMilliseconds: true))
    var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update, format: .iso8601(withMilliseconds: true))
    var updatedAt: Date?

    @Timestamp(key: "expires_at", on: .delete, format: .iso8601(withMilliseconds: true))
    var expiresAt: Date?

    init() {}

    init(id: UUID? = nil,
         value: String,
         userID: User.IDValue,
         // set token to expire after 5 hours
         expiresAt: Date = Date.init(timeInterval: 60 * 60 * 5, since: .init())) {
        self.id = id
        self.value = value
        self.$user.id = userID
        self.expiresAt = expiresAt
    }
}

