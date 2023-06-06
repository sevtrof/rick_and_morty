import 'package:rick_and_morty/data/model/location/location.dart' as data;
import 'package:rick_and_morty/domain/entity/location/location.dart' as domain;

extension LocationDataExtension on data.Location {
  domain.Location toDomain() {
    return domain.Location(
      name: name,
      url: url,
    );
  }
}
