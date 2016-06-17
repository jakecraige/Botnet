import BotnetKit
import Firebase
import RxSwift

final class ApplicationController {
  let disposeBag = DisposeBag()
  var application: UIApplication?

  var isUserAuthenticated: Bool {
    guard let auth = FIRAuth.auth() else { return false }
    return auth.currentUser != .None
  }

  lazy var firUser: Observable<FIRUser?> = {
    guard let auth = FIRAuth.auth() else {
      fatalError("Couldn't initialize auth to monitor user state")
    }

    return Observable.create { observer in
      let handle = auth.addAuthStateDidChangeListener { _, user in
        observer.onNext(user)
      }

      return AnonymousDisposable { auth.removeAuthStateDidChangeListener(handle) }
    }.shareReplay(1)
  }()

  func initialSetup(application: UIApplication) {
    self.application = application
    FIRApp.configure()

    firUser
      .map { $0?.uid ?? "" }
      .distinctUntilChanged()
      .subscribeNext { [weak self] _ in self?.configureShortcutItems() }
      .addDisposableTo(disposeBag)
  }

  func user() -> Observable<User> {
    return firUser
      .filter { $0 != .None }
      .map { $0! }
      .flatMap { user in user.getToken(forceRefresh: true).map { _ in user } }
      .flatMap { user in Database.observeObject(ref: User.getChildRef(user.uid)) }
  }

  func configureShortcutItems() {
    guard let application = application else { return }

    if isUserAuthenticated {
      application.shortcutItems = [ShortcutIdentifier.composeThought.asShortcutItem]
    } else {
      application.shortcutItems = []
    }
  }
}
