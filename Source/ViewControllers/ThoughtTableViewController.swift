import UIKit
import Agrume
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
        cell.configure(thought, imageTapped: { (image, images) in
          let agrume = Agrume(
            images: images,
            startIndex: images.indexOf(image)
          )
          agrume.showFrom(self)
        })
      }
      .addDisposableTo(disposeBag)

    thoughtActivity = ActivityIdentifier.activity(for: thought)
    thoughtActivity?.becomeCurrent()
  }
}

// MARK: UITableViewDelegate
extension ThoughtTableViewController {
  override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return ThoughtDetailTableViewCell.estimatedHeight
  }

  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }
}
