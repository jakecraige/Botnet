import Foundation
import UIKit
import Crypto

public struct GravatarGenerator {
  static let defaultSize: Float = 30 * Float(UIScreen.mainScreen().scale)

  public static var blankImageURL: NSURL {
    return generateURL("not-an-md5-hash", size: defaultSize)
  }

  public let email: String
  public let size: Float

  public init(email: String, size: Float = GravatarGenerator.defaultSize) {
    self.email = email
    self.size = size
  }

  public var url: NSURL { return generateURL(emailHash, size: size) }
  private var emailHash: String { return email.MD5! }
}

private func generateURL(hash: String, size: Float) -> NSURL {
  let components = NSURLComponents(string: "https://www.gravatar.com/avatar/\(hash).jpg")!
  components.queryItems = [NSURLQueryItem(name: "s", value: "\(size)")]
  return components.URL!
}
