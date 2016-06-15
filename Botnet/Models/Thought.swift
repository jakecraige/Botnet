import Curry
import Argo
import RxSwift

struct Thought: Modelable, Timestampable {
  var id: String?
  var timestamps: Timestamps?
  var userID: String
  var text: String

  func new() -> Thought {
    return .init(id: .None, timestamps: .None, userID: "", text: "")
  }

  func user() -> Observable<User> {
    return Database.observeObject(ref: User.getChildRef(userID))
  }
}

extension Thought: Decodable {
  static func decode(json: JSON) -> Decoded<Thought> {
    return curry(Thought.init)
      <^> json <|? "id"
      <*> json <|? "timestamps"
      <*> json <| "user_id"
      <*> json <| "text"
  }
}

extension Thought: Encodable {
  func encode() -> [String: AnyObject] {
    return [
      "user_id": userID,
      "text": text,
    ]
  }
}
