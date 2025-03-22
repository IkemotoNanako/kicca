import 'package:flutter/material.dart';
import 'package:kicca/domain/model/ai_information_model.dart';

/// 情報詳細画面
class InformationDetailPage extends StatelessWidget {
  /// 情報
  final AIInformationModel information;

  /// コンストラクタ
  const InformationDetailPage({
    required this.information,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('支援情報の詳細'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // タイトル
            Text(
              information.title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            // 優先度
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
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
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // カテゴリ
            Text(
              'カテゴリ',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                information.category,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const SizedBox(height: 24),
            // 説明
            Text(
              '説明',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              information.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            // タグ
            Text(
              'タグ',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
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
            const SizedBox(height: 24),
            // 情報源
            Text(
              '情報源',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              information.source,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            // 作成日時
            Text(
              '作成日時',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              _formatDateTime(information.createdAt),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
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

  /// 日時をフォーマット
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}年${dateTime.month}月${dateTime.day}日 '
        '${dateTime.hour}時${dateTime.minute}分';
  }
}
