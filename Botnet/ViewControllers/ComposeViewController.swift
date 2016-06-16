import UIKit
import RxSwift
import RxCocoa

final class ComposeViewController: UIViewController {
  let disposeBag = DisposeBag()

  @IBOutlet var postButton: UIBarButtonItem!
  @IBOutlet var textView: UITextView!

  override func viewDidLoad() {
    let textValid = textView.rx_text.asDriver().map { !$0.isEmpty }

    textValid
      .drive(postButton.rx_enabled)
      .addDisposableTo(disposeBag)
  }

  @IBAction func postTapped(sender: UIBarButtonItem) {
    let thought = with(Thought.new()) {
      $0.text = self.textView.text ?? ""
      $0.userID = session.user?.id ?? "unknown user"
    }

    Database.save(thought)
    self.dismissViewControllerAnimated(true, completion: .None)
  }
}
