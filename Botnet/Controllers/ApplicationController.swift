import Firebase
import RxSwift

final class ApplicationController {
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

  func initialSetup() {
    FIRApp.configure()
  }

  func user() -> Observable<User> {
    return firUser
      .filter { $0 != .None }
      .map { $0! }
      .flatMap { user in user.getToken(forceRefresh: true).map { _ in user } }
      .flatMap { user in Database.observeObject(ref: User.getChildRef(user.uid)) }
  }
}
