import UIKit
import BotnetKit
import RxSwift
import RxCocoa
import Toucan

final class ImagePicker {
  // Take Photo, Use Last Photo taken, Choose From Library
  let presentingVC: UIViewController

  init(presentingVC: UIViewController) {
    self.presentingVC = presentingVC
  }

  func pickImage(ofSize size: CGSize) -> Observable<UIImage> {
    return chooseSource()
      .flatMap { self.choosePhoto(sourceType: $0) }
      .flatMap { self.convert(toSize: size, image: $0) }
  }
}

private extension ImagePicker {
  func chooseSource() -> Observable<UIImagePickerControllerSourceType> {
    return Observable.create { observer in
      let actionSheet = UIAlertController(title: .None, message: .None, preferredStyle: .ActionSheet)
      let cancel = UIAlertAction(title: "Cancel", style: .Cancel) { _ in
        observer.onCompleted()
      }
      let takePhoto = UIAlertAction(title: "Take Photo", style: .Default) { _ in
        observer.onNext(.Camera)
        observer.onCompleted()
      }
      let chooseFromLibrary = UIAlertAction(title: "Choose From Library", style: .Default) { _ in
        observer.onNext(.PhotoLibrary)
        observer.onCompleted()
      }
      actionSheet.addAction(cancel)
      actionSheet.addAction(takePhoto)
      actionSheet.addAction(chooseFromLibrary)
      
      self.presentingVC.presentViewController(actionSheet, animated: true, completion: .None)

      return NopDisposable.instance
    }
  }

  func choosePhoto(sourceType sourceType: UIImagePickerControllerSourceType) -> Observable<UIImage> {
    let picker = UIImagePickerController()
    picker.sourceType = sourceType
    presentingVC.presentViewController(picker, animated: true, completion: .None)
    let dismiss = { self.presentingVC.dismissViewControllerAnimated(true, completion: .None) }

    return Observable.create { observer in
      let didCancel = picker.rx_didCancel.subscribeNext(dismiss)
      let didFinish = picker.rx_didFinishPickingMediaWithInfo
        .doOnNext { _ in dismiss() }
        .flatMap { info -> Observable<UIImage> in
          guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return Observable.error(NSError.botnet("No image picked"))
          }
          
          return Observable.just(image)
        }
        .bindTo(observer)

      return AnonymousDisposable {
        didCancel.dispose()
        didFinish.dispose()
      }
    }
  }

  func convert(toSize size: CGSize, image: UIImage) -> Observable<UIImage> {
    let convertedImage = Toucan.Resize.resizeImage(image, size: size, fitMode: .Clip)
    return Observable.just(convertedImage)
  }
}
