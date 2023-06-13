import 'package:rick_and_morty/data/repository/user_repository.dart';
import 'package:rick_and_morty/domain/common/either.dart';
import 'package:rick_and_morty/domain/common/failure.dart';
import 'package:rick_and_morty/domain/common/success.dart';

class UserRegisterUseCase {
  final UserRepository userRepository;

  UserRegisterUseCase(this.userRepository);

  Future<Either<Failure, Success<Map<String, dynamic>>>> call(
      String username, String email, String password) {
    return userRepository.register(username, email, password);
  }
}
