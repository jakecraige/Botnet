import UIKit
import BotnetKit

enum ActivityIdentifier: String {
  case thought

  init?(fullType: String) {
    guard let last = fullType.componentsSeparatedByString(".").last else { return nil }

    self.init(rawValue: last)
  }

  var type: String {
    return NSBundle.mainBundle().bundleIdentifier! + ".activity.\(rawValue)"
  }

  static func activity(for thought: Thought) -> NSUserActivity {
    return with(NSUserActivity(activityType: ActivityIdentifier.thought.type)) {
      $0.title = thought.text
      $0.userInfo = ["id": thought.id]
      $0.eligibleForSearch = true
      $0.eligibleForHandoff = false
    }
  }
}
