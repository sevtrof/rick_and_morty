import 'package:rick_and_morty/domain/common/either.dart';
import 'package:rick_and_morty/domain/common/failure.dart';
import 'package:rick_and_morty/domain/common/success.dart';

abstract class UserRepository {
  Future<Either<Failure, Success<Map<String, dynamic>>>> register(
    String username,
    String email,
    String password,
  );

  Future<Either<Failure, Success<Map<String, dynamic>>>> login(
      String email, String password);

  Future<Either<Failure, Success<void>>> logout();

  Future<bool> isLoggedIn();
}
