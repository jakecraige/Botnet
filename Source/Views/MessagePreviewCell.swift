import UIKit
import Reusable
import Kingfisher

final class MessagePreviewCell: UITableViewCell, Reusable {
  static let estimatedHeight: CGFloat = 92
  @IBOutlet var profileImageView: UIImageView!
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var lastMessageLabel: UILabel!
  @IBOutlet var lastMessageContent: UILabel!

  override func awakeFromNib() {
    profileImageView.kf_showIndicatorWhenLoading = true
    profileImageView.kf_setImageWithURL(NSURL(string: "https://placehold.it/60x60")!)
  }
}
