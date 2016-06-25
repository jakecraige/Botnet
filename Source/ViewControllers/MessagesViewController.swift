import UIKit
import BotnetKit
import RxSwift
import RxCocoa

final class MessagesViewController: UITableViewController {
}

// MARK: UITableViewDataSource
extension MessagesViewController {
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 50
  }
}

// MARK: UITableViewDelegate
extension MessagesViewController {
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell: MessagePreviewCell = tableView.dequeueReusableCell(indexPath: indexPath)
    return cell
  }
  override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return MessagePreviewCell.estimatedHeight
  }

  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }
}
