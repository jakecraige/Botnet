import UIKit
import Social

class ShareViewController: SLComposeServiceViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Botnet"
    placeholder = "Compose your thought..."
  }

  override func isContentValid() -> Bool {
    return !contentText.isEmpty
  }
  
  override func didSelectPost() {
    NSLog("Post thought: \(contentText)")
    super.didSelectPost()
  }
}
