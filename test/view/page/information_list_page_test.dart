import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kicca/view/page/information_list_page.dart';

void main() {
  group('InformationListPage', () {
    testWidgets('初期表示', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: InformationListPage(),
        ),
      );

      // AppBarのタイトル
      expect(find.text('支援情報一覧'), findsOneWidget);

      // 検索バー
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('キーワードで検索'), findsOneWidget);

      // カテゴリフィルター
      expect(find.text('全て'), findsOneWidget);
      expect(find.text('支援制度'), findsOneWidget);
      expect(find.text('ツール・サービス'), findsOneWidget);
      expect(find.text('生活の知恵'), findsOneWidget);

      // 情報カード
      expect(find.byType(Card), findsNWidgets(3));
      expect(find.text('障害者手帳の申請方法'), findsOneWidget);
      expect(find.text('タスク管理アプリ'), findsOneWidget);
      expect(find.text('集中力を高める方法'), findsOneWidget);
    });

    testWidgets('カテゴリフィルター', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: InformationListPage(),
        ),
      );

      // 支援制度を選択
      await tester.tap(find.text('支援制度'));
      await tester.pump();

      // 支援制度のカードのみ表示
      expect(find.byType(Card), findsOneWidget);
      expect(find.text('障害者手帳の申請方法'), findsOneWidget);
      expect(find.text('タスク管理アプリ'), findsNothing);
      expect(find.text('集中力を高める方法'), findsNothing);
    });

    testWidgets('キーワード検索', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: InformationListPage(),
        ),
      );

      // 「アプリ」で検索
      await tester.enterText(find.byType(TextField), 'アプリ');
      await tester.pump();

      // アプリに関するカードのみ表示
      expect(find.byType(Card), findsOneWidget);
      expect(find.text('障害者手帳の申請方法'), findsNothing);
      expect(find.text('タスク管理アプリ'), findsOneWidget);
      expect(find.text('集中力を高める方法'), findsNothing);
    });
  });
}
