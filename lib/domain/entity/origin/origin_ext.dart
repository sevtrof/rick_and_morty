import 'package:rick_and_morty/data/model/origin/origin.dart' as data;
import 'package:rick_and_morty/domain/entity/origin/origin.dart'
as domain;

extension OriginDataExtension on data.Origin {
  domain.Origin toDomain() {
    return domain.Origin(
      name: name,
      url: url,
    );
  }
}
