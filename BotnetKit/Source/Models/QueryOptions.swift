import FirebaseDatabase

public enum SortOrder {
  /// Ascending - order a..z, 1..9
  case asc
  /// Descending order z..a, 9..1
  case desc
}

public enum Limit {
  case first(UInt)
  case last(UInt)
  case none
}

public struct QueryOptions {
  let orderBy: String?
  let sort: SortOrder
  let limit: Limit

  static var empty: QueryOptions {
    return .init()
  }

  public init(orderBy: String? = .None, sort: SortOrder = .asc, limit: Limit = .none) {
    self.orderBy = orderBy
    self.sort = sort
    self.limit = limit
  }

  func generate(forQuery query: FIRDatabaseQuery) -> FIRDatabaseQuery {
    var query = query

    if let orderBy = orderBy {
      query = query.queryOrderedByChild(orderBy)
    }

    switch limit {
    case let .first(num):
      query = query.queryLimitedToFirst(num)
    case let .last(num):
      query = query.queryLimitedToLast(num)
    case .none: break
    }

    return query
  }
}