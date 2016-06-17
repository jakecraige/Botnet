import Argo
import Curry

public struct Timestamps {
  let createdAt: NSDate
  let updatedAt: NSDate
}

extension Timestamps: Decodable {
  public static func decode(json: JSON) -> Decoded<Timestamps> {
    return curry(Timestamps.init)
      <^> json <| "created_at"
      <*> json <| "updated_at"
  }
}
