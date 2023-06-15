import 'package:mobx/mobx.dart';
import 'package:rick_and_morty/domain/entity/news/news.dart';
import 'package:rick_and_morty/domain/usecase/news/fetch_news_usecase.dart';

part 'news_store.g.dart';

class NewsStore = NewsStoreBase with _$NewsStore;

abstract class NewsStoreBase with Store {
  final FetchNewsUseCase getNewsUseCase;

  NewsStoreBase({
    required this.getNewsUseCase,
  });

  @observable
  ObservableList<News> newsList = ObservableList<News>();

  @observable
  News? selectedNews;

  @observable
  String? error;

  @observable
  int currentPage = 1;

  @action
  Future<void> fetchNews() async {
    try {
      final result = await getNewsUseCase.call(currentPage);
      newsList.addAll(result);
      currentPage++;
    } catch (e) {
      throw Exception('Error fetching news: $e');
    }
  }
}
