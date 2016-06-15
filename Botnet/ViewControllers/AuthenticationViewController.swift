import Async
import Firebase
import FirebaseAuthUI
import RxSwift

final class AuthenticationViewController: UIViewController {
  let controller = AuthenticationController()
  let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()
    presentFirebaseUI()
  }
}

extension AuthenticationViewController: FIRAuthUIDelegate {
  func authUI(authUI: FIRAuthUI, didSignInWithUser user: FIRUser?, error: NSError?) {
    guard let firUser = user else { return handleAuthError(error!) }

    controller.save(firUser).subscribe(
      onNext: { [weak self] _ in self?.navigateToHome() },
      onError: { [weak self] error in self?.handleAuthError(error) }
    ).addDisposableTo(disposeBag)
  }
}

private extension AuthenticationViewController {
  func presentFirebaseUI() {
    guard let authUI = FIRAuthUI.authUI() else { return }
    authUI.delegate = self

    Async.main {
      self.presentViewController(authUI.authViewController(), animated: true, completion: nil)
    }
  }

  func navigateToHome() {
    let vc = UIStoryboard.initialViewController(.Home)
    presentViewController(vc, animated: true, completion: .None)
  }

  func handleAuthError(error: ErrorType) {
    print("Error logging in / signing up")
    print(error)
  }
}
