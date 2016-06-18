import FirebaseWrapper
import RxSwift

public struct CreateUserFromFIRUserRequest {
  let firUser: FIRUser

  public init(firUser: FIRUser) {
    self.firUser = firUser
  }

  public func perform() -> Observable<User> {
    let user = User(
      id: firUser.uid,
      name: firUser.displayName ?? "Unknown",
      email: firUser.email ?? ""
    )

    return Database.exists(user).flatMap { exists -> Observable<User> in
      if exists {
        return Database.observeObject(ref: user.childRef).take(1)
      } else {
        return .just(with(user) { Database.save($0) })
      }
    }
  }
}
