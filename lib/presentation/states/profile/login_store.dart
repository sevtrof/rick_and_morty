import 'package:mobx/mobx.dart';
import 'package:rick_and_morty/domain/usecase/user/user_login_status_usecase.dart';
import 'package:rick_and_morty/domain/usecase/user/user_login_usecase.dart';
import 'package:rick_and_morty/domain/usecase/user/user_logout_usecase.dart';

part 'login_store.g.dart';

class LoginStore = LoginStoreBase with _$LoginStore;

abstract class LoginStoreBase with Store {
  final UserLoginUseCase loginUseCase;
  final UserLogoutUseCase logoutUseCase;
  final UserLoginStatusUseCase loginStatusUseCase;

  LoginStoreBase({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.loginStatusUseCase,
  });

  @observable
  bool isLoggedIn = false;

  @action
  Future<void> checkLoginStatus() async {
    isLoggedIn = await loginStatusUseCase.execute();
  }

  @action
  Future<void> login(String email, String password) async {
    final result = await loginUseCase.call(email, password);
    if (result.fold((_) => false, (_) => true)) {
      await checkLoginStatus();
    }
  }

  @action
  Future<void> logout() async {
    await logoutUseCase.call();
    await checkLoginStatus();
  }
}
