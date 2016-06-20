import UIKit
import Kingfisher
import Reusable

final class ImagePreviewView: UIView, NibLoadable {
  @IBOutlet var imageView: UIImageView!
  @IBOutlet var xButtonBackgroundView: UIView!
  @IBOutlet var xButton: UIButton!

  var allowCancelAction: Bool = false

  private var imageTapped: ((UIImage) -> Void)?
  private var xTapped: (() -> Void)?

  override func awakeFromNib() {
    xButtonBackgroundView.layer.cornerRadius = 10
    xButtonBackgroundView.hidden = true
    imageView.kf_showIndicatorWhenLoading = true
    imageView.kf_indicator?.startAnimating()
  }

  func configure(url: NSURL, cancelTapped: (() -> Void)? = .None, imageTapped: ((UIImage) -> Void)? = .None) {
    if let imageTapped = imageTapped {
      self.imageTapped = imageTapped
    }
    xTapped = cancelTapped
    imageView.kf_setImageWithURL(url, completionHandler: { [weak self] _ in
      guard let `self` = self else { return }
      if self.allowCancelAction {
        self.xButtonBackgroundView.hidden = false
      }
    })
  }

  @IBAction func xButtonTapped() {
    xTapped?()
  }

  @IBAction func imageTapped(sender: UITapGestureRecognizer) {
    guard let image = imageView.image else { return }
    imageTapped?(image)
  }
}
