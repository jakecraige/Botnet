import Async
import Firebase
import FirebaseAuthUI

final class AuthenticationController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    presentFirebaseUI()
  }
}

extension AuthenticationController: FIRAuthUIDelegate {
  func authUI(authUI: FIRAuthUI, didSignInWithUser user: FIRUser?, error: NSError?) {
    guard let user = user else { return handleAuthError(error!) }

    print("didSignInWithUser: \(user)")
  }
}

private extension AuthenticationController {
  func presentFirebaseUI() {
    guard let authUI = FIRAuthUI.authUI() else { return }
    authUI.delegate = self

    Async.main {
      self.presentViewController(authUI.authViewController(), animated: true, completion: nil)
    }
  }

  func handleAuthError(error: NSError) {
    print("Error logging in / signing up")
    print(error)
  }
}
