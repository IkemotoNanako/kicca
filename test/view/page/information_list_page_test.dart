import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kicca/domain/model/ai_information_model.dart';
import 'package:kicca/domain/model/hearing_data_model.dart';
import 'package:kicca/providers/ai_service_provider.dart';
import 'package:kicca/view/page/information_list_page.dart';
import 'package:provider/provider.dart';

void main() {
  late AIServiceProvider mockProvider;

  setUp(() {
    mockProvider = AIServiceProvider(apiKey: 'test_api_key');
  });

  Widget buildTestWidget() {
    return MaterialApp(
      home: ChangeNotifierProvider<AIServiceProvider>.value(
        value: mockProvider,
        child: InformationListPage(
          hearingData: HearingDataModel(
            lifeDifficulties: '生活の困りごと',
            workDifficulties: '仕事の困りごと',
            strengths: '得意なこと',
            createdAt: DateTime.now(),
          ),
        ),
      ),
    );
  }

  testWidgets('情報一覧画面が正しく表示される', (tester) async {
    await tester.pumpWidget(buildTestWidget());

    // ローディング表示の確認
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // 情報の生成
    mockProvider.informationList = [
      AIInformationModel(
        title: '障害者手帳の申請方法',
        description: '障害者手帳の申請に必要な書類や手続きの流れを解説します。',
        category: '支援制度',
        priority: 90,
        tags: ['障害者手帳', '申請', '手続き'],
        source: '厚生労働省',
        createdAt: DateTime.now(),
      ),
    ];
    mockProvider.isLoading = false;

    await tester.pumpAndSettle();

    // 検索バーの確認
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('キーワードで検索'), findsOneWidget);

    // カテゴリフィルターの確認
    expect(find.text('全て'), findsOneWidget);
    expect(find.text('支援制度'), findsOneWidget);
    expect(find.text('ツール・サービス'), findsOneWidget);
    expect(find.text('生活の知恵'), findsOneWidget);

    // 情報カードの確認
    expect(find.text('障害者手帳の申請方法'), findsOneWidget);
    expect(find.text('障害者手帳の申請に必要な書類や手続きの流れを解説します。'), findsOneWidget);
  });

  testWidgets('検索機能が正しく動作する', (tester) async {
    await tester.pumpWidget(buildTestWidget());

    mockProvider.informationList = [
      AIInformationModel(
        title: '障害者手帳の申請方法',
        description: '障害者手帳の申請に必要な書類や手続きの流れを解説します。',
        category: '支援制度',
        priority: 90,
        tags: ['障害者手帳', '申請', '手続き'],
        source: '厚生労働省',
        createdAt: DateTime.now(),
      ),
      AIInformationModel(
        title: 'タスク管理アプリ',
        description: '日々のタスクを管理しやすいアプリを紹介します。',
        category: 'ツール・サービス',
        priority: 80,
        tags: ['アプリ', 'タスク管理', '生産性'],
        source: 'アプリレビュー',
        createdAt: DateTime.now(),
      ),
    ];
    mockProvider.isLoading = false;

    await tester.pumpAndSettle();

    // キーワード検索
    await tester.enterText(find.byType(TextField), '手帳');
    await tester.pumpAndSettle();

    expect(find.text('障害者手帳の申請方法'), findsOneWidget);
    expect(find.text('タスク管理アプリ'), findsNothing);

    // カテゴリフィルター
    await tester.tap(find.text('ツール・サービス'));
    await tester.pumpAndSettle();

    expect(find.text('障害者手帳の申請方法'), findsNothing);
    expect(find.text('タスク管理アプリ'), findsOneWidget);
  });

  testWidgets('エラー表示が正しく動作する', (tester) async {
    await tester.pumpWidget(buildTestWidget());

    mockProvider.errorMessage = 'エラーが発生しました';
    mockProvider.isLoading = false;

    await tester.pumpAndSettle();

    expect(find.text('エラーが発生しました'), findsOneWidget);
    expect(find.text('再試行'), findsOneWidget);

    // 再試行ボタンのタップ
    await tester.tap(find.text('再試行'));
    await tester.pumpAndSettle();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
