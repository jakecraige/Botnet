import Foundation
import UIKit
import Crypto

struct GravatarGenerator {
  let email: String
  let size: Float

  init(email: String, size: Float = 30) {
    self.email = email
    self.size = size * Float(UIScreen.mainScreen().scale)
  }

  var url: NSURL {
    let components = NSURLComponents(string: "https://www.gravatar.com/avatar/\(emailHash).jpg")!
    components.queryItems = [NSURLQueryItem(name: "s", value: "\(size)")]
    return components.URL!
  }

  var emailHash: String { return email.MD5! }
}
