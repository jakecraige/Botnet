import UIKit
import BotnetKit
import Kingfisher
import Reusable
import RxSwift

final class ThoughtDetailTableViewCell: UITableViewCell, Reusable {
  static let estimatedHeight: CGFloat = 145

  var disposeBag = DisposeBag()

  @IBOutlet var authorImageView: UIImageView!
  @IBOutlet var authorNameLabel: UILabel!
  @IBOutlet var thoughtTextLabel: UILabel!
  @IBOutlet var thoughtCreatedAtLabel: CreatedAtLabel!
  @IBOutlet var carouselContainerView: ImageCarouselContainerView!
  @IBOutlet var carouselHeightConstraint: NSLayoutConstraint!
  var carousel: ImageCarouselView { return carouselContainerView.carousel }

  override func awakeFromNib() {
    let heightConstant = carouselHeightConstraint.constant
    carousel.imageSize = CGSize(width: heightConstant, height: heightConstant)
  }

  func configure(thought: Thought, imageTapped: ((UIImage, [UIImage]) -> Void)) {
    carouselHeightConstraint.active = !thought.images.isEmpty
    thoughtTextLabel.text = thought.text
    thoughtCreatedAtLabel.date = thought.timestamps?.createdAt

    carousel.onImageTapped = imageTapped
    carousel.add(fromURLs: thought.images)

    thought.user()
      .observeOn(MainScheduler.instance)
      .subscribe(
        onNext: { [weak self] user in self?.updateUIForUser(user) },
        onError: { [weak self] error in self?.updateUIForUser(.None) }
      ).addDisposableTo(disposeBag)
  }

  override func prepareForReuse() {
    disposeBag = DisposeBag()
    carousel.reset()
  }
}

private extension ThoughtDetailTableViewCell {
  func updateUIForUser(user: User?) {
    authorImageView.kf_cancelDownloadTask()
    if let user = user {
      let generator = GravatarGenerator(email: user.email, size: 50)
      authorImageView.kf_setImageWithURL(generator.url)
      authorNameLabel.text = user.name
    } else {
      authorImageView.kf_setImageWithURL(GravatarGenerator.blankImageURL(size: 50))
      authorNameLabel.text = "Unkown User"
    }
  }
}
