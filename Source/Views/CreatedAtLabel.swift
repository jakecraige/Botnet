import UIKit
import Async
import BotnetKit

final class CreatedAtLabel: UILabel {
  let formatter = with(NSDateFormatter()) {
    $0.dateStyle = .ShortStyle
    $0.timeStyle = .ShortStyle
  }

  var date: NSDate? {
    didSet {
      Async.main { self.updateuI() }
    }
  }
}

private extension CreatedAtLabel {
  func updateuI() {
    text = date.flatMap(formatter.stringFromDate) ?? ""
  }
}
