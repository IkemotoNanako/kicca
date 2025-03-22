import 'package:flutter/material.dart';
import 'package:kicca/domain/model/ai_information_model.dart';
import 'package:kicca/view/page/information_detail_page.dart';

/// 情報カードコンポーネント
class InformationCard extends StatelessWidget {
  /// 情報
  final AIInformationModel information;

  /// コンストラクタ
  const InformationCard({
    required this.information,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => InformationDetailPage(
                information: information,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // タイトルと優先度
              Row(
                children: [
                  Expanded(
                    child: Text(
                      information.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getPriorityColor(information.priority),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '優先度: ${information.priority}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // 説明
              Text(
                information.description,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              // カテゴリ
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  information.category,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: 8),
              // タグ
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: information.tags.map((tag) {
                  return Chip(
                    label: Text(tag),
                    backgroundColor: Colors.blue[100],
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),
              // 情報源
              Text(
                '出典: ${information.source}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 優先度に応じた色を取得
  Color _getPriorityColor(int priority) {
    if (priority >= 80) {
      return Colors.red;
    } else if (priority >= 50) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }
}
