enum Gender { female, male, genderless, unknown, empty }

extension GenderExtension on Gender {
  String get value {
    switch (this) {
      case Gender.female:
        return 'female';
      case Gender.male:
        return 'male';
      case Gender.genderless:
        return 'genderless';
      case Gender.unknown:
        return 'unknown';
      case Gender.empty:
      default:
        return '';
    }
  }
}
