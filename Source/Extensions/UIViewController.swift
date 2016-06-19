import UIKit

extension UIViewController {
  func performSegue(segue: SegueIdentifier, sender: AnyObject? = .None) {
    performSegueWithIdentifier(segue.rawValue, sender: sender)
  }
}
