import '../type/diagnosis_type.dart';

/// 診断項目を定義するモデルクラス
class DiagnosisItemModel {
  /// 診断の種類
  final DiagnosisType type;

  /// 質問のID（1-5）
  final int id;

  /// 質問文
  final String question;

  /// 回答（0-3）
  final int? answer;

  /// コンストラクタ
  DiagnosisItemModel({
    required this.type,
    required this.id,
    required this.question,
    this.answer,
  }) : assert(id >= 1 && id <= 5);

  /// 回答が有効かどうかを検証する
  bool isValidAnswer(int answer) {
    return answer >= 0 && answer <= 3;
  }

  /// 回答を設定する
  DiagnosisItemModel copyWithAnswer(int answer) {
    if (!isValidAnswer(answer)) {
      throw ArgumentError('回答は0-3の範囲で入力してください');
    }

    return DiagnosisItemModel(
      type: type,
      id: id,
      question: question,
      answer: answer,
    );
  }

  /// 診断項目のリストを生成する
  static List<DiagnosisItemModel> generateItems() {
    return [
      // 発達障害の特徴に関する質問
      DiagnosisItemModel(
        type: DiagnosisType.developmental,
        id: 1,
        question: '整理整頓が苦手で、物をよく失くしてしまう',
      ),
      DiagnosisItemModel(
        type: DiagnosisType.developmental,
        id: 2,
        question: '時間の管理や締め切りを守ることが難しい',
      ),
      DiagnosisItemModel(
        type: DiagnosisType.developmental,
        id: 3,
        question: '人との会話で、話が噛み合わないことがよくある',
      ),
      DiagnosisItemModel(
        type: DiagnosisType.developmental,
        id: 4,
        question: '同時に複数のことをするのが苦手',
      ),
      DiagnosisItemModel(
        type: DiagnosisType.developmental,
        id: 5,
        question: '急な予定変更に対応するのが難しい',
      ),

      // 精神疾患の症状に関する質問
      DiagnosisItemModel(
        type: DiagnosisType.mental,
        id: 1,
        question: '気分の波が大きく、コントロールが難しい',
      ),
      DiagnosisItemModel(
        type: DiagnosisType.mental,
        id: 2,
        question: '不安や緊張が強く、日常生活に支障がある',
      ),
      DiagnosisItemModel(
        type: DiagnosisType.mental,
        id: 3,
        question: 'やる気が出ず、好きなことにも興味が持てない',
      ),
      DiagnosisItemModel(
        type: DiagnosisType.mental,
        id: 4,
        question: '周りの目が気になって、外出が怖い',
      ),
      DiagnosisItemModel(
        type: DiagnosisType.mental,
        id: 5,
        question: '睡眠の質が悪く、疲れが取れない',
      ),

      // 日常生活での困りごとに関する質問
      DiagnosisItemModel(
        type: DiagnosisType.daily,
        id: 1,
        question: '仕事や学業の継続が難しい',
      ),
      DiagnosisItemModel(
        type: DiagnosisType.daily,
        id: 2,
        question: '人間関係の構築・維持が難しい',
      ),
      DiagnosisItemModel(
        type: DiagnosisType.daily,
        id: 3,
        question: '金銭管理が苦手',
      ),
      DiagnosisItemModel(
        type: DiagnosisType.daily,
        id: 4,
        question: '日常的な家事の遂行が難しい',
      ),
      DiagnosisItemModel(
        type: DiagnosisType.daily,
        id: 5,
        question: '趣味や余暇活動を楽しめない',
      ),
    ];
  }
}
