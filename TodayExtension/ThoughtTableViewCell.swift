import BotnetKit
import RxSwift
import UIKit

class ThoughtTableViewCell: UITableViewCell {
  var disposeBag = DisposeBag()

  func configure(thought: Thought) {
    disposeBag = DisposeBag() // Reset observers since this is reused

    textLabel?.text = thought.text

    thought.user()
      .map { $0.name }
      .catchErrorJustReturn("Error loading author")
      .subscribeNext { [weak self] in self?.detailTextLabel?.text = $0 }
      .addDisposableTo(disposeBag)
  }
}
