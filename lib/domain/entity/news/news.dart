import 'package:freezed_annotation/freezed_annotation.dart';

part 'news.freezed.dart';
part 'news.g.dart';

@freezed
abstract class News with _$News {
  const factory News({
    required String content,
  }) = _News;

  factory News.fromJson(Map<String, dynamic> json) =>
      _$NewsFromJson(json);
}
