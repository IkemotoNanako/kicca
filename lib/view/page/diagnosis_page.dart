import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kicca/domain/model/diagnosis_item_model.dart';
import 'package:kicca/domain/model/diagnosis_result_model.dart';
import 'package:kicca/domain/type/diagnosis_type.dart';
import 'package:kicca/providers/ai_suggestion_provider.dart';

/// 診断画面
class DiagnosisPage extends StatefulWidget {
  const DiagnosisPage({super.key});

  @override
  State<DiagnosisPage> createState() => _DiagnosisPageState();
}

class _DiagnosisPageState extends State<DiagnosisPage> {
  /// 診断項目のリスト
  late final List<DiagnosisItemModel> _items;

  /// 現在の質問インデックス
  int _currentIndex = 0;

  /// 診断結果
  DiagnosisResultModel? _result;

  @override
  void initState() {
    super.initState();
    _items = DiagnosisItemModel.generateItems();
  }

  /// 回答を設定する
  void _setAnswer(int answer) {
    setState(() {
      _items[_currentIndex] = _items[_currentIndex].copyWithAnswer(answer);
      if (_currentIndex < _items.length - 1) {
        _currentIndex++;
      } else {
        _calculateResult();
      }
    });
  }

  /// 診断結果を計算する
  void _calculateResult() {
    final developmentalScore =
        _calculateCategoryScore(DiagnosisType.developmental);
    final mentalScore = _calculateCategoryScore(DiagnosisType.mental);
    final dailyScore = _calculateCategoryScore(DiagnosisType.daily);

    setState(() {
      _result = DiagnosisResultModel(
        developmentalScore: developmentalScore,
        mentalScore: mentalScore,
        dailyScore: dailyScore,
      );
    });

    // AIによる提案を生成
    final aiProvider =
        Provider.of<AISuggestionProvider>(context, listen: false);
    aiProvider.generateSuggestions(_result!);
  }

  /// カテゴリー別のスコアを計算する
  int _calculateCategoryScore(DiagnosisType type) {
    return _items
        .where((item) => item.type == type)
        .map((item) => item.answer ?? 0)
        .reduce((a, b) => a + b);
  }

  /// 診断をリセットする
  void _resetDiagnosis() {
    setState(() {
      _items.clear();
      _items.addAll(DiagnosisItemModel.generateItems());
      _currentIndex = 0;
      _result = null;
    });

    // AIによる提案をクリア
    final aiProvider =
        Provider.of<AISuggestionProvider>(context, listen: false);
    aiProvider.clearSuggestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('診断'),
        actions: [
          if (_result != null)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _resetDiagnosis,
            ),
        ],
      ),
      body: _result != null ? _buildResult() : _buildQuestion(),
    );
  }

  /// 質問画面を構築する
  Widget _buildQuestion() {
    final item = _items[_currentIndex];
    final progress = (_currentIndex + 1) / _items.length;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LinearProgressIndicator(value: progress),
          const SizedBox(height: 16),
          Text(
            '質問 ${_currentIndex + 1}/${_items.length}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 24),
          Text(
            item.question,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 32),
          _buildAnswerButtons(),
        ],
      ),
    );
  }

  /// 回答ボタンを構築する
  Widget _buildAnswerButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildAnswerButton(3, 'とてもあてはまる'),
        const SizedBox(height: 8),
        _buildAnswerButton(2, 'ややあてはまる'),
        const SizedBox(height: 8),
        _buildAnswerButton(1, 'あまりあてはまらない'),
        const SizedBox(height: 8),
        _buildAnswerButton(0, '全くあてはまらない'),
      ],
    );
  }

  /// 回答ボタンを構築する
  Widget _buildAnswerButton(int value, String label) {
    return ElevatedButton(
      onPressed: () => _setAnswer(value),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: Text(label),
    );
  }

  /// 結果画面を構築する
  Widget _buildResult() {
    final result = _result!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '診断結果',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          _buildCategoryResult(
            '発達障害の特徴',
            result.developmentalScore,
            result.getSeverityLevel(DiagnosisType.developmental),
          ),
          const SizedBox(height: 16),
          _buildCategoryResult(
            '精神疾患の症状',
            result.mentalScore,
            result.getSeverityLevel(DiagnosisType.mental),
          ),
          const SizedBox(height: 16),
          _buildCategoryResult(
            '日常生活での困りごと',
            result.dailyScore,
            result.getSeverityLevel(DiagnosisType.daily),
          ),
          const SizedBox(height: 24),
          Text(
            '合計スコア: ${result.totalScore}点',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          if (result.needsProfessionalHelp()) ...[
            const SizedBox(height: 16),
            const Card(
              color: Colors.red,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  '専門家への相談をお勧めします。',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
          const SizedBox(height: 32),
          Text(
            'AIによる提案',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          Consumer<AISuggestionProvider>(
            builder: (context, aiProvider, child) {
              if (aiProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (aiProvider.errorMessage != null) {
                return Card(
                  color: Colors.red,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      aiProvider.errorMessage!,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              }

              if (aiProvider.suggestions.isEmpty) {
                return const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('提案がありません'),
                  ),
                );
              }

              return Column(
                children: aiProvider.suggestions.map((suggestion) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            suggestion.title,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: suggestion.getPriorityColor(),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '優先度: ${suggestion.priority}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            suggestion.description,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: [
                              Chip(
                                label: Text(suggestion.category),
                                backgroundColor: Colors.blue[100],
                              ),
                              ...suggestion.tags.map(
                                (tag) => Chip(
                                  label: Text(tag),
                                  backgroundColor: Colors.grey[200],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  /// カテゴリー別の結果を構築する
  Widget _buildCategoryResult(String title, int score, int severity) {
    final severityText = switch (severity) {
      3 => '深刻',
      2 => 'やや深刻',
      1 => '軽度',
      _ => '問題なし',
    };

    final color = switch (severity) {
      3 => Colors.red,
      2 => Colors.orange,
      1 => Colors.yellow,
      _ => Colors.green,
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'スコア: $score点',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 4),
            Text(
              '深刻度: $severityText',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
