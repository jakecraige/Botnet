import Curry
import Argo

public struct User: Modelable, Timestampable {
  public var id: String
  public var timestamps: Timestamps?
  public var name: String
  public var email: String

  public init(id: String, name: String = "Unknown", email: String = "") {
    self.id = id
    self.name = name
    self.email = email
  }
}

extension User: Decodable {
  public static func decode(json: JSON) -> Decoded<User> {
    return curry(User.init)
      <^> json <| "id"
      <*> json <| "name"
      <*> json <| "email"
  }
}

extension User: Encodable {
  public func encode() -> [String: AnyObject] {
    return [
      "name": name,
      "email": email
    ]
  }
}