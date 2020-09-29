import 'dart:convert' as json;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:shamand/serial/serializers.dart';

part 'json_parsing.g.dart';

abstract class Article implements Built<Article, ArticleBuilder> {
  static Serializer<Article> get serializer => _$articleSerializer;

  Article._();

  @nullable
  int get id;

  @nullable
  bool get deleted;

  String get type;

  String get by;

  int get time;

  @nullable
  String get text;

  @nullable
  bool get dead;

  @nullable
  int get parent;

  @nullable
  int get poll;

  BuiltList<int> get kids;

  @nullable
  String get url;

  @nullable
  int get score;

  @nullable
  String get title;

  BuiltList<int> get parts;

  @nullable
  int get descendants;

  factory Article([void Function(ArticleBuilder) updates]) = _$Article;
}

List<int> parseTopSeries(String jsonStr) {
  // final parsed = json.decode(jsonStr);
  // final listOfIds = List<int>.from(parsed);
  // return listOfIds;
  return [];
}

Article parseArticle(String jsonStr) {
  final parsed = json.jsonDecode(jsonStr);
  Article article = serializersStandard.deserializeWith(Article.serializer, parsed);
  return article;
}
