import Argo
import RxSwift
import FirebaseWrapper

public enum SortOrder {
  /// Ascending - order a..z, 1..9
  case asc
  /// Descending order z..a, 9..1
  case desc
}

public enum QueryLimit {
  case first(UInt)
  case last(UInt)
  case none
}

/// Returned when a reference you try to subscribe to doesn't exist
public struct NullRefError: ErrorType {
  let message: String
  var debugDescription: String { return message }

  init(_ ref: FIRDatabaseQuery) {
    message = "Attempted to observer null reference for \(ref)"
  }
}

public struct Database<Model: Modelable where Model.DecodedType == Model> {
  public static func save(model: Model) -> String {
    let ref = model.childRef
    var values = model.encode()

    if let tModel = model as? Timestampable {
      values["timestamps/updated_at"] = FIRServerValue.timestamp()
      if tModel.timestamps?.createdAt == .None {
        values["timestamps/created_at"] = FIRServerValue.timestamp()
      }
    }

    ref.updateChildValues(values)
    return ref.key
  }

  public static func delete(model: Model) {
    model.childRef.removeValue()
  }

  public static func exists(model: Model) -> Observable<Bool> {
    return Observable.create { observer in
      model.childRef.observeSingleEventOfType(
        .Value,
        withBlock: { snapshot in
          observer.onNext(snapshot.exists())
          observer.onCompleted()
        },
        withCancelBlock: { error in
          observer.onError(error)
          observer.onCompleted()
        }
      )
      return NopDisposable.instance
    }
  }

  public static func find(
    eventType eventType: FIRDataEventType = .Value,
              ref: FIRDatabaseQuery = Model.ref,
              ids: [String]
    ) -> Observable<[Model]>
  {
    let queries = ids.map { id in observeObject(ref: Model.getChildRef(id)) }
    return queries.combineLatest { $0 }
  }

  public static func allWhere(eventType eventType: FIRDataEventType = .Value, ref: FIRDatabaseQuery = Model.ref, key: String, value: AnyObject) -> Observable<[Model]> {
    let query = ref.queryOrderedByChild(key).queryStartingAtValue(value).queryEndingAtValue(value)
    return Observable.create { observer in
      let observerHandle = query.observeEventType(
        eventType,
        withBlock: { observer.onNext(decodeChildren($0)) },
        withCancelBlock: { observer.onError($0) }
      )

      return AnonymousDisposable {
        query.removeObserverWithHandle(observerHandle)
      }
    }
  }

  public static func observeArray(eventType eventType: FIRDataEventType = .Value, ref: FIRDatabaseQuery = Model.ref, orderBy: String? = .None, sort: SortOrder = .asc, limit: QueryLimit = .none) -> Observable<[Model]> {
    var query = ref
    return Observable.create { observer in
      if let orderBy = orderBy {
        query = ref.queryOrderedByChild(orderBy)
      }

      switch limit {
      case let .first(num):
        query = query.queryLimitedToFirst(num)
      case let .last(num):
        query = query.queryLimitedToLast(num)
      case .none: break
      }

      let observerHandle = query.observeEventType(
        eventType,
        withBlock: { observer.onNext(convertSnapshot($0, sort: sort)) },
        withCancelBlock: { observer.onError($0) }
      )
      return AnonymousDisposable {
        query.removeObserverWithHandle(observerHandle)
      }
    }
  }

  public static func observeObject(eventType eventType: FIRDataEventType = .Value, ref: FIRDatabaseQuery = Model.ref) -> Observable<Model> {
    return Observable.create { observer in
      let observerHandle = ref.observeEventType(
        eventType,
        withBlock: { snapshot in
          if snapshot.exists() {
            _ = convertSnapshot(snapshot).map(observer.onNext)
          } else {
            observer.onError(NullRefError(ref))
            observer.onCompleted()
          }
        },
        withCancelBlock: { observer.onError($0) }
      )
      return AnonymousDisposable {
        ref.removeObserverWithHandle(observerHandle)
      }
    }
  }

  public static func observeArrayOnce(eventType eventType: FIRDataEventType = .Value, ref: FIRDatabaseQuery = Model.ref, orderBy: String? = .None, sort: SortOrder = .asc) -> Observable<[Model]> {
    var query = ref
    return Observable.create { observer in
      if let orderBy = orderBy {
        query = ref.queryOrderedByChild(orderBy)
      }

      query.observeSingleEventOfType(
        eventType,
        withBlock: { observer.onNext(convertSnapshot($0, sort: sort)) },
        withCancelBlock: { observer.onError($0) }
      )
      return NopDisposable.instance
    }
  }

  public static func observeObjectOnce(eventType eventType: FIRDataEventType = .Value, ref: FIRDatabaseQuery = Model.ref) -> Observable<Model> {
    return Observable.create { observer in
      ref.observeSingleEventOfType(
        eventType,
        withBlock: { snapshot in
          if snapshot.exists() {
            _ = convertSnapshot(snapshot).map(observer.onNext)
          } else {
            print(NullRefError(ref))
          }
        },
        withCancelBlock: { observer.onError($0) }
      )
      return NopDisposable.instance
    }
  }
}

// MARK: Private Methods
private extension Database {
  static func convertSnapshot(snapshot: FIRDataSnapshot, sort: SortOrder) -> [Model] {
    let children = decodeChildren(snapshot)
    switch sort {
    case .asc: return children // Firebase default sort is asc
    case .desc: return children.reverse()
    }
  }

  static func convertSnapshot(snapshot: FIRDataSnapshot) -> Model? {
    guard snapshot.exists() else { return  .None }
    return decodeAndLogError(snapshot.asDictionary)
  }

  static func decodeChildren(snapshot: FIRDataSnapshot) -> [Model] {
    return snapshot.children
      .flatMap { ($0 as? FIRDataSnapshot)?.asDictionary }
      .flatMap(decodeAndLogError)
  }

  static func decodeAndLogError(dict: [String: AnyObject]) -> Model? {
    switch decode(dict) as Decoded<Model> {
    case let .Success(obj):
      return obj

    case let .Failure(err):
      print("---------------------------------------------------------------------")
      print("Decoding Error: Failed to decode a model of type '\(String(Model))'.")
      print("Dictionary was: \(dict)")
      print("Error was: \(err)")
      print("---------------------------------------------------------------------")
      return .None
    }
  }
}