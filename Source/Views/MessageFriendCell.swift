import UIKit
import BotnetKit
import Reusable

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

  func configure(message: String) {
    messageLabel.text = message
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