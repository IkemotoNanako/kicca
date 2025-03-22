import 'package:flutter/material.dart';
import 'package:kicca/domain/model/ai_information_model.dart';
import 'package:url_launcher/url_launcher.dart';

/// 情報詳細画面
class InformationDetailPage extends StatelessWidget {
  /// コンストラクタ
  const InformationDetailPage({
    required this.information,
    super.key,
  });

  /// 表示する情報
  final AIInformationModel information;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('詳細情報'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Semantics(
                    label: '情報のタイトル',
                    child: Text(
                      information.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      Chip(
                        label: Text(information.category),
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                      ),
                      ...information.tags.map(
                        (tag) => Chip(
                          label: Text(tag),
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.1),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Semantics(
                    label: '情報の説明',
                    child: Text(
                      information.description,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  if (information.url != null) ...[
                    const SizedBox(height: 24),
                    Center(
                      child: Semantics(
                        label: '外部サイトで詳細を確認',
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final url = Uri.parse(information.url!);
                            try {
                              if (await canLaunchUrl(url)) {
                                await launchUrl(url);
                              } else {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('URLを開けませんでした'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('エラーが発生しました: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                          icon: const Icon(Icons.open_in_new),
                          label: const Text('詳細を見る'),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Semantics(
                    label: '作成日時',
                    child: Text(
                      '作成日時: ${information.createdAt.toLocal()}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
