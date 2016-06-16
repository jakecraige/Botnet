import Firebase
import RxSwift

extension FIRDataSnapshot {
  var asDictionary: [String: AnyObject] {
    guard var dict = value as? [String: AnyObject] else { return [:] }
    dict["id"] = key
    return dict
  }
}

extension FIRUser {
  func getToken(forceRefresh forceRefresh: Bool) -> Observable<String> {
    return Observable.create { observer in
      self.getTokenForcingRefresh(forceRefresh) { (token, error) in
        if let error = error {
          observer.onError(error)
        } else {
          if let token = token {
            observer.onNext(token)
          } else {
            observer.onError(NSError.botnet("Token not defined and but expected it to be"))
          }
        }
        observer.onCompleted()
      }
      return NopDisposable.instance
    }
  }
}
