import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:rick_and_morty/presentation/states/news/news_store.dart';
import 'package:rick_and_morty/styles/dimensions.dart';
import 'package:rick_and_morty/styles/text_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  NewsScreenState createState() => NewsScreenState();
}

class NewsScreenState extends State<NewsScreen> {
  final NewsStore newsStore = GetIt.I<NewsStore>();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    newsStore.fetchNews();

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    const threshold = 200.0;
    if (!_isLoading &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - threshold) {
      _isLoading = true;
      newsStore.fetchNews().then((_) {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).news),
      ),
      body: Observer(
        builder: (_) {
          if (newsStore.newsList.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.all(AppDimensions.PADDING_8),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: newsStore.newsList.length,
                itemBuilder: (context, index) {
                  final news = newsStore.newsList[index];
                  return Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.RADIUS_10),
                    ),
                    child: ListTile(
                      title: Text(
                          '${AppLocalizations.of(context).news} ${index + 1}',
                          style: AppTextStyles.bodyText),
                      subtitle: Text(news.content),
                      isThreeLine: true,
                      onTap: () {},
                    ),
                  );
                },
              ),
            );
          } else if (newsStore.error != null) {
            return Center(child: Text(newsStore.error!));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
