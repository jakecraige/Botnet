extension CollectionType {
  func find(@noescape predicate: (Self.Generator.Element) throws -> Bool) rethrows -> Self.Generator.Element? {
    for item in self where try predicate(item) {
      return item
    }
    return .None
  }
}
