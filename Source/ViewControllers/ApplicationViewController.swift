import UIKit
import BotnetKit
import RxSwift

final class ApplicationViewController: UIViewController {
  let disposeBag = DisposeBag()
  let controller = ApplicationController()
  var activeViewController: UIViewController?

  override func viewDidLoad() {
    super.viewDidLoad()
    
    controller.initialSetup(UIApplication.sharedApplication())

    if session.isUserAuthenticated {
      displayHome()
    } else {
      displayAuthentication()
    }
  }

  func handleShortcutItem(item: ShortcutIdentifier) {
    switch item {
    case .composeThought: composeThought()
    }
  }

  func handleUserActivity(type: ActivityIdentifier, activity: NSUserActivity) {
    switch type {
    case .thought:
      guard let id = activity.userInfo?["id"] as? String else {
        fatalError("Expected to find model id in user info but was not there.")
      }
      viewThought(id)
    }
  }
}

private extension ApplicationViewController {
  func composeThought() {
    guard let navVC = activeViewController as? UINavigationController,
          let vc = navVC.topViewController as? ThoughtsTableViewController else {
      NSLog("Attempted to compose thought but not viewing the ThoughtsTableViewController")
      return
    }
    vc.performSegue(.composeThought)
  }

  func viewThought(id: String) {
    guard let navVC = activeViewController as? UINavigationController,
          let vc = navVC.topViewController as? ThoughtsTableViewController else {
      NSLog("Attempted to view thought but not viewing the ThoughtsTableViewController")
      return
    }

    Database<Thought>.observeObject(ref: Thought.getChildRef(id))
      .take(1)
      .subscribeNext { thought in
        vc.performSegue(.showThought, sender: ModelWrapper(thought))
      }
      .addDisposableTo(disposeBag)
  }

  /// Watch for when a user signs out and present authentication when it happens
  func startMonitoringAuthState() {
    let signedOut = session.firUser.filter { $0 == .None }
    signedOut
      .subscribeOn(MainScheduler.instance)
      .subscribeNext { [weak self] _ in self?.displayAuthentication() }
      .addDisposableTo(disposeBag)
  }

  func displayHome() {
    let vc = UIStoryboard.initialViewController(.Home)
    controller.user()
      .subscribeNext { [unowned self] user in
        session.user = user
        self.startMonitoringAuthState()
        self.changeActiveViewController(vc)
      }
      .addDisposableTo(disposeBag)
  }

  func displayAuthentication() {
    let vc: AuthenticationViewController = UIStoryboard.initialViewController(.Authentication)
    vc.userSignedIn
      .subscribeNext { [weak self] user in
        session.user = user
        self?.displayHome()
      }
      .addDisposableTo(disposeBag)
    changeActiveViewController(vc)
  }

  func changeActiveViewController(viewController: UIViewController) {
    activeViewController?.willMoveToParentViewController(.None)
    activeViewController?.removeFromParentViewController()
    activeViewController?.view.removeFromSuperview()
    activeViewController?.didMoveToParentViewController(.None)

    viewController.willMoveToParentViewController(self)
    addChildViewController(viewController)
    view.addSubview(viewController.view)
    viewController.didMoveToParentViewController(self)

    activeViewController = viewController
  }
}
