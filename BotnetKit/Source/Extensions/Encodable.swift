import Foundation

public protocol Encodable {
  /// Returns a dictionary encoding of this object
  func encode() -> [String: AnyObject]
}
