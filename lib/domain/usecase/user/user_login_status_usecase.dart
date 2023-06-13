import 'package:rick_and_morty/data/repository/user_repository.dart';

class UserLoginStatusUseCase {
  final UserRepository _userRepository;

  UserLoginStatusUseCase(this._userRepository);

  Future<bool> execute() async {
    return _userRepository.isLoggedIn();
  }
}
