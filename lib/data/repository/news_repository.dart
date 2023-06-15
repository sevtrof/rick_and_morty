import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rick_and_morty/data/model/isar/news/isar_news.dart';
import 'package:rick_and_morty/data/model/news/news.dart';
import 'package:rick_and_morty/data/service/news/news_api_service.dart';

class NewsRepository {
  final NewsApiService service;
  Isar? isar;

  NewsRepository(this.service);

  Future<List<News>> getNewsFromIsar() async {
    if (isar == null) {
      final directory = await getApplicationDocumentsDirectory();
      isar = await Isar.open([NewsIsarSchema], directory: directory.path);
    }

    final newsItems = await isar!.newsIsars.where().findAll();
    return newsItems
        .map((newsItemIsar) => News(content: newsItemIsar.content))
        .toList();
  }

  Future<void> saveNewsToIsar(List<News> newsItems) async {
    if (isar == null) {
      final directory = await getApplicationDocumentsDirectory();
      isar = await Isar.open([NewsIsarSchema], directory: directory.path);
    }

    await isar!.writeTxn(() async {
      for (var newsItem in newsItems) {
        var newsItemIsar = NewsIsar()..content = newsItem.content;
        await isar!.newsIsars.put(newsItemIsar);
      }
    });
  }

  Future<List<News>> fetchNewsFromApi(int page) async {
    try {
      final response = await service.fetchNews(page);
      if (response.response.statusCode == 200) {
        if (response.data is List) {
          final List<dynamic> newsData = response.data;
          final List<News> newsItems =
              newsData.map((item) => News.fromJson(item)).toList();
          saveNewsToIsar(newsItems);
          return newsItems;
        } else {
          throw Exception('Data is not a list');
        }
      } else {
        throw Exception('Failed to load news');
      }
    } catch (error) {
      throw Exception('Error fetching news from API: $error');
    }
  }
}
