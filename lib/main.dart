import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'model/article.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<int> _idStories = [
    24617542,
    24605949,
    24601579,
    24593093,
    24618707,
    24593028,
    24609449,
    24599642,
    24615916,
    24613979,
    24600978,
    24599837,
    24607645,
    24615185,
    24623076,
    24608925,
    24611341
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: _idStories
            .map((e) => FutureBuilder<Article>(
                  future: _getArticler(e),
                  builder: (context, AsyncSnapshot<Article> snapShot) {
                    if (snapShot.connectionState == ConnectionState.done) {
                      return _buildItem(snapShot.data);
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ))
            .toList(),
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
        // subtitle: Text("${article.commentCount} comments"),
        // onTap: () async {
        //   final urlLauncher = "https://${article.domain}";
        //   if (await canLaunch(urlLauncher)) {
        //     launch(urlLauncher);
        //   }
        // },
      ),
    );
  }

  Future<Article> _getArticler(int id) async {
    final storyUrl = "https://hacker-news.firebaseio.com/v0/item/$id.json";
    final res = await http.get(storyUrl);
    if (res.statusCode != 200) {
      return null;
    }
    return parseArticle(res.body);
  }
}
