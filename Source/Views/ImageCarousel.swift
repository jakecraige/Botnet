import UIKit
import Reusable

final class ImageCarouselView: UIScrollView, NibLoadable {
  @IBOutlet var stackView: UIStackView!

  var allowCancelAction: Bool = false

  private var viewCache = [String: ImagePreviewView]()

  func add(forKey key: String) -> ImagePreviewView {
    guard viewCache[key] == .None else { return viewCache[key]! }

    let imageView = ImagePreviewView.loadFromNib()
    imageView.allowCancelAction = allowCancelAction
    viewCache[key] = imageView

    NSLayoutConstraint.activateConstraints([
      imageView.widthAnchor.constraintEqualToConstant(75),
      imageView.heightAnchor.constraintEqualToConstant(75)
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
