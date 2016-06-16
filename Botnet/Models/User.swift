import Curry
import Argo

struct User: Modelable, Timestampable {
  var id: String
  var timestamps: Timestamps?
  var name: String
  var email: String

  init(id: String, name: String = "Unknown", email: String = "") {
    self.id = id
    self.name = name
    self.email = email
  }
}

extension User: Decodable {
  static func decode(json: JSON) -> Decoded<User> {
    return curry(User.init)
      <^> json <| "id"
      <*> json <| "name"
      <*> json <| "email"
  }
}

extension User: Encodable {
  func encode() -> [String: AnyObject] {
    return [
      "name": name,
      "email": email
    ]
  }
}
