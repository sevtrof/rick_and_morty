import 'package:rick_and_morty/domain/common/either.dart';
import 'package:rick_and_morty/domain/common/failure.dart';
import 'package:rick_and_morty/domain/common/success.dart';
import 'package:rick_and_morty/data/repository/user_repository.dart';

class AddFavouriteCharacterUseCase {
  final UserRepository userRepository;

  AddFavouriteCharacterUseCase({required this.userRepository});

  Future<Either<Failure, Success<void>>> call(int characterId) {
    return userRepository.addFavoriteCharacter(characterId);
  }
}
