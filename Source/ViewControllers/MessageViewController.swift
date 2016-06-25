import UIKit
import BotnetKit

private var cellCount = 100

private var messages = [
  "Vivamus fermentum mattis ipsum, vel euismod diam convallis eu. Mauris rutrum felis vitae lacinia lobortis.",
  "Duis mattis sodales nunc. Ut accumsan vulputate vestibulum. Pellentesque hendrerit orci ac eros semper rhoncus. Donec semper ac massa ac.",
  "Ut a tempus lacus, sit amet tincidunt felis. Vestibulum ante.",
  "Integer finibus vel ipsum sed tempus. Phasellus vel justo at magna euismod euismod. Aenean iaculis mi mi. Nullam sit amet.",
  "In porta ullamcorper nisi. Proin faucibus, dui ut consectetur sodales, arcu metus consequat quam, in pretium metus mi et nulla. Maecenas nec metus pellentesque, mattis velit vitae, blandit nunc. Vivamus varius finibus massa a feugiat.",
  "Praesent gravida neque eu lacinia.",
  "Fusce in lorem sed dolor volutpat ultricies. Vestibulum sodales volutpat malesuada. Maecenas fringilla lacus vitae commodo blandit. Curabitur eu interdum augue. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam non feugiat mauris. Pellentesque condimentum mauris eget eleifend sodales.",
  "Morbi sagittis urna in pretium pellentesque. Sed ultricies orci ut imperdiet pretium. Sed pharetra tincidunt.",
  "Maecenas id dictum sapien, eget pretium tortor. Mauris at metus vehicula ligula malesuada laoreet. Ut nec sodales.",
  "Donec sollicitudin volutpat erat, non."
]

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

let cells: [String] = (0..<cellCount).map { idx in
  return randomValueFrom(messages)
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
      cell.configure(cells[indexPath.row])
      return cell
    case .user:
      let cell: MessageUserCell = tableView.dequeueReusableCell(indexPath: indexPath)
      cell.configure(cells[indexPath.row])
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
