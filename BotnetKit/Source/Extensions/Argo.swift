import Foundation
import Argo

extension NSURL: Decodable {
  public typealias DecodedType = NSURL

  public class func decode(_ json: JSON) -> Decoded<NSURL> {
    switch json {
    case .String(let urlString):
      return NSURL(string: urlString).map(pure) ?? Decoded<NSURL>.typeMismatch("URL", actual: json)
    default: return .typeMismatch("URL", actual: json)
    }
  }
}
