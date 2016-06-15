import UIKit
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
      .subscribeNext { [weak self] user in
        self?.updateUIForUser(user)
      }.addDisposableTo(disposeBag)
  }

  override func prepareForReuse() {
    disposeBag = DisposeBag()
  }
}

private extension ThoughtTableViewCell {
  func updateUIForUser(user: User) {
    let generator = GravatarGenerator(email: user.email)
    profileImageView.hnk_setImageFromURL(generator.url)
    nameLabel.text = user.name
  }
}
