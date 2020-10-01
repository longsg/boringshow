// // This is a basic Flutter widget test.
// //
// // To perform an interaction with a widget in your test, use the WidgetTester
// // utility that Flutter provides. For example, you can send tap and scroll
// // gestures. You can also use WidgetTester to find child widgets in the widget
// // tree, read text, and verify that the values of widget properties are correct.
//
// import 'dart:convert' as json;
//
// import 'package:flutter_test/flutter_test.dart';
// import 'package:http/http.dart' as http;
// import 'package:shamand/parsejson/json_parsing.dart';
//
// void main() {
//   // testWidgets('Clicking and open it', (WidgetTester tester) async {
//   //   // Build our app and trigger a frame.
//   //   await tester.pumpWidget(MyApp());
//   //
//   //   expect(find.byIcon(Icons.open_in_browser), findsNothing);
//   //
//   //   await tester.tap(find.byType(ExpansionTile).first);
//   //   await tester.pump();
//   //
//   //   expect(find.byIcon(Icons.open_in_browser), findsOneWidget);
//   // });
//   test("parse items from network", () async {
//     final url = "https://hacker-news.firebaseio.com/v0/beststories.json";
//     final res = await http.get(url);
//     if (res.statusCode == 200) {
//       final idList = json.jsonDecode(res.body);
//       if (idList.isNotEmpty) {
//         final storyUrl = "https://hacker-news.firebaseio.com/v0/item/${idList}.json";
//         final storyRes = await http.get(storyUrl);
//         if (res.statusCode == 200) {
//           expect(parseArticle(storyRes.body).by, "dhouston");
//         }
//       }
//     }
//   });
// }
