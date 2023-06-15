import 'package:isar/isar.dart';

part 'isar_news.g.dart';

@Collection()
class NewsIsar {
  @Index()
  Id? id;

  late String content;
}
