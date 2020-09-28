class Article {
  String text;
  String url;
  String by;

  int time;
  int score;

  Article({this.text, this.url, this.by, this.time, this.score});

  @override
  String toString() {
    return 'Article{text: $text, url: $url, by: $by, time: $time, score: $score}';
  }

  factory Article.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return Article(
        text: json['text'] ?? '[null]',
        url: json['url'],
        by: json['by'],
        time: json['time'],
        score: json['score']);
  }
}
//
// final articleList = [
//   new Article(
//       text:
//           'Pirates of the Caribbean is a series of fantasy swashbuckler films produced by Jerry Bruckheimer and based on Walt Disneyd',
//       url: 'wile.com',
//       by: 'jack',
//       age: '3 hours',
//       time: 177,
//       commentCount: 64),
//   new Article(
//       text:
//           'Pirates of the Caribbean is a series of fantasy swashbuckler films produced by Jerry Bruckheimer and based on Walt Disneyd',
//       url: 'wile.com',
//       by: 'john',
//       age: '3 hours',
//       time: 7,
//       commentCount: 64),
//   new Article(
//       text:
//           'Pirates of the Caribbean is a series of fantasy swashbuckler films produced by Jerry Bruckheimer and based on Walt Disneyd',
//       url: 'wile.com',
//       by: 'jack spring',
//       age: '3 hours',
//       time: 19,
//       commentCount: 20),
//   new Article(
//       text:
//           'Pirates of the Caribbean is a series of fantasy swashbuckler films produced by Jerry Bruckheimer and based on Walt Disneyd',
//       url: 'wile.com',
//       by: 'jack sparrow',
//       age: '3 hours',
//       time: 100,
//       commentCount: 50)
// ];
