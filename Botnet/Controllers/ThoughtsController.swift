import UIKit
import RxSwift

final class ThoughtsController {
  let disposeBag = DisposeBag()

  var thoughts = Variable([Thought]())

  init() {
    Database.observeArray(orderBy: "createdAt", sort: .desc)
      .bindTo(self.thoughts)
      .addDisposableTo(disposeBag)
  }
}
