import UIKit

private var cellCount = 100

private enum Row: Int {
  case friend
  case user
  
  init(indexPath: NSIndexPath) {
    let idx = indexPath.row % 2 == 0 ? 0 : 1
    guard let value = Row(rawValue: idx) else {
      fatalError("Unknown indexPath.row \(indexPath.row) found, not found in Row enum")
    }
    self = value
  }
}

final class MessageViewController: UITableViewController {
  var shouldScrollToBottom = true

  override func viewDidLoad() {
    tableView.rowHeight = UITableViewAutomaticDimension
  }

  override func viewDidLayoutSubviews() {
    guard shouldScrollToBottom else { return }
    let lastIndexpath = NSIndexPath(forRow: cellCount - 1, inSection: 0)
    tableView.scrollToRowAtIndexPath(lastIndexpath, atScrollPosition: .Bottom, animated: false)
  }
}

// MARK: UIScrollViewDelegate
extension MessageViewController {
  override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
    shouldScrollToBottom = false
  }
}

// MARK: UITableViewDataSource
extension MessageViewController {
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return cellCount
  }
}

// MARK: UITableViewDelegate
extension MessageViewController {
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    switch Row(indexPath: indexPath) {
    case .friend:
      let cell: MessageFriendCell = tableView.dequeueReusableCell(indexPath: indexPath)
      cell.configure()
      return cell
    case .user:
      let cell: MessageUserCell = tableView.dequeueReusableCell(indexPath: indexPath)
      return cell
    }
  }

  override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    switch Row(indexPath: indexPath) {
    case .friend:
      return MessageFriendCell.estimatedHeight
    case .user:
      return MessageUserCell.estimatedHeight
    }
  }
}
