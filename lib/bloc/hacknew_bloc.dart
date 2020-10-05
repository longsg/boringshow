import 'dart:async';
import 'dart:collection';
import 'package:rxdart/subjects.dart';
import 'package:http/http.dart' as http;
import 'package:shamand/model/article.dart';

enum StoryType { topStories, newStory }

class HackerNewBloc {
  Stream<UnmodifiableListView<Article>> get topStories =>
      _topStoriesSubject.stream;

  Stream<UnmodifiableListView<Article>> get newStories =>
      _newStoriesSubject.stream;
  static const String _baseUrl = "https://hacker-news.firebaseio.com/v0/";
  final _topStoriesSubject = BehaviorSubject<UnmodifiableListView<Article>>();

  final _newStoriesSubject = BehaviorSubject<UnmodifiableListView<Article>>();

  Sink<StoryType> get storyType => _storyTypeController.sink;
  final _storyTypeController = StreamController<StoryType>();

  Stream<bool> get isLoading => _isLoadingSubject.stream;

  final _isLoadingSubject = BehaviorSubject<bool>.seeded(false);
  var _articleList = <Article>[];
  HashMap<int, Article> _articlesMap;

//constructor cant not async
  HackerNewBloc() {
    _articlesMap = HashMap<int, Article>();
    // _updateArticle(_topId)
    //     .then((_) => _articleSubject.add(UnmodifiableListView(_articleList)));
    // _getUpdateArticle(_topId);
    _initsArticles();
    _storyTypeController.stream.listen((storyType) async {
      // if (event == StoryType.newStory) {
      //   // _getUpdateArticle(_newId);
      //   _getIdType(StoryType.newStory);
      // }
      // if (event == StoryType.topStories) {
      //   // _getUpdateArticle(_topId);
      //   _getIdType(StoryType.topStories);
      // }
      _getUpdateArticle(
          _topStoriesSubject, await _getIdType(StoryType.topStories));
      _getUpdateArticle(
          _newStoriesSubject, await _getIdType(StoryType.newStory));
    });
  }

  void close() {
    _storyTypeController.close();
  }

  Future<Null> _updateArticle(List<int> articleId) async {
    final furuteArticle = articleId.map((e) => _getArticle(e));
    final article = await Future.wait(furuteArticle);
    _articleList = article;
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

  _getUpdateArticle(BehaviorSubject<UnmodifiableListView<Article>> subject,
      List<int> ids) async {
    _isLoadingSubject.add(true);
    await _updateArticle(ids);
    subject.add(UnmodifiableListView(_articleList));
    _isLoadingSubject.add(false);
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
    _getUpdateArticle(
        _topStoriesSubject, await _getIdType(StoryType.topStories));
    _getUpdateArticle(
        _newStoriesSubject, await _getIdType(StoryType.topStories));
  }
}
