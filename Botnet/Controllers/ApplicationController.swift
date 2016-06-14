import Firebase

final class ApplicationController {
  var isUserAuthenticated: Bool {
    return false
  }

  func initialSetup() {
    FIRApp.configure()
  }
}
