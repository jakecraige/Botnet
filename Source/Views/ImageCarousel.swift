import BotnetKit
import UIKit
import Reusable

final class ImageCarouselView: UIScrollView, NibLoadable {
  @IBOutlet var stackView: UIStackView!

  var allowCancelAction: Bool = false
  var imageSize = CGSize(width: 75, height: 75)

  private var viewCache = [String: ImagePreviewView]()

  func add(fromURLs urls: [NSURL]) -> [ImagePreviewView] {
    return urls.map { add(fromURL: $0) }
  }

  func add(fromURL url: NSURL, cancelTapped: (() -> Void)? = .None) -> ImagePreviewView {
    return with(add(forKey: url.absoluteString)) {
      $0.configure(url, cancelTapped: cancelTapped)
    }
  }

  func add(forKey key: String) -> ImagePreviewView {
    guard viewCache[key] == .None else { return viewCache[key]! }

    let imageView = ImagePreviewView.loadFromNib()
    imageView.allowCancelAction = allowCancelAction
    viewCache[key] = imageView

    NSLayoutConstraint.activateConstraints([
      imageView.widthAnchor.constraintEqualToConstant(imageSize.width),
      imageView.heightAnchor.constraintEqualToConstant(imageSize.height)
    ])
    stackView.addArrangedSubview(imageView)
    return imageView
  }

  func remove(atKey key: String) {
    guard let view = viewCache[key] else { return }
    stackView.removeArrangedSubview(view)
  }

  func view(forKey key: String) -> ImagePreviewView? {
    return viewCache[key]
  }
}
