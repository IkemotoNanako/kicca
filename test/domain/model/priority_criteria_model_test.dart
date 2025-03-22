import 'package:flutter_test/flutter_test.dart';
import 'package:kicca/domain/model/priority_criteria_model.dart';
import 'package:kicca/domain/type/priority_type.dart';
import 'package:kicca/domain/type/information_type.dart';

void main() {
  group('PriorityCriteriaModel', () {
    test('calculatePriority returns correct priority based on score', () {
      expect(PriorityCriteriaModel.calculatePriority(90), PriorityType.high);
      expect(PriorityCriteriaModel.calculatePriority(75), PriorityType.medium);
      expect(PriorityCriteriaModel.calculatePriority(30), PriorityType.low);
    });

    test('calculateSupportScore returns correct score with weights', () {
      // 緊急度（60%）と重要度（40%）の重み付け
      final score = PriorityCriteriaModel.calculateSupportScore(
        urgency: 3,
        importance: 3,
      );
      expect(score, 100); // 最高スコア
    });

    test('calculateToolScore returns correct score with weights', () {
      // 実装の容易さ（40%）と効果の高さ（60%）の重み付け
      final score = PriorityCriteriaModel.calculateToolScore(
        easeOfImplementation: 3,
        effectiveness: 3,
      );
      expect(score, 100); // 最高スコア
    });

    test('calculateWisdomScore returns correct score with weights', () {
      // 即時性（50%）と実用性（50%）の重み付け
      final score = PriorityCriteriaModel.calculateWisdomScore(
        immediacy: 3,
        practicality: 3,
      );
      expect(score, 100); // 最高スコア
    });
  });
}
