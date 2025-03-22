import 'package:flutter_test/flutter_test.dart';
import 'package:kicca/domain/model/hearing_data_model.dart';

void main() {
  group('HearingDataModel', () {
    test('コンストラクタのテスト', () {
      final model = HearingDataModel(
        lifeDifficulties: '生活での困りごと',
        workDifficulties: '仕事での困りごと',
        strengths: '得意なこと',
      );

      expect(model.lifeDifficulties, '生活での困りごと');
      expect(model.workDifficulties, '仕事での困りごと');
      expect(model.strengths, '得意なこと');
      expect(model.createdAt, isA<DateTime>());
    });

    test('copyWithのテスト', () {
      final model = HearingDataModel(
        lifeDifficulties: '生活での困りごと',
        workDifficulties: '仕事での困りごと',
        strengths: '得意なこと',
      );

      final copied = model.copyWith(
        lifeDifficulties: '新しい生活での困りごと',
      );

      expect(copied.lifeDifficulties, '新しい生活での困りごと');
      expect(copied.workDifficulties, '仕事での困りごと');
      expect(copied.strengths, '得意なこと');
      expect(copied.createdAt, model.createdAt);
    });

    test('fromJsonのテスト', () {
      final json = {
        'lifeDifficulties': '生活での困りごと',
        'workDifficulties': '仕事での困りごと',
        'strengths': '得意なこと',
        'createdAt': '2024-03-22T00:00:00.000Z',
      };

      final model = HearingDataModel.fromJson(json);

      expect(model.lifeDifficulties, '生活での困りごと');
      expect(model.workDifficulties, '仕事での困りごと');
      expect(model.strengths, '得意なこと');
      expect(model.createdAt, DateTime.parse('2024-03-22T00:00:00.000Z'));
    });

    test('toJsonのテスト', () {
      final model = HearingDataModel(
        lifeDifficulties: '生活での困りごと',
        workDifficulties: '仕事での困りごと',
        strengths: '得意なこと',
        createdAt: DateTime.parse('2024-03-22T00:00:00.000Z'),
      );

      final json = model.toJson();

      expect(json['lifeDifficulties'], '生活での困りごと');
      expect(json['workDifficulties'], '仕事での困りごと');
      expect(json['strengths'], '得意なこと');
      expect(json['createdAt'], '2024-03-22T00:00:00.000Z');
    });
  });
}
