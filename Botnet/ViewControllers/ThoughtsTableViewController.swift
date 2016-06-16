import UIKit
import Firebase
import RxSwift
import RxCocoa

final class ThoughtsTableViewController: UITableViewController {
  let controller = ThoughtsController()
  let disposeBag = DisposeBag()

  override func viewDidLoad() {
    let thoughts = controller.thoughts.asObservable()

    thoughts
      .bindTo(tableView.rx_itemsWithCellIdentifier(ThoughtTableViewCell.self)) { (_, thought, cell) in
        cell.configure(thought)
      }
      .addDisposableTo(disposeBag)
  }

  @IBAction func unwindToThoughts(segue: UIStoryboardSegue) {}

  @IBAction func signOutTapped(sender: UIBarButtonItem) {
    do {
      try FIRAuth.auth()?.signOut()
    } catch {
      print("Failure to sign out:")
      print(error)
    }
  }
}

// MARK: UITableViewDelegate
extension ThoughtsTableViewController {
  override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return false
  }

  override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return ThoughtTableViewCell.estimatedHeight
  }

  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }
}
