import UIKit

enum ShortcutIdentifier: String {
  case composeThought

  init?(fullType: String) {
    guard let last = fullType.componentsSeparatedByString(".").last else { return nil }

    self.init(rawValue: last)
  }

  var type: String {
    return NSBundle.mainBundle().bundleIdentifier! + ".\(rawValue)"
  }

  var title: String {
    switch self {
    case .composeThought: return "Compose thought"
    }
  }

  var icon: UIApplicationShortcutIcon {
    switch self {
    case .composeThought: return UIApplicationShortcutIcon(type: .Add)
    }
  }

  var asShortcutItem: UIApplicationShortcutItem {
    return UIApplicationShortcutItem(
      type: type,
      localizedTitle: title,
      localizedSubtitle: .None,
      icon: icon,
      userInfo: .None
    )
  }
}
