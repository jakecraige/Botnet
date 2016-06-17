import BotnetKit
import Firebase
import RxSwift

final class ApplicationController {
  var application: UIApplication?

  func initialSetup(application: UIApplication) {
    self.application = application
    FIRApp.configure()
  }

  func user() -> Observable<User> {
    return session.firUser
      .filter { $0 != .None }
      .map { $0! }
      .flatMap { user in user.getToken(forceRefresh: true).map { _ in user } }
      .flatMap { user in Database.observeObject(ref: User.getChildRef(user.uid)) }
  }

  func configureShortcutItems() {
    guard let application = application else { return }

    if session.isUserAuthenticated {
      application.shortcutItems = [ShortcutIdentifier.composeThought.asShortcutItem]
    } else {
      application.shortcutItems = []
    }
  }
}