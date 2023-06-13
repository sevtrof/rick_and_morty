import 'package:rick_and_morty/data/model/user/user.dart' as data;
import 'package:rick_and_morty/domain/entity/user/user.dart' as domain;

extension UserDataExtension on data.User {
  domain.User toDomain() {
    return domain.User(
      name: name,
      email: email,
      profilePicture: profilePicture,
    );
  }
}
