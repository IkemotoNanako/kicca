import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:kicca/domain/model/ai_suggestion_model.dart';
import 'package:kicca/domain/model/diagnosis_result_model.dart';
import 'package:kicca/services/ai_client.dart';
import 'package:kicca/services/ai_suggestion_service.dart';

@GenerateMocks([AIClient])
import 'ai_suggestion_service_test.mocks.dart';

void main() {
  group('AISuggestionService', () {
    late AISuggestionService service;
    late MockAIClient mockClient;

    setUp(() {
      mockClient = MockAIClient();
      service = AISuggestionService(apiKey: 'test-api-key');
    });

    test('generates suggestions successfully', () async {
      final result = DiagnosisResultModel(
        developmentalScore: 10,
        mentalScore: 8,
        dailyScore: 12,
      );

      when(mockClient.generateContent(any)).thenAnswer(
        (_) async => Future.value(
          '''
{
  "suggestions": [
    {
      "title": "テスト提案",
      "description": "テストの説明",
      "priority": 3,
      "category": "支援制度",
      "tags": ["テスト"],
      "source": "AI"
    }
  ]
}
''',
        ),
      );

      final suggestions = await service.generateSuggestions(result);

      expect(suggestions.length, 1);
      expect(suggestions[0].title, 'テスト提案');
      expect(suggestions[0].description, 'テストの説明');
      expect(suggestions[0].priority, 3);
      expect(suggestions[0].category, '支援制度');
      expect(suggestions[0].tags, ['テスト']);
      expect(suggestions[0].source, 'AI');
    });

    test('handles empty response', () async {
      final result = DiagnosisResultModel(
        developmentalScore: 10,
        mentalScore: 8,
        dailyScore: 12,
      );

      when(mockClient.generateContent(any)).thenAnswer(
        (_) async => Future.value(null),
      );

      expect(
        () => service.generateSuggestions(result),
        throwsException,
      );
    });

    test('handles error', () async {
      final result = DiagnosisResultModel(
        developmentalScore: 10,
        mentalScore: 8,
        dailyScore: 12,
      );

      when(mockClient.generateContent(any)).thenThrow(Exception('テストエラー'));

      expect(
        () => service.generateSuggestions(result),
        throwsException,
      );
    });
  });
}
