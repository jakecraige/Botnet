import UIKit
import BotnetKit
import Kingfisher
import Reusable
import RxSwift
import RxCocoa

final class ThoughtTableViewCell: UITableViewCell, Reusable {
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
    profileImageView.kf_cancelDownloadTask()
    if let user = user {
      let generator = GravatarGenerator(email: user.email, size: 30)
      profileImageView.kf_setImageWithURL(generator.url)
      nameLabel.text = user.name
    } else {
      profileImageView.kf_setImageWithURL(GravatarGenerator.blankImageURL(size: 30))
      nameLabel.text = "Unkown User"
    }
  }
}
