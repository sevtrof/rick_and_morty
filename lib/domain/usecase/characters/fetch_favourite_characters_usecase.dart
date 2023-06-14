import 'package:rick_and_morty/domain/common/either.dart';
import 'package:rick_and_morty/domain/common/failure.dart';
import 'package:rick_and_morty/domain/common/success.dart';
import 'package:rick_and_morty/data/repository/user_repository.dart';

class FetchFavouriteCharactersUseCase {
  final UserRepository userRepository;

  FetchFavouriteCharactersUseCase({required this.userRepository});

  Future<Either<Failure, Success<List<int>>>> call() async {
    return await userRepository.fetchFavoriteCharacters();
  }
}
