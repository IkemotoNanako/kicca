import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kicca/domain/model/ai_suggestion_model.dart';

void main() {
  group('AISuggestionModel', () {
    test('creates instance with valid parameters', () {
      final suggestion = AISuggestionModel(
        title: 'テスト提案',
        description: 'テストの説明',
        priority: 3,
        category: '支援制度',
        tags: ['テスト'],
        source: 'AI',
        createdAt: DateTime.now(),
      );

      expect(suggestion.title, 'テスト提案');
      expect(suggestion.description, 'テストの説明');
      expect(suggestion.priority, 3);
      expect(suggestion.category, '支援制度');
      expect(suggestion.tags, ['テスト']);
      expect(suggestion.source, 'AI');
    });

    test('throws error for invalid priority', () {
      expect(
        () => AISuggestionModel(
          title: 'テスト提案',
          description: 'テストの説明',
          priority: 0,
          category: '支援制度',
          tags: ['テスト'],
          source: 'AI',
          createdAt: DateTime.now(),
        ),
        throwsAssertionError,
      );

      expect(
        () => AISuggestionModel(
          title: 'テスト提案',
          description: 'テストの説明',
          priority: 6,
          category: '支援制度',
          tags: ['テスト'],
          source: 'AI',
          createdAt: DateTime.now(),
        ),
        throwsAssertionError,
      );
    });

    test('returns correct color for priority', () {
      final suggestion = AISuggestionModel(
        title: 'テスト提案',
        description: 'テストの説明',
        priority: 3,
        category: '支援制度',
        tags: ['テスト'],
        source: 'AI',
        createdAt: DateTime.now(),
      );

      expect(suggestion.getPriorityColor(), Colors.yellow);
    });
  });
}
