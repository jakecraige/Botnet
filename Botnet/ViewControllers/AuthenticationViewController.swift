import BotnetKit
import Firebase
import FirebaseAuthUI
import RxSwift

final class AuthenticationViewController: UIViewController {
  let controller = AuthenticationController()
  let disposeBag = DisposeBag()
  let userSignedIn = PublishSubject<User>()
  var hasPresentedFirebaseUI = false

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    // Since FirebaseUI closes itself, we need to make sure that it doesn't instantly pop back up
    // at that point. Ideally we'd present in `viewDidLoad` but it's called before this VC is on
    // screen
    guard !hasPresentedFirebaseUI else { return }

    presentFirebaseUI()
  }
}

extension AuthenticationViewController: FIRAuthUIDelegate {
  func authUI(authUI: FIRAuthUI, didSignInWithUser user: FIRUser?, error: NSError?) {
    guard let firUser = user else { return handleAuthError(error!) }

    controller.save(firUser).subscribe(
      onNext: { [weak self] user in
        guard let `self` = self else { return }
        self.userSignedIn.onNext(user)
        self.userSignedIn.onCompleted()
      },
      onError: { [weak self] error in self?.handleAuthError(error) }
    ).addDisposableTo(disposeBag)
  }
}

private extension AuthenticationViewController {
  func presentFirebaseUI() {
    guard let authUI = FIRAuthUI.authUI() else { return }
    authUI.delegate = self

    hasPresentedFirebaseUI = true
    self.presentViewController(authUI.authViewController(), animated: true, completion: .None)
  }

  func handleAuthError(error: ErrorType) {
    print("Error logging in / signing up")
    print(error)
  }
}
