import BotnetKit
import Firebase
import RxSwift

final class AuthenticationController {
  func save(firUser: FIRUser) -> Observable<User> {
    let user = User(
      id: firUser.uid,
      name: firUser.displayName ?? "Unknown",
      email: firUser.email ?? ""
    )

    return Database.exists(user).flatMap { exists -> Observable<User> in
      if exists {
        return Database.observeObjectOnce(ref: user.childRef)
      } else {
        return .just(with(user) { Database.save($0) })
      }
    }
  }
}
