import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:rick_and_morty/data/repository/news_repository.dart';
import 'package:rick_and_morty/domain/entity/news/news.dart' as domain;
import 'package:rick_and_morty/domain/entity/news/news_ext.dart';

class FetchNewsUseCase {
  final NewsRepository newsRepository;

  FetchNewsUseCase({required this.newsRepository});

  Future<List<domain.News>> call(int page) async {
    List<domain.News> news;
    ConnectivityResult connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      news = (await newsRepository.getNewsFromIsar()).map((e) => e.toDomain()).toList();
      return news;
    }
    news = (await newsRepository.fetchNewsFromApi(page)).map((e) => e.toDomain()).toList();
    return news;
  }
}
