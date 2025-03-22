import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:kicca/domain/model/ai_suggestion_model.dart';
import 'package:kicca/domain/model/diagnosis_result_model.dart';
import 'package:kicca/services/ai_client.dart';

/// AIによる提案を生成するサービス
class AISuggestionService {
  /// Gemini APIのクライアント
  final AIClient _client;

  /// コンストラクタ
  AISuggestionService({required String apiKey})
      : _client = AIClient(apiKey: apiKey);

  /// 診断結果に基づいて提案を生成する
  Future<List<AISuggestionModel>> generateSuggestions(
    DiagnosisResultModel result,
  ) async {
    final prompt = '''
診断結果に基づいて、以下の形式で提案を生成してください。
各提案は、タイトル、説明、優先度（1-5）、カテゴリ、タグ、出典を含めてください。

診断結果:
- 発達障害の特徴: ${result.developmentalScore}点
- 精神疾患の症状: ${result.mentalScore}点
- 日常生活での困りごと: ${result.dailyScore}点

最も深刻な課題: ${result.getMostSevereType().toString().split('.').last}

提案は以下の形式で出力してください:
{
  "suggestions": [
    {
      "title": "提案のタイトル",
      "description": "提案の詳細な説明",
      "priority": 1-5の数字,
      "category": "カテゴリ（支援制度/ツール・サービス/生活の知恵）",
      "tags": ["タグ1", "タグ2"],
      "source": "出典"
    }
  ]
}
''';

    try {
      final text = await _client.generateContent(prompt);
      if (text == null) {
        throw Exception('AIからの応答が空です');
      }

      // JSONレスポンスをパースして提案リストを生成
      final suggestions = _parseSuggestions(text);
      return suggestions;
    } catch (e) {
      throw Exception('提案の生成に失敗しました: $e');
    }
  }

  /// AIの応答をパースして提案リストを生成する
  List<AISuggestionModel> _parseSuggestions(String response) {
    // TODO: JSONパースの実装
    // 現時点ではダミーデータを返す
    return [
      AISuggestionModel(
        title: 'サンプル提案',
        description: 'これはサンプルの提案です。',
        priority: 3,
        category: '支援制度',
        tags: ['サンプル'],
        source: 'AI',
        createdAt: DateTime.now(),
      ),
    ];
  }
}
