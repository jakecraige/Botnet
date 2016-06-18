import UIKit
import BotnetKit
import Haneke
import Reusable
import RxSwift
import RxCocoa

class ThoughtTableViewCell: UITableViewCell, Reusable {
  static let estimatedHeight: CGFloat = 72

  var disposeBag = DisposeBag()

  @IBOutlet var profileImageView: UIImageView!
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var thoughtTextLabel: UILabel!

  func configure(thought: Thought) {
    thoughtTextLabel.text = thought.text

    thought.user()
      .subscribe(
        onNext: { [weak self] user in self?.updateUIForUser(user) },
        onError: { [weak self] error in self?.updateUIForUser(.None) }
      ).addDisposableTo(disposeBag)
  }

  override func prepareForReuse() {
    disposeBag = DisposeBag()
  }
}

private extension ThoughtTableViewCell {
  func updateUIForUser(user: User?) {
    if let user = user {
      let generator = GravatarGenerator(email: user.email)
      profileImageView.hnk_setImageFromURL(generator.url)
      nameLabel.text = user.name
    } else {
      profileImageView.hnk_setImageFromURL(GravatarGenerator.blankImageURL)
      nameLabel.text = "Unkown User"
    }
  }
}
