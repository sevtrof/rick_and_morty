import 'package:mobx/mobx.dart';
import 'package:rick_and_morty/domain/usecase/user/user_register_usecase.dart';

part 'registration_store.g.dart';

class RegistrationStore = RegistrationStoreBase with _$RegistrationStore;

abstract class RegistrationStoreBase with Store {
  final UserRegisterUseCase registerUseCase;

  RegistrationStoreBase({
    required this.registerUseCase,
  });

  @observable
  bool registrationSuccess = false;

  @action
  Future<void> register(
    String username,
    String email,
    String password,
    Function onSuccess,
  ) async {
    final result = await registerUseCase.call(username, email, password);
    registrationSuccess = result.fold((_) => false, (_) => true);
    if (registrationSuccess) {
      onSuccess();
    }
  }
}
