import 'package:flutter_test/flutter_test.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:kicca/domain/model/ai_information_model.dart';
import 'package:kicca/domain/model/hearing_data_model.dart';
import 'package:kicca/services/ai_service.dart';

void main() {
  group('AIService', () {
    late AIService service;
    late HearingDataModel hearingData;

    setUp(() {
      service = AIService(apiKey: 'test_api_key');
      hearingData = HearingDataModel(
        lifeDifficulties: '生活での困りごと',
        workDifficulties: '仕事での困りごと',
        strengths: '得意なこと',
      );
    });

    test('generateInformation', () async {
      final result = await service.generateInformation(hearingData);

      expect(result, isA<List<AIInformationModel>>());
      expect(result.isNotEmpty, true);
      expect(result.first, isA<AIInformationModel>());
      expect(result.first.title, isNotEmpty);
      expect(result.first.description, isNotEmpty);
      expect(result.first.category, isNotEmpty);
      expect(result.first.priority, isA<int>());
      expect(result.first.tags, isA<List<String>>());
      expect(result.first.source, isNotEmpty);
    });
  });
}
