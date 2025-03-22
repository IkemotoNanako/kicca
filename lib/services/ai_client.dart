import 'package:google_generative_ai/google_generative_ai.dart';

/// Gemini APIのクライアントをラップするクラス
class AIClient {
  /// Gemini APIのクライアント
  final GenerativeModel _model;

  /// コンストラクタ
  AIClient({required String apiKey})
      : _model = GenerativeModel(
          model: 'gemini-pro',
          apiKey: apiKey,
        );

  /// コンテンツを生成する
  Future<String?> generateContent(String prompt) async {
    final response = await _model.generateContent([Content.text(prompt)]);
    return response.text;
  }
}
