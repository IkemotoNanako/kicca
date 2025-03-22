import 'package:flutter_test/flutter_test.dart';
import 'package:kicca/domain/model/scoring_model.dart';
import 'package:kicca/domain/type/priority_type.dart';

void main() {
  group('ScoringModel', () {
    test('isValidScore returns true for valid scores', () {
      expect(ScoringModel.isValidScore(1), true);
      expect(ScoringModel.isValidScore(2), true);
      expect(ScoringModel.isValidScore(3), true);
    });

    test('isValidScore returns false for invalid scores', () {
      expect(ScoringModel.isValidScore(0), false);
      expect(ScoringModel.isValidScore(4), false);
      expect(ScoringModel.isValidScore(-1), false);
    });

    test('normalizeScore rounds correctly', () {
      expect(ScoringModel.normalizeScore(50.4), 50);
      expect(ScoringModel.normalizeScore(50.5), 51);
      expect(ScoringModel.normalizeScore(50.6), 51);
    });

    test('calculateSupportScore returns correct score with weights', () {
      // 緊急度（60%）と重要度（40%）の重み付け
      final score = ScoringModel.calculateSupportScore(
        urgency: 3,
        importance: 3,
      );
      expect(score, 100); // 最高スコア
    });

    test('calculateToolScore returns correct score with weights', () {
      // 実装の容易さ（40%）と効果の高さ（60%）の重み付け
      final score = ScoringModel.calculateToolScore(
        easeOfImplementation: 3,
        effectiveness: 3,
      );
      expect(score, 100); // 最高スコア
    });

    test('calculateWisdomScore returns correct score with weights', () {
      // 即時性（50%）と実用性（50%）の重み付け
      final score = ScoringModel.calculateWisdomScore(
        immediacy: 3,
        practicality: 3,
      );
      expect(score, 100); // 最高スコア
    });

    test('calculatePriority returns correct priority based on score', () {
      expect(ScoringModel.calculatePriority(90), PriorityType.high);
      expect(ScoringModel.calculatePriority(75), PriorityType.medium);
      expect(ScoringModel.calculatePriority(30), PriorityType.low);
    });

    test('throws ArgumentError for invalid scores', () {
      expect(
        () => ScoringModel.calculateSupportScore(
          urgency: 0,
          importance: 3,
        ),
        throwsArgumentError,
      );

      expect(
        () => ScoringModel.calculateToolScore(
          easeOfImplementation: 4,
          effectiveness: 3,
        ),
        throwsArgumentError,
      );

      expect(
        () => ScoringModel.calculateWisdomScore(
          immediacy: 3,
          practicality: -1,
        ),
        throwsArgumentError,
      );
    });
  });
}
