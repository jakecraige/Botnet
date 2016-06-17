import Foundation

public extension NSError {
  static func botnet(errorDescription: String) -> NSError {
    return NSError(
      domain: "com.thoughtbot.Botnet",
      code: 0,
      userInfo: [NSLocalizedDescriptionKey: errorDescription]
    )
  }
}
