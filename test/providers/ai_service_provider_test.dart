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
}
