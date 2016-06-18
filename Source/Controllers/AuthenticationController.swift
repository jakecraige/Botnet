import BotnetKit
import RxSwift
import FirebaseWrapper

final class AuthenticationController {
  func save(firUser: FIRUser) -> Observable<User> {
    return CreateUserFromFIRUserRequest(firUser: firUser).perform()
  }
}
