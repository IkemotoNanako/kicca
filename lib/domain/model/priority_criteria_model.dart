import '../type/priority_type.dart';
import '../type/information_type.dart';

/// 優先順位基準を定義するモデルクラス
class PriorityCriteriaModel {
  /// 情報の種類
  final InformationType type;

  /// スコア（0-100）
  final int score;

  /// 優先順位
  final PriorityType priority;

  /// コンストラクタ
  PriorityCriteriaModel({
    required this.type,
    required this.score,
    required this.priority,
  });

  /// スコアから優先順位を計算する
  static PriorityType calculatePriority(int score) {
    if (score >= 80) {
      return PriorityType.high;
    } else if (score >= 50) {
      return PriorityType.medium;
    } else {
      return PriorityType.low;
    }
  }

  /// 支援情報のスコアを計算する
  static int calculateSupportScore({
    required int urgency,
    required int importance,
  }) {
    // 緊急度（60%）と重要度（40%）の重み付け
    final weightedScore = (urgency * 0.6 + importance * 0.4) * 100 / 6;
    return weightedScore.round();
  }

  /// ツール・サービスのスコアを計算する
  static int calculateToolScore({
    required int easeOfImplementation,
    required int effectiveness,
  }) {
    // 実装の容易さ（40%）と効果の高さ（60%）の重み付け
    final weightedScore =
        (easeOfImplementation * 0.4 + effectiveness * 0.6) * 100 / 6;
    return weightedScore.round();
  }

  /// 生活の知恵のスコアを計算する
  static int calculateWisdomScore({
    required int immediacy,
    required int practicality,
  }) {
    // 即時性（50%）と実用性（50%）の重み付け
    final weightedScore = (immediacy * 0.5 + practicality * 0.5) * 100 / 6;
    return weightedScore.round();
  }
}
