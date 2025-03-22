import '../type/priority_type.dart';

/// スコアリングロジックを実装するモデルクラス
class ScoringModel {
  /// スコアの範囲を検証する
  static bool isValidScore(int score) {
    return score >= 1 && score <= 3;
  }

  /// スコアを0-100の範囲に正規化する
  static int normalizeScore(double score) {
    return score.round();
  }

  /// 支援情報のスコアを計算する
  static int calculateSupportScore({
    required int urgency,
    required int importance,
  }) {
    if (!isValidScore(urgency) || !isValidScore(importance)) {
      throw ArgumentError('スコアは1-3の範囲で入力してください');
    }

    // 緊急度（60%）と重要度（40%）の重み付け
    final weightedScore = ((urgency * 0.6 + importance * 0.4) / 3) * 100;
    return normalizeScore(weightedScore);
  }

  /// ツール・サービスのスコアを計算する
  static int calculateToolScore({
    required int easeOfImplementation,
    required int effectiveness,
  }) {
    if (!isValidScore(easeOfImplementation) || !isValidScore(effectiveness)) {
      throw ArgumentError('スコアは1-3の範囲で入力してください');
    }

    // 実装の容易さ（40%）と効果の高さ（60%）の重み付け
    final weightedScore =
        ((easeOfImplementation * 0.4 + effectiveness * 0.6) / 3) * 100;
    return normalizeScore(weightedScore);
  }

  /// 生活の知恵のスコアを計算する
  static int calculateWisdomScore({
    required int immediacy,
    required int practicality,
  }) {
    if (!isValidScore(immediacy) || !isValidScore(practicality)) {
      throw ArgumentError('スコアは1-3の範囲で入力してください');
    }

    // 即時性（50%）と実用性（50%）の重み付け
    final weightedScore = ((immediacy * 0.5 + practicality * 0.5) / 3) * 100;
    return normalizeScore(weightedScore);
  }

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
}
