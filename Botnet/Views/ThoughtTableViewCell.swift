import UIKit
import Haneke
import Reusable

final class ThoughtTableViewCell: UITableViewCell, Reusable {
  static let estimatedHeight: CGFloat = 72

  @IBOutlet var profileImageView: UIImageView!
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var thoughtTextLabel: UILabel!

  func configure() {
    let imageURL = GravatarGenerator(email: "jake@thoughtbot.com").url
    profileImageView.hnk_setImageFromURL(imageURL)
    nameLabel.text = "Alex Doe"
    thoughtTextLabel.text = "This is a thought. I think people care about these but that's not really true. I need to make this go a few lines to change stuffz"
  }
}
