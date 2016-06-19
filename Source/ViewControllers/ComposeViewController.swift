import BotnetKit
import UIKit
import Kingfisher
import RxSwift
import RxCocoa

private enum State {
  case new
  case uploading(ImagePreviewView)
}

final class ComposeViewController: UIViewController {
  let disposeBag = DisposeBag()

  private var state = Variable(State.new)
  private var uploadedImages = [NSURL]()

  @IBOutlet var postButton: UIBarButtonItem!
  @IBOutlet var addImageButton: UIBarButtonItem!
  @IBOutlet var textView: UITextView!
  @IBOutlet var imageStackView: UIStackView!

  override func viewDidLoad() {
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
    case .started:
      addLoadingImagePreviewView()
      
    case let .done(url):
      uploadCompleted(url)
      
    default: break
    }
  }

  func addLoadingImagePreviewView() {
    guard case .new = state.value else {
      fatalError("addLoadingImagePreviewView should only be called when status is .new")
    }

    let imageView = ImagePreviewView.loadFromNib()
    NSLayoutConstraint.activateConstraints([
      imageView.widthAnchor.constraintEqualToConstant(75),
      imageView.heightAnchor.constraintEqualToConstant(75)
    ])
    imageStackView.addArrangedSubview(imageView)

    state.value = .uploading(imageView)
  }

  func uploadCompleted(url: NSURL) {
    guard case let .uploading(imageView) = state.value else {
      fatalError("uploadCompleted should only be called when status is .uploading")
    }

    uploadedImages.append(url)
    imageView.configure(url, xTapped: {
      DeleteImageRequest(url: url)
        .perform()
        .subscribe()
        .addDisposableTo(self.disposeBag)
      self.imageStackView.removeArrangedSubview(imageView)
    })

    state.value = .new
  }

  func deleteUploadedImages() {
    uploadedImages
      .toObservable()
      .flatMap { DeleteImageRequest(url: $0).perform() }
      .subscribe()
      .addDisposableTo(disposeBag)
  }
}
