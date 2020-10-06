import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:shamand/main.dart';
import 'package:shamand/model/article.dart';

class ArticleSearch extends SearchDelegate<Article> {
  final Stream<UnmodifiableListView<Article>> article;

  ArticleSearch({this.article});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            query = "";
            close(context, null);
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder(
      stream: article,
      builder: (context, AsyncSnapshot<UnmodifiableListView<Article>> snapShot) {
        if (!snapShot.hasData) {
          return Center(
            child: Text("No data"),
          );
        }
        final result =
            snapShot.data.where((element) => element.title.toLowerCase().contains(query));
        return ListView(
          children: result
              .map<ListTile>((e) => ListTile(
                    title: Text(
                      e.title,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(fontSize: 16.0, color: Colors.green),
                    ),
                    leading: Icon(Icons.book),
                    onTap: () {
                      // if (await canLaunch(e.url)) {
                      //   await launch(e.url);
                      // }
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HackerNewWebView(urlSource: e.url)));
                      close(context, e);
                    },
                  ))
              .toList(),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder(
      stream: article,
      builder: (context, AsyncSnapshot<UnmodifiableListView<Article>> snapShot) {
        if (!snapShot.hasData) {
          return Center(
            child: Text("No data !"),
          );
        }
        final result = snapShot.data.where((e) => e.title.toLowerCase().contains(query));

        return ListView(
          children: result
              .map<ListTile>((value) => ListTile(
                    title: Text(
                      value.title,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(color: Colors.green),
                    ),
                    leading: Icon(
                      Icons.subject,
                      color: Colors.green,
                    ),
                    onTap: () {
                      close(context, value);
                    },
                  ))
              .toList(),
        );
      },
    );
  }
}
