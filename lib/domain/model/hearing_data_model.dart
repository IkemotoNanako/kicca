/// ヒヤリングデータのモデル
class HearingDataModel {
  /// 生活での困りごと
  final String lifeDifficulties;

  /// 仕事での困りごと
  final String workDifficulties;

  /// 得意なこと
  final String strengths;

  /// 作成日時
  final DateTime createdAt;

  /// コンストラクタ
  HearingDataModel({
    required this.lifeDifficulties,
    required this.workDifficulties,
    required this.strengths,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// コピーメソッド
  HearingDataModel copyWith({
    String? lifeDifficulties,
    String? workDifficulties,
    String? strengths,
    DateTime? createdAt,
  }) {
    return HearingDataModel(
      lifeDifficulties: lifeDifficulties ?? this.lifeDifficulties,
      workDifficulties: workDifficulties ?? this.workDifficulties,
      strengths: strengths ?? this.strengths,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// JSONからモデルを作成
  factory HearingDataModel.fromJson(Map<String, dynamic> json) {
    return HearingDataModel(
      lifeDifficulties: json['lifeDifficulties'] as String,
      workDifficulties: json['workDifficulties'] as String,
      strengths: json['strengths'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// モデルをJSONに変換
  Map<String, dynamic> toJson() {
    return {
      'lifeDifficulties': lifeDifficulties,
      'workDifficulties': workDifficulties,
      'strengths': strengths,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
