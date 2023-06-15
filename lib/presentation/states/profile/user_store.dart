import 'package:mobx/mobx.dart';
import 'package:rick_and_morty/domain/entity/user/user.dart';
import 'package:rick_and_morty/domain/usecase/characters/fetch_favourite_characters_usecase.dart';
import 'package:rick_and_morty/domain/usecase/user/user_login_status_usecase.dart';
import 'package:rick_and_morty/domain/usecase/user/user_login_usecase.dart';
import 'package:rick_and_morty/domain/usecase/user/user_logout_usecase.dart';

part 'user_store.g.dart';

class UserStore = UserStoreBase with _$UserStore;

abstract class UserStoreBase with Store {
  final UserLoginUseCase loginUseCase;
  final UserLogoutUseCase logoutUseCase;
  final UserLoginStatusUseCase loginStatusUseCase;
  final FetchFavouriteCharactersUseCase fetchFavouriteCharactersUseCase;

  UserStoreBase({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.loginStatusUseCase,
    required this.fetchFavouriteCharactersUseCase,
  });

  @observable
  bool isLoggedIn = false;

  @observable
  User user = const User(
      name: 'name', email: 'email', profilePicture: 'profilePicture');

  @observable
  List<int> favoriteCharacters = [];

  @action
  Future<void> logout() async {
    await logoutUseCase.call();
  }

  @action
  Future<void> checkLoginStatus() async {
    isLoggedIn = await loginStatusUseCase.execute();
  }

  @action
  Future<void> login(String email, String password) async {
    final result = await loginUseCase.call(email, password);
    var resultUser = result.success?.value['user'];
    user = User(
      name: resultUser['Username'],
      email: resultUser['Email'],
      profilePicture: resultUser['Avatar'],
    );
    if (result.fold((_) => false, (_) => true)) {
      await checkLoginStatus();
    }
  }
}
