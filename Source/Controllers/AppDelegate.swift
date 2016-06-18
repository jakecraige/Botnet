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

    switch launchItem {
    case let .ShortcutItem(shortcutItem): handleShortcutItem(shortcutItem, completionHandler: {})
    default: break
    }
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
