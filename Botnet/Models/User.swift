import Curry
import Argo

struct User: Modelable, Timestampable {
  var id: String?
  var timestamps: Timestamps?

  init(id: String) {
    self.id = id
  }
}

extension User: Decodable {
  static func decode(json: JSON) -> Decoded<User> {
    return curry(User.init)
      <^> json <| "id"
  }
}

extension User: Encodable {
  func encode() -> [String: AnyObject] {
    return [:]
  }
}
