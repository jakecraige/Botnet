import UIKit
import Reusable

final class MessageUserCell: UITableViewCell, Reusable {
  static let estimatedHeight: CGFloat = 60
  @IBOutlet var messageLabel: UILabel!

  func configure(message: String) {
    messageLabel.text = message
  }
}
