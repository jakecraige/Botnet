import BotnetKit
import Social
import UIKit

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
    let thought = with(Thought.new()) {
      $0.text = contentText
      $0.userID = session.user?.id ?? "unknown"
    }
    Database.save(thought)
    NSLog("Post thought: \(thought)")
    super.didSelectPost()
  }
}
