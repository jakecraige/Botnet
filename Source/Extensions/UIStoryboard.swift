import UIKit

enum Storyboard: String {
  case Authentication
  case Home
  case Main
  case Thoughts
}

extension UIStoryboard {
  static func initialViewController<VCType: UIViewController>(storyboard: Storyboard) -> VCType {
    return UIStoryboard(name: storyboard.rawValue, bundle: .None).instantiateInitialViewController() as! VCType
  }

  static func instantiateViewController(withIdentifier identifier: String, fromStoryboard storyboard: Storyboard) -> UIViewController {
    return UIStoryboard(name: storyboard.rawValue, bundle: .None).instantiateViewControllerWithIdentifier(identifier)
  }
}
