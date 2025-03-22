import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:kicca/domain/model/ai_information_model.dart';
import 'package:kicca/domain/model/hearing_data_model.dart';
import 'package:kicca/domain/model/priority_criteria_model.dart';

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
- 緊急度：0-5の数値（5が最も緊急）
- 重要度：0-5の数値（5が最も重要）
- 実装の容易さ：0-5の数値（5が最も容易）
- 効果の高さ：0-5の数値（5が最も効果的）
- 即時性：0-5の数値（5が最も即時）
- 実用性：0-5の数値（5が最も実用的）
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
    int? urgency;
    int? importance;
    int? easeOfImplementation;
    int? effectiveness;
    int? immediacy;
    int? practicality;
    List<String>? tags;
    String? source;

    for (final line in lines) {
      if (line.startsWith('タイトル：')) {
        // 前の情報があれば追加
        if (title != null &&
            description != null &&
            category != null &&
            urgency != null &&
            importance != null &&
            easeOfImplementation != null &&
            effectiveness != null &&
            immediacy != null &&
            practicality != null &&
            tags != null &&
            source != null) {
          result.add(_createInformationModel(
            title: title,
            description: description,
            category: category,
            urgency: urgency,
            importance: importance,
            easeOfImplementation: easeOfImplementation,
            effectiveness: effectiveness,
            immediacy: immediacy,
            practicality: practicality,
            tags: tags,
            source: source,
          ));
        }
        title = line.substring(5).trim();
      } else if (line.startsWith('説明：')) {
        description = line.substring(3).trim();
      } else if (line.startsWith('カテゴリ：')) {
        category = line.substring(5).trim();
      } else if (line.startsWith('緊急度：')) {
        final value = line.substring(4).trim();
        urgency = int.tryParse(value.replaceAll(RegExp(r'[^0-9]'), ''));
      } else if (line.startsWith('重要度：')) {
        final value = line.substring(4).trim();
        importance = int.tryParse(value.replaceAll(RegExp(r'[^0-9]'), ''));
      } else if (line.startsWith('実装の容易さ：')) {
        final value = line.substring(7).trim();
        easeOfImplementation =
            int.tryParse(value.replaceAll(RegExp(r'[^0-9]'), ''));
      } else if (line.startsWith('効果の高さ：')) {
        final value = line.substring(6).trim();
        effectiveness = int.tryParse(value.replaceAll(RegExp(r'[^0-9]'), ''));
      } else if (line.startsWith('即時性：')) {
        final value = line.substring(4).trim();
        immediacy = int.tryParse(value.replaceAll(RegExp(r'[^0-9]'), ''));
      } else if (line.startsWith('実用性：')) {
        final value = line.substring(4).trim();
        practicality = int.tryParse(value.replaceAll(RegExp(r'[^0-9]'), ''));
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
        urgency != null &&
        importance != null &&
        easeOfImplementation != null &&
        effectiveness != null &&
        immediacy != null &&
        practicality != null &&
        tags != null &&
        source != null) {
      result.add(_createInformationModel(
        title: title,
        description: description,
        category: category,
        urgency: urgency,
        importance: importance,
        easeOfImplementation: easeOfImplementation,
        effectiveness: effectiveness,
        immediacy: immediacy,
        practicality: practicality,
        tags: tags,
        source: source,
      ));
    }

    return result;
  }

  /// 情報モデルを作成する
  AIInformationModel _createInformationModel({
    required String title,
    required String description,
    required String category,
    required int urgency,
    required int importance,
    required int easeOfImplementation,
    required int effectiveness,
    required int immediacy,
    required int practicality,
    required List<String> tags,
    required String source,
  }) {
    // カテゴリに応じて優先度を計算
    final priority = calculatePriority(
      category: category,
      urgency: urgency,
      importance: importance,
      easeOfImplementation: easeOfImplementation,
      effectiveness: effectiveness,
      immediacy: immediacy,
      practicality: practicality,
    );

    return AIInformationModel(
      title: title,
      description: description,
      category: category,
      priority: priority,
      tags: tags,
      source: source,
      createdAt: DateTime.now(),
    );
  }

  /// 優先度を計算する
  int calculatePriority({
    required String category,
    required int urgency,
    required int importance,
    required int easeOfImplementation,
    required int effectiveness,
    required int immediacy,
    required int practicality,
  }) {
    switch (category) {
      case '支援制度':
        return PriorityCriteriaModel.calculateSupportScore(
          urgency: urgency,
          importance: importance,
        );
      case 'ツール・サービス':
        return PriorityCriteriaModel.calculateToolScore(
          easeOfImplementation: easeOfImplementation,
          effectiveness: effectiveness,
        );
      case '生活の知恵':
        return PriorityCriteriaModel.calculateWisdomScore(
          immediacy: immediacy,
          practicality: practicality,
        );
      default:
        return 0;
    }
  }
}
