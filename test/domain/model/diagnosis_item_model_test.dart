import 'package:flutter_test/flutter_test.dart';
import 'package:kicca/domain/model/diagnosis_item_model.dart';
import 'package:kicca/domain/type/diagnosis_type.dart';

void main() {
  group('DiagnosisItemModel', () {
    test('generates correct number of items', () {
      final items = DiagnosisItemModel.generateItems();
      expect(items.length, 15); // 3カテゴリー × 5問
    });

    test('generates correct number of items per type', () {
      final items = DiagnosisItemModel.generateItems();
      final developmentalItems =
          items.where((item) => item.type == DiagnosisType.developmental);
      final mentalItems =
          items.where((item) => item.type == DiagnosisType.mental);
      final dailyItems =
          items.where((item) => item.type == DiagnosisType.daily);

      expect(developmentalItems.length, 5);
      expect(mentalItems.length, 5);
      expect(dailyItems.length, 5);
    });

    test('validates answer correctly', () {
      final item = DiagnosisItemModel(
        type: DiagnosisType.developmental,
        id: 1,
        question: 'テスト質問',
      );

      expect(item.isValidAnswer(0), true);
      expect(item.isValidAnswer(1), true);
      expect(item.isValidAnswer(2), true);
      expect(item.isValidAnswer(3), true);
      expect(item.isValidAnswer(-1), false);
      expect(item.isValidAnswer(4), false);
    });

    test('copies with answer correctly', () {
      final item = DiagnosisItemModel(
        type: DiagnosisType.developmental,
        id: 1,
        question: 'テスト質問',
      );

      final itemWithAnswer = item.copyWithAnswer(2);
      expect(itemWithAnswer.answer, 2);
      expect(itemWithAnswer.type, item.type);
      expect(itemWithAnswer.id, item.id);
      expect(itemWithAnswer.question, item.question);
    });

    test('throws error for invalid answer', () {
      final item = DiagnosisItemModel(
        type: DiagnosisType.developmental,
        id: 1,
        question: 'テスト質問',
      );

      expect(
        () => item.copyWithAnswer(-1),
        throwsArgumentError,
      );
      expect(
        () => item.copyWithAnswer(4),
        throwsArgumentError,
      );
    });

    test('throws error for invalid id', () {
      expect(
        () => DiagnosisItemModel(
          type: DiagnosisType.developmental,
          id: 0,
          question: 'テスト質問',
        ),
        throwsAssertionError,
      );

      expect(
        () => DiagnosisItemModel(
          type: DiagnosisType.developmental,
          id: 6,
          question: 'テスト質問',
        ),
        throwsAssertionError,
      );
    });
  });
}
