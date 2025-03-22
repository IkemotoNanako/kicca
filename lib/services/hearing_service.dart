import 'dart:convert';
import 'package:shared_preferences.dart';
import 'package:kicca/domain/model/hearing_data_model.dart';

/// ヒヤリングデータを管理するサービス
class HearingService {
  /// 保存キー
  static const String _storageKey = 'hearing_data';

  /// SharedPreferencesインスタンス
  final SharedPreferences _prefs;

  /// コンストラクタ
  HearingService(this._prefs);

  /// ヒヤリングデータを保存する
  Future<void> saveHearingData(HearingDataModel data) async {
    final json = data.toJson();
    await _prefs.setString(_storageKey, jsonEncode(json));
  }

  /// ヒヤリングデータを取得する
  HearingDataModel? getHearingData() {
    final jsonString = _prefs.getString(_storageKey);
    if (jsonString == null) return null;

    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return HearingDataModel.fromJson(json);
  }

  /// ヒヤリングデータを削除する
  Future<void> deleteHearingData() async {
    await _prefs.remove(_storageKey);
  }
}
