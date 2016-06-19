import UIKit
import BotnetKit
import RxSwift
import RxCocoa

final class ThoughtTableViewController: UITableViewController {
  var thought: Thought!

  let disposeBag = DisposeBag()

  override func viewDidLoad() {
    Database.observeObject(ref: thought.childRef)
      .startWith(thought)
      .map { [$0] }
      .bindTo(tableView.rx_itemsWithCellIdentifier(ThoughtDetailTableViewCell.self)) { (_, thought, cell) in
        cell.configure(thought)
      }
      .addDisposableTo(disposeBag)
  }
}
