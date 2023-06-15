import 'package:rick_and_morty/data/model/news/news.dart' as data;
import 'package:rick_and_morty/domain/entity/news/news.dart' as domain;

extension NewsDataExtension on data.News {
  domain.News toDomain() {
    return domain.News(
      content: content,
    );
  }
}
