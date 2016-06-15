import Foundation
import Crypto

struct GravatarGenerator {
  let email: String
  let size: Int

  init(email: String, size: Int = 30) {
    self.email = email
    self.size = size
  }

  var url: NSURL {
    let components = NSURLComponents(string: "https://www.gravatar.com/avatar/\(emailHash).jpg")!
    components.queryItems = [NSURLQueryItem(name: "s", value: "\(size)")]
    return components.URL!
  }

  var emailHash: String { return email.MD5! }
}
