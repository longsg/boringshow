import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shamand/bloc/hacknew_bloc.dart';
import 'package:shamand/bloc/preference_bloc.dart';
import 'package:shamand/bloc/preference_state.dart';
import 'package:shamand/model/article.dart';
import 'package:shamand/widget/headlines.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(MultiProvider(providers: [
    ValueListenableProvider(
      create: (_) => ValueNotifier(true),
    ),
    ChangeNotifierProvider(create: (_) => HackerNewNotifier()),
    Provider(
      create: (_) => PreferenceBloc(),
    ),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: HeadLines(
          title: const ['Top Stories', ' New Stories'][_currentIndex],
          index: _currentIndex,
        ),
        leading: LoadingInfo(),
        actions: [
          // IconButton(
          //     icon: Icon(Icons.search),
          //     onPressed: () async {
          //       final result = await showSearch(
          //           context: context,
          //           delegate: ArticleSearch(
          //               article: _currentIndex == 0
          //                   ? Provider.of<HackerNewNotifier>(context).topStories
          //                   : Provider.of<HackerNewNotifier>(context).newStories));
          //       // if (await canLaunch(result.url)) {
          //       //   launch(result.url,forceWebView: true);
          //       // }
          //       if (result != null) {
          //         Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //                 builder: (context) => HackerNewWebView(
          //                       urlSource: result.url,
          //                     )));
          //       }
          //     })
        ],
      ),
      // (_) -> function take parameter but don't use
      body: Consumer<HackerNewNotifier>(
          builder: (context, bloc, child) => ListView(
                key: PageStorageKey(_currentIndex),
                children: bloc.article
                    .map((value) => Items(
                        article: value,
                        preferenceBloc: Provider.of<PreferenceBloc>(context)))
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
            Provider.of<HackerNewNotifier>(context, listen: false)
                .getStoriesType(StoryType.topStories);
          } else {
            Provider.of<HackerNewNotifier>(context, listen: false)
                .getStoriesType(StoryType.newStory);
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
  LoadingInfo();

  @override
  State createState() => LoadingInfoState();
}

class LoadingInfoState extends State<LoadingInfo> with TickerProviderStateMixin {
  AnimationController _controller;

  LoadingInfoState();

  @override
  void initState() {
    super.initState();
    //vsyu : keep track widget
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HackerNewNotifier>(builder: (context, bloc, child) {
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
