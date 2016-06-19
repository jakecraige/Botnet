
import Curry
import Argo
import RxSwift

public struct Thought: Modelable, Timestampable {
  public var id: String
  public var timestamps: Timestamps?
  public var userID: String
  public var text: String
  public var images: [NSURL]

  public var asActivity: NSUserActivity {
    return with(NSUserActivity(activityType: "com.thoughtbot.Botnet.activity-thought")) {
      $0.title = text
      $0.userInfo = ["id": id]
    }
  }

  public static func new() -> Thought {
    return .init(id: "", timestamps: .None, userID: "", text: "", images: [])
  }

  public func user() -> Observable<User> {
    return Database.observeObject(ref: User.getChildRef(userID))
  }
}

extension Thought: Decodable {
  public static func decode(json: JSON) -> Decoded<Thought> {
    return curry(Thought.init)
      <^> json <| "id"
      <*> json <|? "timestamps"
      <*> json <| "user_id"
      <*> json <| "text"
      <*> (json <|| "images").or(.Success([]))
  }
}

extension Thought: Encodable {
  public func encode() -> [String: AnyObject] {
    return [
      "user_id": userID,
      "text": text,
      "images": images.map { $0.absoluteString },
    ]
  }
}
