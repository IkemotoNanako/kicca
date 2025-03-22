import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kicca/view/page/diagnosis_page.dart';

void main() {
  testWidgets('診断画面のテスト', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: DiagnosisPage()));

    // 初期状態の確認
    expect(find.text('診断'), findsOneWidget);
    expect(find.text('質問 1/9'), findsOneWidget);
    expect(find.text('とてもあてはまる'), findsOneWidget);
    expect(find.text('ややあてはまる'), findsOneWidget);
    expect(find.text('あまりあてはまらない'), findsOneWidget);
    expect(find.text('全くあてはまらない'), findsOneWidget);

    // 回答の選択
    await tester.tap(find.text('とてもあてはまる'));
    await tester.pumpAndSettle();

    // 次の質問に進む
    expect(find.text('質問 2/9'), findsOneWidget);

    // 全ての質問に回答
    for (var i = 1; i < 9; i++) {
      await tester.tap(find.text('とてもあてはまる'));
      await tester.pumpAndSettle();
    }

    // 結果画面の確認
    expect(find.text('診断結果'), findsOneWidget);
    expect(find.text('発達障害の特徴'), findsOneWidget);
    expect(find.text('精神疾患の症状'), findsOneWidget);
    expect(find.text('日常生活での困りごと'), findsOneWidget);
    expect(find.text('合計スコア: 27点'), findsOneWidget);

    // リセットボタンの確認
    expect(find.byIcon(Icons.refresh), findsOneWidget);

    // リセット
    await tester.tap(find.byIcon(Icons.refresh));
    await tester.pumpAndSettle();

    // 初期状態に戻る
    expect(find.text('質問 1/9'), findsOneWidget);
  });
}
