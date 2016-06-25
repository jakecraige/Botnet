import BotnetKit
import UIKit
import Reusable

final class ImageCarouselView: UIScrollView, NibLoadable {
  @IBOutlet var stackView: UIStackView!

  var allowCancelAction: Bool = false
  var imageSize = CGSize(width: 75, height: 75)
  var onImageTapped: ((UIImage, [UIImage]) -> Void)?

  private var viewCache = [String: ImagePreviewView]()

  func reset() {
    stackView.arrangedSubviews.forEach {
      stackView.removeArrangedSubview($0)
      $0.removeFromSuperview()
    }
    viewCache = [:]
  }

  func add(fromURLs urls: [NSURL], cancelTapped: (() -> Void)? = .None) -> [ImagePreviewView] {
    return urls.map { add(fromURL: $0, cancelTapped: cancelTapped) }
  }

  func add(fromURL url: NSURL, cancelTapped: (() -> Void)? = .None) -> ImagePreviewView {
    return with(add(forKey: url.absoluteString)) {
      $0.configure(url, cancelTapped: cancelTapped, imageTapped: { [weak self] image in
        self?.handleImageTap(image)
      })
    }
  }

  func configureView(key key: String, url: NSURL, cancelTapped: (() -> Void)? = .None) {
    guard let view = view(forKey: key) else { return }

    view.configure(url, cancelTapped: cancelTapped, imageTapped: { [weak self] image in
      self?.handleImageTap(image)
    })
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

private extension ImageCarouselView {
  func handleImageTap(image: UIImage) {
    let allImages = stackView.arrangedSubviews.flatMap { ($0 as? ImagePreviewView)?.imageView.image }
    onImageTapped?(image, allImages)
  }
}
