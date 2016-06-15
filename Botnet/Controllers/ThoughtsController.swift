import UIKit
import RxSwift

final class ThoughtsController {
  let disposeBag = DisposeBag()

  var thoughts = Variable([Thought]())

  init() {
    Database.observeArray()
      .bindTo(self.thoughts)
      .addDisposableTo(disposeBag)
  }
}
