import UIKit
import BotnetKit
import Kingfisher
import Reusable
import RxSwift
import RxCocoa

final class ThoughtTableViewCell: UITableViewCell, Reusable {
  static let estimatedHeight: CGFloat = 125

  var disposeBag = DisposeBag()

  @IBOutlet var profileImageView: UIImageView!
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var thoughtTextLabel: UILabel!
  @IBOutlet var carouselContainerView: ImageCarouselContainerView!
  @IBOutlet var carouselHeightConstraint: NSLayoutConstraint!
  var thought: Thought!

  override func awakeFromNib() {
    let heightConstant = carouselHeightConstraint.constant
    carouselContainerView.carousel.imageSize = CGSize(width: heightConstant, height: heightConstant)
  }

  func configure(thought: Thought, imageTapped: ((UIImage, [UIImage]) -> Void)) {
    self.thought = thought
    thoughtTextLabel.text = thought.text
    carouselContainerView.hidden = thought.images.isEmpty

    if !carouselContainerView.hidden {
      carouselContainerView.carousel.onImageTapped = imageTapped
      carouselContainerView.carousel.add(fromURLs: thought.images)
    }

    thought.user()
      .subscribe(
        onNext: { [weak self] user in self?.updateUIForUser(user) },
        onError: { [weak self] error in self?.updateUIForUser(.None) }
      )
      .addDisposableTo(disposeBag)
  }

  override func prepareForReuse() {
    disposeBag = DisposeBag()
    carouselContainerView.carousel.reset()
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
