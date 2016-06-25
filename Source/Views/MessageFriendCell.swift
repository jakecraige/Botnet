import UIKit
import BotnetKit
import Reusable

private var messages = [
  "Hey, how are yoU?",
  "Vivamus fermentum mattis ipsum, vel euismod diam convallis eu. Mauris rutrum felis vitae lacinia lobortis. Aliquam risus libero, maximus ut molestie in, iaculis eu sapien. Ut fringilla tortor dignissim elit auctor cursus vitae et lacus. Maecenas ut ultrices felis, in ornare dolor. Donec pellentesque, felis sed luctus pharetra, mi leo vestibulum ligula, imperdiet hendrerit nisi orci varius magna. Proin maximus lobortis posuere."
]

final class MessageFriendCell: UITableViewCell, Reusable {
  static let estimatedHeight: CGFloat = 65

  @IBOutlet var profileImageAndMessageStackView: UIStackView!
  @IBOutlet var profileImageView: UIImageView!
  @IBOutlet var messageLabel: UILabel!

  override func awakeFromNib() {
    profileImageAndMessageStackView.alignment = .Center
    profileImageView.kf_showIndicatorWhenLoading = true
    profileImageView.kf_setImageWithURL(NSURL(string: "https://placehold.it/30x30")!)
  }

  func configure() {
    messageLabel.text = randomValueFrom(messages)
    messageLabel.sizeToFit()
    if messageLabel.frame.height > profileImageView.frame.height { // multiline label
      profileImageAndMessageStackView.alignment = .LastBaseline
    } else {
      profileImageAndMessageStackView.alignment = .Center
    }

  }

  override func updateConstraints() {
    super.updateConstraints()
  }
}