import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kicca/domain/model/hearing_data_model.dart';
import 'package:kicca/services/hearing_service.dart';
import 'package:kicca/view/page/hearing_page.dart';

void main() {
  late SharedPreferences prefs;
  late HearingService service;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    service = HearingService(prefs);
  });

  tearDownAll(() async {
    await prefs.clear();
  });

  testWidgets('ヒヤリング画面のテスト', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HearingPage()));

    // 初期状態の確認
    expect(find.text('ヒヤリング'), findsOneWidget);
    expect(find.text('生活での困りごと'), findsOneWidget);
    expect(find.text('仕事での困りごと'), findsOneWidget);
    expect(find.text('得意なこと'), findsOneWidget);
    expect(find.text('保存'), findsOneWidget);

    // 入力フィールドの確認
    expect(find.byType(TextFormField), findsNWidgets(3));

    // バリデーションのテスト
    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();

    // エラーメッセージの確認
    expect(find.text('生活での困りごとを入力してください'), findsOneWidget);
    expect(find.text('仕事での困りごとを入力してください'), findsOneWidget);
    expect(find.text('得意なことを入力してください'), findsOneWidget);

    // データ入力のテスト
    await tester.enterText(
      find.widgetWithText(TextFormField, '生活で困っていることを入力してください'),
      '生活での困りごとテスト',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, '仕事で困っていることを入力してください'),
      '仕事での困りごとテスト',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, '得意なことを入力してください'),
      '得意なことテスト',
    );

    // 保存ボタンのタップ
    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();

    // 保存成功メッセージの確認
    expect(find.text('データを保存しました'), findsOneWidget);

    // 保存されたデータの確認
    final data = service.getHearingData();
    expect(data, isNotNull);
    expect(data!.lifeDifficulties, '生活での困りごとテスト');
    expect(data.workDifficulties, '仕事での困りごとテスト');
    expect(data.strengths, '得意なことテスト');
  });
}
