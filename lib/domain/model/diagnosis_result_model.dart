import '../type/diagnosis_type.dart';

/// 診断結果を定義するモデルクラス
class DiagnosisResultModel {
  /// 発達障害の特徴のスコア（0-15点）
  final int developmentalScore;

  /// 精神疾患の症状のスコア（0-15点）
  final int mentalScore;

  /// 日常生活での困りごとのスコア（0-15点）
  final int dailyScore;

  /// コンストラクタ
  DiagnosisResultModel({
    required this.developmentalScore,
    required this.mentalScore,
    required this.dailyScore,
  })  : assert(developmentalScore >= 0 && developmentalScore <= 15),
        assert(mentalScore >= 0 && mentalScore <= 15),
        assert(dailyScore >= 0 && dailyScore <= 15);

  /// 合計スコアを取得する（0-45点）
  int get totalScore => developmentalScore + mentalScore + dailyScore;

  /// カテゴリー別のスコアを取得する
  int getScoreByType(DiagnosisType type) {
    switch (type) {
      case DiagnosisType.developmental:
        return developmentalScore;
      case DiagnosisType.mental:
        return mentalScore;
      case DiagnosisType.daily:
        return dailyScore;
    }
  }

  /// スコアの深刻度を判定する（0-3）
  int getSeverityLevel(DiagnosisType type) {
    final score = getScoreByType(type);
    if (score >= 12) {
      return 3; // 深刻
    } else if (score >= 8) {
      return 2; // やや深刻
    } else if (score >= 4) {
      return 1; // 軽度
    } else {
      return 0; // 問題なし
    }
  }

  /// 最も深刻な課題のタイプを取得する
  DiagnosisType getMostSevereType() {
    final scores = {
      DiagnosisType.developmental: developmentalScore,
      DiagnosisType.mental: mentalScore,
      DiagnosisType.daily: dailyScore,
    };
    return scores.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  /// 専門家への相談が必要かどうかを判定する
  bool needsProfessionalHelp() {
    return totalScore >= 30 || // 全体的に深刻
        developmentalScore >= 12 || // 発達障害の特徴が顕著
        mentalScore >= 12; // 精神疾患の症状が顕著
  }
}
