import UIKit

final class MessagesViewController: UITableViewController {
}

// MARK: UITableViewDataSource
extension MessagesViewController {
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 50
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    tableView.deselectAllRows(animated) // You know, UIKit bugs where it doesn't deselect rows.
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
