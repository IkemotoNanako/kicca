import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kicca/domain/model/ai_information_model.dart';
import 'package:kicca/view/page/information_detail_page.dart';

void main() {
  group('InformationDetailPage', () {
    testWidgets('表示内容', (tester) async {
      final information = AIInformationModel(
        title: 'テストタイトル',
        description: 'テスト説明',
        category: '支援制度',
        priority: 90,
        tags: ['タグ1', 'タグ2'],
        source: 'テストソース',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: InformationDetailPage(information: information),
        ),
      );

      // AppBarのタイトル
      expect(find.text('支援情報の詳細'), findsOneWidget);

      // タイトル
      expect(find.text('テストタイトル'), findsOneWidget);

      // 優先度
      expect(find.text('優先度: 90'), findsOneWidget);

      // カテゴリ
      expect(find.text('カテゴリ'), findsOneWidget);
      expect(find.text('支援制度'), findsOneWidget);

      // 説明
      expect(find.text('説明'), findsOneWidget);
      expect(find.text('テスト説明'), findsOneWidget);

      // タグ
      expect(find.text('タグ'), findsOneWidget);
      expect(find.text('タグ1'), findsOneWidget);
      expect(find.text('タグ2'), findsOneWidget);

      // 情報源
      expect(find.text('情報源'), findsOneWidget);
      expect(find.text('テストソース'), findsOneWidget);

      // 作成日時
      expect(find.text('作成日時'), findsOneWidget);
      expect(
        find.textContaining(RegExp(r'\d{4}年\d{1,2}月\d{1,2}日 \d{1,2}時\d{1,2}分')),
        findsOneWidget,
      );
    });

    testWidgets('優先度の色分け', (tester) async {
      // 高優先度
      await tester.pumpWidget(
        MaterialApp(
          home: InformationDetailPage(
            information: AIInformationModel(
              title: 'テスト',
              description: 'テスト',
              category: 'テスト',
              priority: 90,
              tags: [],
              source: 'テスト',
            ),
          ),
        ),
      );

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Container &&
              widget.decoration is BoxDecoration &&
              (widget.decoration as BoxDecoration).color == Colors.red,
        ),
        findsOneWidget,
      );

      // 中優先度
      await tester.pumpWidget(
        MaterialApp(
          home: InformationDetailPage(
            information: AIInformationModel(
              title: 'テスト',
              description: 'テスト',
              category: 'テスト',
              priority: 60,
              tags: [],
              source: 'テスト',
            ),
          ),
        ),
      );

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Container &&
              widget.decoration is BoxDecoration &&
              (widget.decoration as BoxDecoration).color == Colors.orange,
        ),
        findsOneWidget,
      );

      // 低優先度
      await tester.pumpWidget(
        MaterialApp(
          home: InformationDetailPage(
            information: AIInformationModel(
              title: 'テスト',
              description: 'テスト',
              category: 'テスト',
              priority: 30,
              tags: [],
              source: 'テスト',
            ),
          ),
        ),
      );

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Container &&
              widget.decoration is BoxDecoration &&
              (widget.decoration as BoxDecoration).color == Colors.green,
        ),
        findsOneWidget,
      );
    });
  });
}
