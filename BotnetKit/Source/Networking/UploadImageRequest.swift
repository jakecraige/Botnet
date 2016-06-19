import FirebaseWrapper
import RxSwift

public enum StorageUploadStatus {
  case started
  case pause
  case resume
  case progress(NSProgress)
  case done(NSURL)
}

public struct UploadImageRequest {
  let image: UIImage
  let compressionQuality: Float

  public init(image: UIImage, compressionQuality: Float = 0.5) {
    self.image = image
    self.compressionQuality = compressionQuality
  }

  private var jpegData: NSData {
    return UIImageJPEGRepresentation(image, CGFloat(compressionQuality))!
  }

  public func perform() -> Observable<StorageUploadStatus> {
    let rootRef = FIRStorage.storage().reference().child("photos")
    let childRef = rootRef.child("\(NSUUID().UUIDString).jpg")
    let metadata = with(FIRStorageMetadata()) { $0.contentType = "image/jpeg" }

    return Observable.create { observer in
      observer.onNext(.started)

      let task = childRef.putData(self.jpegData, metadata: metadata)
      task.observeStatus(.Pause) { _ in observer.onNext(.pause) }
      task.observeStatus(.Resume) { _ in observer.onNext(.resume) }
      task.observeStatus(.Progress) { snapshot in
        guard let progress = snapshot.progress else { return }
        observer.onNext(.progress(progress))
      }
      task.observeStatus(.Failure) { snapshot in
        if let error = snapshot.error {
          observer.onError(error)
        } else {
          observer.onError(NSError.botnet("Unknown upload failure"))
        }
        observer.onCompleted()
      }
      task.observeStatus(.Success) { snapshot in
        snapshot.reference.downloadURLWithCompletion { (url, error) in
          if let error = error {
            observer.onError(error)
            observer.onCompleted()
          }

          guard let url = url else {
            observer.onError(NSError.botnet("Expected a download URL but one wasn't given"))
            return observer.onCompleted()
          }

          observer.onNext(.done(url))
          observer.onCompleted()
        }
      }

      return AnonymousDisposable { task.cancel() }
    }
  }
}