import UIKit

enum Storyboard: String {
  case Authentication
  case Home
  case Main
}

extension UIStoryboard {
  static func initialViewController(storyboard: Storyboard) -> UIViewController {
    return UIStoryboard(name: storyboard.rawValue, bundle: .None).instantiateInitialViewController()!
  }

  static func instantiateViewController(withIdentifier identifier: String, fromStoryboard storyboard: Storyboard) -> UIViewController {
    return UIStoryboard(name: storyboard.rawValue, bundle: .None).instantiateViewControllerWithIdentifier(identifier)
  }
}
