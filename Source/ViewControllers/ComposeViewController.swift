import Agrume
import BotnetKit
import UIKit
import Kingfisher
import RxSwift
import RxCocoa

private enum State {
  case new
  case uploading
}

final class ComposeViewController: UIViewController {
  let disposeBag = DisposeBag()

  private var state = Variable(State.new)
  private var uploadedImages = [NSURL]()

  @IBOutlet var postButton: UIBarButtonItem!
  @IBOutlet var addImageButton: UIBarButtonItem!
  @IBOutlet var textView: UITextView!
  @IBOutlet var imageCarouselContainer: ImageCarouselContainerView!
  var imageCarousel: ImageCarouselView {
    return imageCarouselContainer.carousel
  }

  override func viewDidLoad() {
    textView.becomeFirstResponder()

    imageCarousel.allowCancelAction = true
    imageCarousel.imageSize = CGSize(width: 75, height: 75)
    imageCarousel.onImageTapped = { [weak self] image, images in
      guard let `self` = self else { return }
      let agrume = Agrume(images: images, startIndex: images.indexOf(image))
      agrume.showFrom(self, backgroundSnapshotVC: self.navigationController)
    }

    let textValid = textView.rx_text.asDriver().map { !$0.isEmpty }
    let notUploading = state.asDriver().map { currentState -> Bool in
      if case .new = currentState {
        return true
      } else {
        return false
      }
    }
    let readyToPost = Driver.combineLatest(textValid, notUploading) { $0 && $1 }

    notUploading
      .drive(addImageButton.rx_enabled)
      .addDisposableTo(disposeBag)

    readyToPost
      .drive(postButton.rx_enabled)
      .addDisposableTo(disposeBag)
  }

  override func viewWillDisappear(animated: Bool) {
    textView.resignFirstResponder()
    super.viewWillDisappear(animated)
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    guard let identifier = SegueIdentifier(rawValue: segue.identifier ?? "") else { return }

    switch identifier {
    case .cancelCompose: deleteUploadedImages()
    default: break
    }
  }

  @IBAction func postTapped(sender: UIBarButtonItem) {
    let thought = with(Thought.new()) {
      $0.text = self.textView.text ?? ""
      $0.userID = session.user?.id ?? "unknown user"
      $0.images = uploadedImages
    }

    Database.save(thought)
    self.dismissViewControllerAnimated(true, completion: .None)
  }

  @IBAction func addImageTapped(sender: UIBarButtonItem) {
    let controller = ImagePicker(presentingVC: self)
    controller.pickImage(ofSize: CGSize(width: 800, height: 800))
      .flatMap { UploadImageRequest(image: $0).perform() }
      .subscribeNext { [weak self] status in self?.updateUI(fromStatus: status) }
      .addDisposableTo(disposeBag)
  }
}

private extension ComposeViewController {
  func updateUI(fromStatus status: StorageUploadStatus) {
    switch status {
    case let .started(path):
      state.value = .uploading
      imageCarousel.add(forKey: path)

    case let .done(path, url):
      state.value = .new
      uploadedImages.append(url)
      configureImageDestroy(path, url: url)

    default: break
    }
  }

  func configureImageDestroy(path: String, url: NSURL) {
    imageCarousel.configureView(key: path, url: url, cancelTapped: {
      DeleteImageRequest(url: url)
        .perform()
        .subscribe()
        .addDisposableTo(self.disposeBag)
      self.imageCarousel.remove(atKey: path)
    })
  }

  func deleteUploadedImages() {
    uploadedImages
      .toObservable()
      .flatMap { DeleteImageRequest(url: $0).perform() }
      .subscribe()
      .addDisposableTo(disposeBag)
  }
}
