import 'package:flutter_test/flutter_test.dart';
import 'package:kicca/domain/model/diagnosis_result_model.dart';
import 'package:kicca/domain/type/diagnosis_type.dart';

void main() {
  group('DiagnosisResultModel', () {
    test('calculates total score correctly', () {
      final result = DiagnosisResultModel(
        developmentalScore: 10,
        mentalScore: 8,
        dailyScore: 12,
      );
      expect(result.totalScore, 30);
    });

    test('gets score by type correctly', () {
      final result = DiagnosisResultModel(
        developmentalScore: 10,
        mentalScore: 8,
        dailyScore: 12,
      );

      expect(result.getScoreByType(DiagnosisType.developmental), 10);
      expect(result.getScoreByType(DiagnosisType.mental), 8);
      expect(result.getScoreByType(DiagnosisType.daily), 12);
    });

    test('gets severity level correctly', () {
      final result = DiagnosisResultModel(
        developmentalScore: 12, // 深刻
        mentalScore: 8, // やや深刻
        dailyScore: 4, // 軽度
      );

      expect(result.getSeverityLevel(DiagnosisType.developmental), 3);
      expect(result.getSeverityLevel(DiagnosisType.mental), 2);
      expect(result.getSeverityLevel(DiagnosisType.daily), 1);
    });

    test('gets most severe type correctly', () {
      final result = DiagnosisResultModel(
        developmentalScore: 10,
        mentalScore: 8,
        dailyScore: 12,
      );
      expect(result.getMostSevereType(), DiagnosisType.daily);
    });

    test('determines professional help need correctly', () {
      final result1 = DiagnosisResultModel(
        developmentalScore: 12, // 発達障害の特徴が顕著
        mentalScore: 8,
        dailyScore: 8,
      );
      expect(result1.needsProfessionalHelp(), true);

      final result2 = DiagnosisResultModel(
        developmentalScore: 8,
        mentalScore: 12, // 精神疾患の症状が顕著
        dailyScore: 8,
      );
      expect(result2.needsProfessionalHelp(), true);

      final result3 = DiagnosisResultModel(
        developmentalScore: 10,
        mentalScore: 10,
        dailyScore: 10,
      );
      expect(result3.needsProfessionalHelp(), true); // 合計30点以上

      final result4 = DiagnosisResultModel(
        developmentalScore: 8,
        mentalScore: 8,
        dailyScore: 8,
      );
      expect(result4.needsProfessionalHelp(), false);
    });

    test('throws error for invalid scores', () {
      expect(
        () => DiagnosisResultModel(
          developmentalScore: -1,
          mentalScore: 8,
          dailyScore: 8,
        ),
        throwsAssertionError,
      );

      expect(
        () => DiagnosisResultModel(
          developmentalScore: 8,
          mentalScore: 16,
          dailyScore: 8,
        ),
        throwsAssertionError,
      );

      expect(
        () => DiagnosisResultModel(
          developmentalScore: 8,
          mentalScore: 8,
          dailyScore: -1,
        ),
        throwsAssertionError,
      );
    });
  });
}
