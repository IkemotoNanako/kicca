import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:kicca/domain/model/ai_information_model.dart';
import 'package:kicca/domain/model/hearing_data_model.dart';

/// AIサービスプロバイダー
class AIServiceProvider extends ChangeNotifier {
  /// APIキー
  final String apiKey;

  /// 情報リスト
  List<AIInformationModel> _informationList = [];

  /// ローディング中かどうか
  bool _isLoading = false;

  /// エラーメッセージ
  String? _errorMessage;

  /// コンストラクタ
  AIServiceProvider({
    required this.apiKey,
  });

  /// 情報リスト
  List<AIInformationModel> get informationList => _informationList;
  set informationList(List<AIInformationModel> value) {
    _informationList = value;
    notifyListeners();
  }

  /// ローディング中かどうか
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// エラーメッセージ
  String? get errorMessage => _errorMessage;
  set errorMessage(String? value) {
    _errorMessage = value;
    notifyListeners();
  }

  /// 情報を生成する
  Future<void> generateInformation(HearingDataModel hearingData) async {
    try {
      isLoading = true;
      errorMessage = null;

      final model = GenerativeModel(
        model: 'gemini-pro',
        apiKey: apiKey,
      );

      final prompt = '''
あなたは、発達障害のある人に対して支援情報を提供するAIアシスタントです。
以下の情報をもとに、発達障害のある人に役立つ支援情報を3つ提案してください。

生活の困りごと：${hearingData.lifeDifficulties}
仕事の困りごと：${hearingData.workDifficulties}
得意なこと：${hearingData.strengths}

情報は以下の形式で提供してください：
- タイトル：簡潔で分かりやすいタイトル
- 説明：具体的な内容や手順
- カテゴリ：「支援制度」「ツール・サービス」「生活の知恵」のいずれか
- 優先度：0-100の数値（重要度に応じて）
- タグ：関連するキーワード（3つまで）
- 情報源：情報の出典
''';

      final content = await model.generateContent([Content.text(prompt)]);
      final response = content.text ?? '';

      // レスポンスをパースして情報リストを生成
      final informationList = _parseResponse(response);
      if (informationList.isEmpty) {
        throw Exception('情報の生成に失敗しました');
      }

      this.informationList = informationList;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

  /// レスポンスをパースする
  List<AIInformationModel> _parseResponse(String response) {
    final result = <AIInformationModel>[];
    final lines = response.split('\n');
    String? title;
    String? description;
    String? category;
    int? priority;
    List<String>? tags;
    String? source;

    for (final line in lines) {
      if (line.startsWith('タイトル：')) {
        // 前の情報があれば追加
        if (title != null &&
            description != null &&
            category != null &&
            priority != null &&
            tags != null &&
            source != null) {
          result.add(AIInformationModel(
            title: title,
            description: description,
            category: category,
            priority: priority,
            tags: tags,
            source: source,
            createdAt: DateTime.now(),
          ));
        }
        title = line.substring(5).trim();
      } else if (line.startsWith('説明：')) {
        description = line.substring(3).trim();
      } else if (line.startsWith('カテゴリ：')) {
        category = line.substring(5).trim();
      } else if (line.startsWith('優先度：')) {
        final value = line.substring(4).trim();
        priority = int.tryParse(value.replaceAll(RegExp(r'[^0-9]'), ''));
      } else if (line.startsWith('タグ：')) {
        final value = line.substring(3).trim();
        tags = value
            .split('、')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .take(3)
            .toList();
      } else if (line.startsWith('情報源：')) {
        source = line.substring(4).trim();
      }
    }

    // 最後の情報を追加
    if (title != null &&
        description != null &&
        category != null &&
        priority != null &&
        tags != null &&
        source != null) {
      result.add(AIInformationModel(
        title: title,
        description: description,
        category: category,
        priority: priority,
        tags: tags,
        source: source,
        createdAt: DateTime.now(),
      ));
    }

    return result;
  }
}
