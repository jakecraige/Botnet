import UIKit

final class ImageCarouselContainerView: UIView {
  let carousel = ImageCarouselView.loadFromNib()

  override func awakeFromNib() {
    carousel.translatesAutoresizingMaskIntoConstraints = false
    addSubview(carousel)

    NSLayoutConstraint.activateConstraints([
      carousel.leadingAnchor.constraintEqualToAnchor(leadingAnchor),
      carousel.trailingAnchor.constraintEqualToAnchor(trailingAnchor),
      carousel.topAnchor.constraintEqualToAnchor(topAnchor),
      carousel.bottomAnchor.constraintEqualToAnchor(bottomAnchor)
    ])
  }
}
