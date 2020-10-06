import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shamand/bloc/hacknew_bloc.dart';
import 'package:shamand/bloc/preference_bloc.dart';
import 'package:shamand/bloc/preference_state.dart';
import 'package:shamand/model/article.dart';
import 'package:shamand/widget/article_search.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  final bloc = HackerNewBloc();
  final prefShare = PreferenceBloc();
  runApp(MyApp(hackerNewBloc: bloc, preferenceBloc: prefShare));
}

class MyApp extends StatelessWidget {
  final HackerNewBloc hackerNewBloc;
  final PreferenceBloc preferenceBloc;

  MyApp({this.hackerNewBloc, this.preferenceBloc});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: 'Flutter Demo Home Page',
        bloc: hackerNewBloc,
        preferenceBloc: preferenceBloc,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final HackerNewBloc bloc;
  final PreferenceBloc preferenceBloc;

  MyHomePage({Key key, this.title, this.bloc, this.preferenceBloc}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: LoadingInfo(isLoading: widget.bloc.isLoading),
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () async {
                final result = await showSearch(
                    context: context,
                    delegate: ArticleSearch(
                        article: _currentIndex == 0
                            ? widget.bloc.topStories
                            : widget.bloc.newStories));
                // if (await canLaunch(result.url)) {
                //   launch(result.url,forceWebView: true);
                // }
                if (result != null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HackerNewWebView(
                                urlSource: result.url,
                              )));
                }
              })
        ],
      ),
      // (_) -> function take parameter but don't use
      body: StreamBuilder<UnmodifiableListView<Article>>(
          stream: _currentIndex == 0 ? widget.bloc.topStories : widget.bloc.newStories,
          initialData: UnmodifiableListView<Article>([]),
          builder: (context, snapShot) => ListView(
                key: PageStorageKey(_currentIndex),
                children: snapShot.data
                    .map((a) => Items(article: a, preferenceBloc: widget.preferenceBloc))
                    .toList(),
              )),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.green,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.new_releases), label: "Top story"),
          BottomNavigationBarItem(
              icon: Icon(Icons.chrome_reader_mode), label: "New story")
        ],
        onTap: (value) {
          if (value == 0) {
            widget.bloc.storyType.add(StoryType.topStories);
          } else {
            widget.bloc.storyType.add(StoryType.newStory);
          }
          setState(() {
            _currentIndex = value;
          });
        },
      ),
    );
  }
}

class Items extends StatelessWidget {
  final Article article;
  final PreferenceBloc preferenceBloc;

  const Items({
    Key key,
    @required this.article,
    @required this.preferenceBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: PageStorageKey(article.title),
      padding: const EdgeInsets.all(15.0),
      child: ExpansionTile(
        title: Text(
          article.title ?? '[null]',
          style: TextStyle(fontSize: 16),
        ),
        children: [
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("${article.score} comments"),
              IconButton(
                  icon: Icon(
                    Icons.open_in_browser,
                    size: 24,
                  ),
                  onPressed: () async {
                    final fakeUrl = "${article.url}";
                    if (await canLaunch(fakeUrl)) {
                      launch(fakeUrl);
                    }
                  }),
            ],
          ),
          StreamBuilder<PreferenceState>(
              stream: preferenceBloc.currentPref,
              builder: (context, snapshot) {
                if (snapshot.data?.showWebView == true) {
                  return Container(
                      height: 200,
                      child: WebView(
                        initialUrl: article.url,
                        javascriptMode: JavascriptMode.unrestricted,
                        gestureRecognizers: Set()
                          ..add(Factory<VerticalDragGestureRecognizer>(
                              () => VerticalDragGestureRecognizer())),
                      ));
                } else {
                  return Container();
                }
              })
        ],
      ),
    );
  }
}

class LoadingInfo extends StatefulWidget {
  final Stream<bool> isLoading;

  LoadingInfo({this.isLoading});

  @override
  State createState() => LoadingInfoState(isLoading: isLoading);
}

class LoadingInfoState extends State<LoadingInfo> with TickerProviderStateMixin {
  Stream<bool> isLoading;
  AnimationController _controller;

  LoadingInfoState({this.isLoading});

  @override
  void initState() {
    super.initState();
    //vsyu : keep track widget
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: isLoading,
        builder: (context, snapShot) {
          _controller.forward().then((value) => _controller.reverse());
          return FadeTransition(
            opacity: _controller,
            child: Icon(FontAwesomeIcons.hackerNews),
          );
        });
  }
}

class HackerNewWebView extends StatefulWidget {
  final String urlSource;

  HackerNewWebView({this.urlSource});

  @override
  _HackerNewWebViewState createState() => _HackerNewWebViewState();
}

class _HackerNewWebViewState extends State<HackerNewWebView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebView(
        initialUrl: widget.urlSource,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
