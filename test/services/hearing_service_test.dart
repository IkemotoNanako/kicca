import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences.dart';
import 'package:kicca/domain/model/hearing_data_model.dart';
import 'package:kicca/services/hearing_service.dart';

void main() {
  late SharedPreferences prefs;
  late HearingService service;

  setUpAll(() async {
    prefs = await SharedPreferences.getInstance();
    service = HearingService(prefs);
  });

  tearDownAll(() async {
    await prefs.clear();
  });

  group('HearingService', () {
    test('データの保存と取得', () async {
      final data = HearingDataModel(
        lifeDifficulties: '生活での困りごと',
        workDifficulties: '仕事での困りごと',
        strengths: '得意なこと',
      );

      await service.saveHearingData(data);
      final retrieved = service.getHearingData();

      expect(retrieved, isNotNull);
      expect(retrieved!.lifeDifficulties, data.lifeDifficulties);
      expect(retrieved.workDifficulties, data.workDifficulties);
      expect(retrieved.strengths, data.strengths);
      expect(retrieved.createdAt, data.createdAt);
    });

    test('データの削除', () async {
      final data = HearingDataModel(
        lifeDifficulties: '生活での困りごと',
        workDifficulties: '仕事での困りごと',
        strengths: '得意なこと',
      );

      await service.saveHearingData(data);
      await service.deleteHearingData();
      final retrieved = service.getHearingData();

      expect(retrieved, isNull);
    });
  });
}
