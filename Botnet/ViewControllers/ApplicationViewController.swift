import UIKit

final class ApplicationViewController: UIViewController {
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
}

private extension ApplicationViewController {
  func displayHome() {
    let vc = UIStoryboard.initialViewController(.Home)
    changeActiveViewController(vc)
  }

  func displayAuthentication() {
    let vc = UIStoryboard.initialViewController(.Authentication)
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
