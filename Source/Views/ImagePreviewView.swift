import UIKit
import Kingfisher
import Reusable

final class ImagePreviewView: UIView, NibLoadable {
  @IBOutlet var imageView: UIImageView!
  @IBOutlet var xButtonBackgroundView: UIView!
  @IBOutlet var xButton: UIButton!

  private var xTapped: (() -> Void)?

  override func awakeFromNib() {
    xButtonBackgroundView.layer.cornerRadius = 10
    xButtonBackgroundView.hidden = true
    imageView.kf_showIndicatorWhenLoading = true
    imageView.kf_indicator?.startAnimating()
  }

  func configure(url: NSURL, xTapped: (() -> Void)) {
    self.xTapped = xTapped
    imageView.kf_setImageWithURL(url, completionHandler: { [weak self] _ in
      self?.xButtonBackgroundView.hidden = false
    })
  }

  @IBAction func xButtonTapped() {
    xTapped?()
  }
}
