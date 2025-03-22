import 'package:flutter_test/flutter_test.dart';
import 'package:kicca/domain/model/hearing_data_model.dart';
import 'package:kicca/providers/ai_service_provider.dart';

void main() {
  late AIServiceProvider provider;

  setUp(() {
    provider = AIServiceProvider(apiKey: 'test_api_key');
  });

  test('初期状態', () {
    expect(provider.informationList, isEmpty);
    expect(provider.isLoading, isFalse);
    expect(provider.errorMessage, isNull);
  });

  test('情報生成', () async {
    final hearingData = HearingDataModel(
      lifeDifficulties: '生活の困りごと',
      workDifficulties: '仕事の困りごと',
      strengths: '得意なこと',
      createdAt: DateTime.now(),
    );

    await provider.generateInformation(hearingData);

    expect(provider.isLoading, isFalse);
    expect(provider.errorMessage, isNull);
    expect(provider.informationList, isNotEmpty);

    final info = provider.informationList.first;
    expect(info.title, isNotEmpty);
    expect(info.description, isNotEmpty);
    expect(info.category, isIn(['支援制度', 'ツール・サービス', '生活の知恵']));
    expect(info.priority, inInclusiveRange(0, 100));
    expect(info.tags, hasLength(lessThanOrEqualTo(3)));
    expect(info.source, isNotEmpty);
    expect(info.createdAt, isNotNull);
  });

  test('情報生成エラー', () async {
    final hearingData = HearingDataModel(
      lifeDifficulties: '',
      workDifficulties: '',
      strengths: '',
      createdAt: DateTime.now(),
    );

    await provider.generateInformation(hearingData);

    expect(provider.isLoading, isFalse);
    expect(provider.errorMessage, isNotNull);
    expect(provider.informationList, isEmpty);
  });

  test('優先順位の計算', () {
    // 支援制度の優先順位計算
    final supportPriority = provider.calculatePriority(
      category: '支援制度',
      urgency: 5,
      importance: 5,
      easeOfImplementation: 3,
      effectiveness: 3,
      immediacy: 3,
      practicality: 3,
    );
    expect(supportPriority, inInclusiveRange(0, 100));

    // ツール・サービスの優先順位計算
    final toolPriority = provider.calculatePriority(
      category: 'ツール・サービス',
      urgency: 3,
      importance: 3,
      easeOfImplementation: 5,
      effectiveness: 5,
      immediacy: 3,
      practicality: 3,
    );
    expect(toolPriority, inInclusiveRange(0, 100));

    // 生活の知恵の優先順位計算
    final wisdomPriority = provider.calculatePriority(
      category: '生活の知恵',
      urgency: 3,
      importance: 3,
      easeOfImplementation: 3,
      effectiveness: 3,
      immediacy: 5,
      practicality: 5,
    );
    expect(wisdomPriority, inInclusiveRange(0, 100));

    // 無効なカテゴリの優先順位計算
    final invalidPriority = provider.calculatePriority(
      category: '無効なカテゴリ',
      urgency: 5,
      importance: 5,
      easeOfImplementation: 5,
      effectiveness: 5,
      immediacy: 5,
      practicality: 5,
    );
    expect(invalidPriority, 0);
  });
}
