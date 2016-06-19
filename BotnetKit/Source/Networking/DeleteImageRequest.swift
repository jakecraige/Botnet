import FirebaseWrapper
import RxSwift

public struct DeleteImageRequest {
  let ref: FIRStorageReference

  public init(url: NSURL) {
    ref = FIRStorage.storage().referenceForURL(url.absoluteString)
  }

  public func perform() -> Observable<Void> {
    return Observable.create { observer in
      self.ref.deleteWithCompletion { error in
        if let error = error {
          observer.onError(error)
        } else {
          observer.onNext()
        }

        observer.onCompleted()
      }
      return NopDisposable.instance
    }
  }
}
