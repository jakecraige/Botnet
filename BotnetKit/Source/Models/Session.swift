import Firebase
import RxSwift

public final class Session {
  let disposeBag = DisposeBag()

  public var isUserAuthenticated: Bool {
    guard let auth = FIRAuth.auth() else { return false }
    return auth.currentUser != .None
  }

  public lazy var firUser: Observable<FIRUser?> = {
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

  public var user: User?

  init() {
    FIRApp.configure()
  }
}

public let session = Session()
