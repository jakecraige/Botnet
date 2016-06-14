import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
    window = appWindow
    window?.makeKeyAndVisible()
    return true
  }

  private lazy var appWindow: UIWindow = {
    return with(UIWindow(frame: UIScreen.mainScreen().bounds)) {
      $0.backgroundColor = UIColor.whiteColor()
      $0.rootViewController = self.rootViewController
    }
  }()

  private lazy var rootViewController: UIViewController = {
    return UIStoryboard.initialViewController(.Main)
  }()
}
