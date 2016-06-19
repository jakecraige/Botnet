import UIKit
import BotnetKit
import FirebaseWrapper
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

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    tableView.deselectAllRows(animated) // You know, UIKit bugs where it doesn't deselect rows.
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    guard let identifier = SegueIdentifier(rawValue: segue.identifier ?? "") else { return }

    switch identifier {
    case .showThought:
      let thought: Thought
      if let wrappedModel = sender as? ModelWrapper<Thought> {
        thought = wrappedModel.model
      } else {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        thought = controller.thought(forIndexPath: indexPath)
      }

      let vc = segue.destinationViewController as! ThoughtTableViewController
      vc.thought = thought
    default: break
    }
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
  override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return ThoughtTableViewCell.estimatedHeight
  }

  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }
}
