import UIKit
import BotnetKit
import RxSwift
import RxCocoa
import NotificationCenter

private enum State {
  case loading
  case loaded([Thought])

  var rowCount: Int {
    switch self {
    case .loading:
      return 1
    case let .loaded(thoughts):
      return thoughts.count
    }
  }
}

class TodayViewController: UITableViewController, NCWidgetProviding {
  private var state = State.loading {
    didSet {
      tableView.reloadData()
      preferredContentSize = tableView.contentSize
    }
  }
  var disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.allowsSelection = false
    session.configure()
    observeThoughts()
  }

  func observeThoughts() {
    Database<Thought>.observeArray(orderBy: "createdAt", sort: .desc, limit: .last(3))
      .startWith([])
      .subscribe(
        onNext: { thoughts in
          self.state = thoughts.isEmpty ? .loading : .loaded(thoughts)
        },
        onError: { error in
          print(error)
        }
      )
      .addDisposableTo(disposeBag)
  }

  func widgetPerformUpdateWithCompletionHandler(completionHandler: (NCUpdateResult) -> Void) {
    disposeBag = DisposeBag()
    observeThoughts()
  }
}

extension TodayViewController {
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return state.rowCount
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    switch state {
    case .loading:
      let cell = tableView.dequeueReusableCellWithIdentifier("LoadingTableViewCell", forIndexPath: indexPath)
      return cell
    case let .loaded(thoughts):
      let cell = tableView.dequeueReusableCellWithIdentifier("ThoughtTableViewCell", forIndexPath: indexPath) as! ThoughtTableViewCell
      cell.configure(thoughts[indexPath.row])
      return cell
    }
  }
}
