import UIKit
import SuperDelegate

@UIApplicationMain
class AppDelegate: SuperDelegate, ApplicationLaunched {
  var window = UIWindow()

  lazy var applicationVC: ApplicationViewController = {
    return UIStoryboard.initialViewController(.Main)
  }()

  var app: UIApplication { return UIApplication.sharedApplication() }

  func setupApplication() {
    window.backgroundColor = UIColor.whiteColor()
    window.rootViewController = applicationVC
  }

  func loadInterfaceWithLaunchItem(launchItem: LaunchItem) {
    setupMainWindow(window)
  }
}

extension AppDelegate: ShortcutCapable {
  func canHandleShortcutItem(shortcutItem: UIApplicationShortcutItem) -> Bool {
    return ShortcutIdentifier(fullType: shortcutItem.type) != .None
  }

  func handleShortcutItem(shortcutItem: UIApplicationShortcutItem, completionHandler: () -> Void) {
    guard let type = ShortcutIdentifier(fullType: shortcutItem.type) else { return completionHandler() }
    applicationVC.handleShortcutItem(type)
    completionHandler()
  }
}

extension AppDelegate: UserActivityCapable {
  func canHandleUserActivity(userActivity: NSUserActivity) -> Bool {
    return ActivityIdentifier(fullType: userActivity.activityType) != .None
  }

  func continueUserActivity(userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
    guard let type = ActivityIdentifier(fullType: userActivity.activityType) else { return false }
    applicationVC.handleUserActivity(type, activity: userActivity)
    return true
  }
}
