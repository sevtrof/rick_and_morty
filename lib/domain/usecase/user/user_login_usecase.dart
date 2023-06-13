import 'package:rick_and_morty/data/repository/user_repository.dart';
import 'package:rick_and_morty/domain/common/either.dart';
import 'package:rick_and_morty/domain/common/failure.dart';
import 'package:rick_and_morty/domain/common/success.dart';

class UserLoginUseCase {
  final UserRepository userRepository;

  UserLoginUseCase(this.userRepository);

  Future<Either<Failure, Success<Map<String, dynamic>>>> call(
      String email, String password) {
    return userRepository.login(email, password);
  }
}
