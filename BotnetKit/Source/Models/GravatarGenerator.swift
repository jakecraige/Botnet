import Foundation
import UIKit
import Crypto

private func sizeAccountingForScreen(size: Float) -> Float {
  return size * Float(UIScreen.mainScreen().scale)
}

public struct GravatarGenerator {
  public let email: String
  public let size: Float

  public init(email: String, size: Float) {
    self.email = email
    self.size = sizeAccountingForScreen(size)
  }

  public var url: NSURL { return generateURL(emailHash, size: size) }
  private var emailHash: String { return email.MD5! }

  public static func blankImageURL(size size: Float) -> NSURL {
    return generateURL("not-an-md5-hash", size: sizeAccountingForScreen(size))
  }
}

private func generateURL(hash: String, size: Float) -> NSURL {
  let components = NSURLComponents(string: "https://www.gravatar.com/avatar/\(hash).jpg")!
  components.queryItems = [NSURLQueryItem(name: "s", value: "\(size)")]
  return components.URL!
}
