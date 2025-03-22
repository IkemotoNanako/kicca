import 'package:flutter_test/flutter_test.dart';
import 'package:kicca/domain/model/ai_information_model.dart';

void main() {
  group('AIInformationModel', () {
    test('コンストラクタ', () {
      final model = AIInformationModel(
        title: 'テストタイトル',
        description: 'テスト説明',
        category: '支援制度',
        priority: 80,
        tags: ['タグ1', 'タグ2'],
        source: 'テストソース',
      );

      expect(model.title, 'テストタイトル');
      expect(model.description, 'テスト説明');
      expect(model.category, '支援制度');
      expect(model.priority, 80);
      expect(model.tags, ['タグ1', 'タグ2']);
      expect(model.source, 'テストソース');
      expect(model.createdAt, isNotNull);
    });

    test('copyWith', () {
      final model = AIInformationModel(
        title: 'テストタイトル',
        description: 'テスト説明',
        category: '支援制度',
        priority: 80,
        tags: ['タグ1', 'タグ2'],
        source: 'テストソース',
      );

      final updated = model.copyWith(
        title: '更新タイトル',
        priority: 90,
      );

      expect(updated.title, '更新タイトル');
      expect(updated.description, 'テスト説明');
      expect(updated.category, '支援制度');
      expect(updated.priority, 90);
      expect(updated.tags, ['タグ1', 'タグ2']);
      expect(updated.source, 'テストソース');
      expect(updated.createdAt, model.createdAt);
    });

    test('fromJson', () {
      final json = {
        'title': 'テストタイトル',
        'description': 'テスト説明',
        'category': '支援制度',
        'priority': 80,
        'tags': ['タグ1', 'タグ2'],
        'source': 'テストソース',
        'createdAt': '2024-03-22T12:00:00.000Z',
      };

      final model = AIInformationModel.fromJson(json);

      expect(model.title, 'テストタイトル');
      expect(model.description, 'テスト説明');
      expect(model.category, '支援制度');
      expect(model.priority, 80);
      expect(model.tags, ['タグ1', 'タグ2']);
      expect(model.source, 'テストソース');
      expect(model.createdAt, DateTime.parse('2024-03-22T12:00:00.000Z'));
    });

    test('toJson', () {
      final model = AIInformationModel(
        title: 'テストタイトル',
        description: 'テスト説明',
        category: '支援制度',
        priority: 80,
        tags: ['タグ1', 'タグ2'],
        source: 'テストソース',
      );

      final json = model.toJson();

      expect(json['title'], 'テストタイトル');
      expect(json['description'], 'テスト説明');
      expect(json['category'], '支援制度');
      expect(json['priority'], 80);
      expect(json['tags'], ['タグ1', 'タグ2']);
      expect(json['source'], 'テストソース');
      expect(json['createdAt'], isA<String>());
    });
  });
}
