import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:kicca/domain/model/ai_information_model.dart';
import 'package:kicca/domain/model/hearing_data_model.dart';

/// AIによる情報収集・提供を行うサービス
class AIService {
  /// Gemini APIのモデル
  final GenerativeModel _model;

  /// コンストラクタ
  AIService({required String apiKey})
      : _model = GenerativeModel(
          model: 'gemini-pro',
          apiKey: apiKey,
        );

  /// ヒヤリング情報から支援情報を生成する
  Future<List<AIInformationModel>> generateInformation(
    HearingDataModel hearingData,
  ) async {
    final prompt = '''
以下のヒヤリング情報から、適切な支援情報を生成してください。

生活での困りごと：
${hearingData.lifeDifficulties}

仕事での困りごと：
${hearingData.workDifficulties}

得意なこと：
${hearingData.strengths}

以下の形式でJSON形式で出力してください：
[
  {
    "title": "情報のタイトル",
    "description": "説明",
    "category": "支援制度/ツール・サービス/生活の知恵",
    "priority": 0-100の数値,
    "tags": ["タグ1", "タグ2"],
    "source": "情報源"
  }
]
''';

    final response = await _model.generateContent([Content.text(prompt)]);
    final jsonString = response.text;
    if (jsonString == null) {
      throw Exception('AIからの応答が空です');
    }

    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => AIInformationModel.fromJson(json)).toList();
  }
}
