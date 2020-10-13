import 'dart:async';
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shamand/model/article.dart';

enum StoryType { topStories, newStory }

class HackerNewNotifier extends ChangeNotifier {
  static const String _baseUrl = "https://hacker-news.firebaseio.com/v0/";
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<Article> _topArticles = [];
  List<Article> _newArticles = [];
  List<Article> _articles = [];

  UnmodifiableListView<Article> get article => UnmodifiableListView(_articles);

  UnmodifiableListView<Article> get topArticle => UnmodifiableListView(_topArticles);

  UnmodifiableListView<Article> get newArticle => UnmodifiableListView(_newArticles);

  StoryType _storyType;

  StoryType get storiesType => _storyType;
  HashMap<int, Article> _articlesMap;

//constructor cant not async
  HackerNewNotifier() {
    _articlesMap = HashMap<int, Article>();
    // _initsArticles();
    getStoriesType(StoryType.topStories);
  }

  Future<void> getStoriesType(StoryType type) async {
    _isLoading = true;
    notifyListeners();
    var id = await _getIdType(type);
    _articles = await _updateArticle(id);
    switch (type) {
      case StoryType.topStories:
        _topArticles = _articles;
        break;
      case StoryType.newStory:
        _newArticles = _articles;
        break;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<List<Article>> _updateArticle(List<int> articleId) async {
    final futureArticle = articleId.map((e) => _getArticle(e));
    final all = await Future.wait(futureArticle);
    var filtered = all.where((element) => element.title != null).toList();
    return filtered;
  }

  Future<Article> _getArticle(int id) async {
    if (!_articlesMap.containsKey(id)) {
      final storyUrl = "${_baseUrl}item/$id.json";
      final res = await http.get(storyUrl);
      print('storyArticle Url $storyUrl');
      if (res.statusCode != 200) throw Exception("couldn't fetched ");
      _articlesMap[id] = parseArticle(res.body);
    }
    return _articlesMap[id];
  }

  Future<List<int>> _getIdType(StoryType type) async {
    final String partUrl = type == StoryType.topStories ? 'top' : 'new';
    final url = "$_baseUrl${partUrl}stories.json";
    print('url $url');
    final reponse = await http.get(url);
    if (reponse.statusCode != 200) {
      throw Exception("Couldn't fetched $type ");
    }
    return parseStories(reponse.body).take(10).toList();
  }

  Future<void> _initsArticles() async {
    var id = await _getIdType(StoryType.topStories);
    await _updateArticle(id);
    notifyListeners();
  }
}
