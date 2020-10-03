import 'dart:collection';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:shamand/bloc/hacknew_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import 'package:shamand/model/article.dart';

void main() {
  final bloc = HackerNewBloc();
  runApp(MyApp(bloc: bloc));
}

class MyApp extends StatelessWidget {
  final HackerNewBloc bloc;

  MyApp({this.bloc});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: 'Flutter Demo Home Page',
        bloc: bloc,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final HackerNewBloc bloc;

  MyHomePage({Key key, this.title, this.bloc}) : super(key: key);
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
      ),
      body: StreamBuilder<UnmodifiableListView<Article>>(
          stream: widget.bloc.articleStream,
          initialData: UnmodifiableListView<Article>([]),
          builder: (context, snapShot) => ListView(
                children: snapShot.data.map(_buildItem).toList(),
              )),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.green,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.new_releases), label: "Top story"),
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

  Widget _buildItem(Article article) {
    return Padding(
      key: Key(article.title),
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
                  })
            ],
          )
        ],
      ),
    );
  }

// Future<Article> _getArticler(int id) async {
//   final storyUrl = "https://hacker-news.firebaseio.com/v0/item/$id.json";
//   final res = await http.get(storyUrl);
//   if (res.statusCode != 200) {
//     return null;
//   }
//   return parseArticle(res.body);
// }
}

class LoadingInfo extends StatefulWidget {
  final Stream<bool> isLoading;

  LoadingInfo({this.isLoading});

  @override
  State createState() => LoadingInfoState(isLoading: isLoading);
}

class LoadingInfoState extends State<LoadingInfo>
    with TickerProviderStateMixin {
  Stream<bool> isLoading;
  AnimationController _controller;

  LoadingInfoState({this.isLoading});

  @override
  void initState() {
    super.initState();
    //vsyu : keep track widget
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: isLoading,
        builder: (context, snapShot) {
          // if (snapShot.hasData && snapShot.data) {
          //   return CircularProgressIndicator(
          //     backgroundColor: Colors.green,
          //   );
          // } else {
          //   return Container();
          // }
          _controller.forward().then((value) => _controller.reverse());
          return FadeTransition(
            opacity: _controller,
            child: Icon(FontAwesomeIcons.hackerNews),
          );
        });
  }
}
