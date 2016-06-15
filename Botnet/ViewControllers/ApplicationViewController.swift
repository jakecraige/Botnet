import UIKit
import RxSwift

final class ApplicationViewController: UIViewController {
  let disposeBag = DisposeBag()
  let controller = ApplicationController()
  var activeViewController: UIViewController?

  override func viewDidLoad() {
    super.viewDidLoad()
    
    controller.initialSetup()

    if controller.isUserAuthenticated {
      displayHome()
    } else {
      displayAuthentication()
    }
  }

  /// Watch for when a user signs out and present authentication when it happens
  func startMonitoringAuthState() {
    let signedOut = controller.firUser.filter { $0 == .None }
    signedOut
      .subscribeOn(MainScheduler.instance)
      .subscribeNext { [weak self] _ in self?.displayAuthentication() }
      .addDisposableTo(disposeBag)
  }
}

private extension ApplicationViewController {
  func displayHome() {
    let vc = UIStoryboard.initialViewController(.Home)
    startMonitoringAuthState()
    changeActiveViewController(vc)
  }

  func displayAuthentication() {
    let vc: AuthenticationViewController = UIStoryboard.initialViewController(.Authentication)
    vc.userSignedIn
      .subscribeNext { [weak self] _ in self?.displayHome() }
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
