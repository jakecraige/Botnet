import UIKit

extension UIViewController {
  func performSegue(segue: Segue, sender: AnyObject? = .None) {
    performSegueWithIdentifier(segue.rawValue, sender: sender)
  }
}
