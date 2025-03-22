import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:kicca/domain/model/ai_suggestion_model.dart';
import 'package:kicca/domain/model/diagnosis_result_model.dart';
import 'package:kicca/providers/ai_suggestion_provider.dart';
import 'package:kicca/services/ai_suggestion_service.dart';

@GenerateMocks([AISuggestionService])
import 'ai_suggestion_provider_test.mocks.dart';

void main() {
  group('AISuggestionProvider', () {
    late AISuggestionProvider provider;
    late MockAISuggestionService mockService;

    setUp(() {
      mockService = MockAISuggestionService();
      provider = AISuggestionProvider(apiKey: 'test-api-key');
    });

    test('initial state is correct', () {
      expect(provider.suggestions, isEmpty);
      expect(provider.isLoading, false);
      expect(provider.errorMessage, null);
    });

    test('generates suggestions successfully', () async {
      final result = DiagnosisResultModel(
        developmentalScore: 10,
        mentalScore: 8,
        dailyScore: 12,
      );

      final suggestions = [
        AISuggestionModel(
          title: 'テスト提案',
          description: 'テストの説明',
          priority: 3,
          category: '支援制度',
          tags: ['テスト'],
          source: 'AI',
          createdAt: DateTime.now(),
        ),
      ];

      when(mockService.generateSuggestions(result))
          .thenAnswer((_) async => suggestions);

      await provider.generateSuggestions(result);

      expect(provider.suggestions, suggestions);
      expect(provider.isLoading, false);
      expect(provider.errorMessage, null);
    });

    test('handles error when generating suggestions', () async {
      final result = DiagnosisResultModel(
        developmentalScore: 10,
        mentalScore: 8,
        dailyScore: 12,
      );

      when(mockService.generateSuggestions(result))
          .thenThrow(Exception('テストエラー'));

      await provider.generateSuggestions(result);

      expect(provider.suggestions, isEmpty);
      expect(provider.isLoading, false);
      expect(provider.errorMessage, 'Exception: テストエラー');
    });

    test('clears suggestions', () {
      provider.clearSuggestions();

      expect(provider.suggestions, isEmpty);
      expect(provider.errorMessage, null);
    });
  });
}
