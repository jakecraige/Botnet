import UIKit
import BotnetKit
import RxSwift

final class ThoughtsController {
  let disposeBag = DisposeBag()

  var thoughts = Variable([Thought]())

  init() {
    Database.observeArray(options: QueryOptions(orderBy: "createdAt", sort: .desc))
      .bindTo(self.thoughts)
      .addDisposableTo(disposeBag)
  }
}
