import Firebase

final class ApplicationController {
  var isUserAuthenticated: Bool {
    guard let auth = FIRAuth.auth() else { return false }
    return auth.currentUser != .None
  }

  func initialSetup() {
    FIRApp.configure()
  }
}
