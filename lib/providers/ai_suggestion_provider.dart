import 'package:flutter/material.dart';
import 'package:kicca/domain/model/ai_suggestion_model.dart';
import 'package:kicca/domain/model/diagnosis_result_model.dart';
import 'package:kicca/services/ai_suggestion_service.dart';

/// AIによる提案を管理するプロバイダー
class AISuggestionProvider extends ChangeNotifier {
  /// AIによる提案を生成するサービス
  final AISuggestionService _service;

  /// 提案リスト
  List<AISuggestionModel> _suggestions = [];

  /// ローディング中かどうか
  bool _isLoading = false;

  /// エラーメッセージ
  String? _errorMessage;

  /// コンストラクタ
  AISuggestionProvider({required String apiKey})
      : _service = AISuggestionService(apiKey: apiKey);

  /// 提案リストを取得する
  List<AISuggestionModel> get suggestions => _suggestions;

  /// ローディング中かどうかを取得する
  bool get isLoading => _isLoading;

  /// エラーメッセージを取得する
  String? get errorMessage => _errorMessage;

  /// 診断結果に基づいて提案を生成する
  Future<void> generateSuggestions(DiagnosisResultModel result) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _suggestions = await _service.generateSuggestions(result);
    } catch (e) {
      _errorMessage = e.toString();
      _suggestions = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 提案リストをクリアする
  void clearSuggestions() {
    _suggestions = [];
    _errorMessage = null;
    notifyListeners();
  }
}
