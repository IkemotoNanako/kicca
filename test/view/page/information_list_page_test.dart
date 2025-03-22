import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kicca/domain/model/ai_information_model.dart';
import 'package:kicca/domain/model/hearing_data_model.dart';
import 'package:kicca/providers/ai_service_provider.dart';
import 'package:kicca/services/hearing_service.dart';
import 'package:kicca/view/page/information_list_page.dart';

class MockAIServiceProvider extends Mock implements AIServiceProvider {}

class MockHearingService extends Mock implements HearingService {}

void main() {
  late MockAIServiceProvider mockAIServiceProvider;
  late MockHearingService mockHearingService;
  late SharedPreferences prefs;

  setUpAll(() async {
    prefs = await SharedPreferences.getInstance();
    mockAIServiceProvider = MockAIServiceProvider();
    mockHearingService = MockHearingService();
  });

  tearDownAll(() async {
    await prefs.clear();
  });

  testWidgets('初期状態のテスト', (WidgetTester tester) async {
    when(mockAIServiceProvider.informationList).thenReturn([]);
    when(mockAIServiceProvider.isLoading).thenReturn(false);
    when(mockAIServiceProvider.errorMessage).thenReturn(null);
    when(mockHearingService.getHearingData()).thenReturn(null);

    await tester.pumpWidget(
      MaterialApp(
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider<AIServiceProvider>.value(
              value: mockAIServiceProvider,
            ),
          ],
          child: const InformationListPage(),
        ),
      ),
    );

    expect(find.text('表示する情報がありません'), findsOneWidget);
  });

  testWidgets('ローディング状態のテスト', (WidgetTester tester) async {
    when(mockAIServiceProvider.informationList).thenReturn([]);
    when(mockAIServiceProvider.isLoading).thenReturn(true);
    when(mockAIServiceProvider.errorMessage).thenReturn(null);
    when(mockHearingService.getHearingData()).thenReturn(null);

    await tester.pumpWidget(
      MaterialApp(
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider<AIServiceProvider>.value(
              value: mockAIServiceProvider,
            ),
          ],
          child: const InformationListPage(),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('エラー状態のテスト', (WidgetTester tester) async {
    when(mockAIServiceProvider.informationList).thenReturn([]);
    when(mockAIServiceProvider.isLoading).thenReturn(false);
    when(mockAIServiceProvider.errorMessage).thenReturn('エラーが発生しました');
    when(mockHearingService.getHearingData()).thenReturn(null);

    await tester.pumpWidget(
      MaterialApp(
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider<AIServiceProvider>.value(
              value: mockAIServiceProvider,
            ),
          ],
          child: const InformationListPage(),
        ),
      ),
    );

    expect(find.text('エラーが発生しました'), findsOneWidget);
    expect(find.text('再試行'), findsOneWidget);
  });

  testWidgets('情報一覧の表示テスト', (WidgetTester tester) async {
    final informationList = [
      AIInformationModel(
        title: 'テスト情報1',
        description: '説明1',
        category: '支援制度',
        priority: 80,
        tags: ['タグ1', 'タグ2'],
        source: '出典1',
        createdAt: DateTime.now(),
      ),
      AIInformationModel(
        title: 'テスト情報2',
        description: '説明2',
        category: 'ツール・サービス',
        priority: 60,
        tags: ['タグ3', 'タグ4'],
        source: '出典2',
        createdAt: DateTime.now(),
      ),
    ];

    when(mockAIServiceProvider.informationList).thenReturn(informationList);
    when(mockAIServiceProvider.isLoading).thenReturn(false);
    when(mockAIServiceProvider.errorMessage).thenReturn(null);
    when(mockHearingService.getHearingData()).thenReturn(null);

    await tester.pumpWidget(
      MaterialApp(
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider<AIServiceProvider>.value(
              value: mockAIServiceProvider,
            ),
          ],
          child: const InformationListPage(),
        ),
      ),
    );

    expect(find.text('テスト情報1'), findsOneWidget);
    expect(find.text('テスト情報2'), findsOneWidget);
  });

  testWidgets('カテゴリフィルターのテスト', (WidgetTester tester) async {
    final informationList = [
      AIInformationModel(
        title: 'テスト情報1',
        description: '説明1',
        category: '支援制度',
        priority: 80,
        tags: ['タグ1', 'タグ2'],
        source: '出典1',
        createdAt: DateTime.now(),
      ),
      AIInformationModel(
        title: 'テスト情報2',
        description: '説明2',
        category: 'ツール・サービス',
        priority: 60,
        tags: ['タグ3', 'タグ4'],
        source: '出典2',
        createdAt: DateTime.now(),
      ),
    ];

    when(mockAIServiceProvider.informationList).thenReturn(informationList);
    when(mockAIServiceProvider.isLoading).thenReturn(false);
    when(mockAIServiceProvider.errorMessage).thenReturn(null);
    when(mockHearingService.getHearingData()).thenReturn(null);

    await tester.pumpWidget(
      MaterialApp(
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider<AIServiceProvider>.value(
              value: mockAIServiceProvider,
            ),
          ],
          child: const InformationListPage(),
        ),
      ),
    );

    // 支援制度のフィルターを選択
    await tester.tap(find.text('支援制度'));
    await tester.pumpAndSettle();

    expect(find.text('テスト情報1'), findsOneWidget);
    expect(find.text('テスト情報2'), findsNothing);
  });

  testWidgets('検索機能のテスト', (WidgetTester tester) async {
    final informationList = [
      AIInformationModel(
        title: 'テスト情報1',
        description: '説明1',
        category: '支援制度',
        priority: 80,
        tags: ['タグ1', 'タグ2'],
        source: '出典1',
        createdAt: DateTime.now(),
      ),
      AIInformationModel(
        title: 'テスト情報2',
        description: '説明2',
        category: 'ツール・サービス',
        priority: 60,
        tags: ['タグ3', 'タグ4'],
        source: '出典2',
        createdAt: DateTime.now(),
      ),
    ];

    when(mockAIServiceProvider.informationList).thenReturn(informationList);
    when(mockAIServiceProvider.isLoading).thenReturn(false);
    when(mockAIServiceProvider.errorMessage).thenReturn(null);
    when(mockHearingService.getHearingData()).thenReturn(null);

    await tester.pumpWidget(
      MaterialApp(
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider<AIServiceProvider>.value(
              value: mockAIServiceProvider,
            ),
          ],
          child: const InformationListPage(),
        ),
      ),
    );

    // 検索クエリを入力
    await tester.enterText(find.byType(TextField), 'テスト情報1');
    await tester.pumpAndSettle();

    expect(find.text('テスト情報1'), findsOneWidget);
    expect(find.text('テスト情報2'), findsNothing);
  });

  testWidgets('ヒヤリングデータの読み込みテスト', (WidgetTester tester) async {
    final hearingData = HearingDataModel(
      lifeDifficulties: '生活の困りごと',
      workDifficulties: '仕事の困りごと',
      strengths: '得意なこと',
      createdAt: DateTime.now(),
    );

    when(mockAIServiceProvider.informationList).thenReturn([]);
    when(mockAIServiceProvider.isLoading).thenReturn(false);
    when(mockAIServiceProvider.errorMessage).thenReturn(null);
    when(mockHearingService.getHearingData()).thenReturn(hearingData);

    await tester.pumpWidget(
      MaterialApp(
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider<AIServiceProvider>.value(
              value: mockAIServiceProvider,
            ),
          ],
          child: const InformationListPage(),
        ),
      ),
    );

    verify(mockAIServiceProvider.generateInformation(hearingData)).called(1);
  });
}
