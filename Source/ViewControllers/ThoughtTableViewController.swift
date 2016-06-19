import UIKit
import BotnetKit
import RxSwift
import RxCocoa

final class ThoughtTableViewController: UITableViewController {
  var thought: Thought!
  var thoughtActivity: NSUserActivity?

  let disposeBag = DisposeBag()

  override func viewDidLoad() {
    Database.observeObject(ref: thought.childRef)
      .startWith(thought)
      .map { [$0] }
      .bindTo(tableView.rx_itemsWithCellIdentifier(ThoughtDetailTableViewCell.self)) { (_, thought, cell) in
        cell.configure(thought)
      }
      .addDisposableTo(disposeBag)

    thoughtActivity = ActivityIdentifier.activity(for: thought)
    thoughtActivity?.becomeCurrent()
  }
}
