import 'package:rick_and_morty/data/repository/user_repository.dart';
import 'package:rick_and_morty/domain/common/either.dart';
import 'package:rick_and_morty/domain/common/failure.dart';
import 'package:rick_and_morty/domain/common/success.dart';

class UserLogoutUseCase {
  final UserRepository userRepository;

  UserLogoutUseCase(this.userRepository);

  Future<Either<Failure, Success<void>>> call() {
    return userRepository.logout();
  }
}
