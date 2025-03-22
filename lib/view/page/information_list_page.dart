import 'package:flutter/material.dart';
import 'package:kicca/domain/model/ai_information_model.dart';
import 'package:kicca/domain/model/hearing_data_model.dart';
import 'package:kicca/providers/ai_service_provider.dart';
import 'package:kicca/view/component/information_card.dart';
import 'package:provider/provider.dart';

/// 情報一覧画面
class InformationListPage extends StatefulWidget {
  /// ヒヤリング情報
  final HearingDataModel hearingData;

  /// コンストラクタ
  const InformationListPage({
    required this.hearingData,
    super.key,
  });

  @override
  State<InformationListPage> createState() => _InformationListPageState();
}

class _InformationListPageState extends State<InformationListPage> {
  /// 選択中のカテゴリ
  String _selectedCategory = '全て';

  /// 検索キーワード
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadInformation();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// 情報を読み込む
  Future<void> _loadInformation() async {
    final provider = context.read<AIServiceProvider>();
    await provider.generateInformation(widget.hearingData);
  }

  /// フィルター済みの情報リスト
  List<AIInformationModel> _getFilteredList() {
    final provider = context.watch<AIServiceProvider>();
    return provider.informationList.where((info) {
      // カテゴリフィルター
      if (_selectedCategory != '全て' && info.category != _selectedCategory) {
        return false;
      }
      // キーワード検索
      final keyword = _searchController.text.toLowerCase();
      if (keyword.isNotEmpty) {
        return info.title.toLowerCase().contains(keyword) ||
            info.description.toLowerCase().contains(keyword) ||
            info.tags.any((tag) => tag.toLowerCase().contains(keyword));
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AIServiceProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('支援情報一覧'),
      ),
      body: Column(
        children: [
          // 検索バー
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'キーワードで検索',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          // カテゴリフィルター
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                '全て',
                '支援制度',
                'ツール・サービス',
                '生活の知恵',
              ].map((category) {
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          // 情報リスト
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.errorMessage != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              provider.errorMessage!,
                              style: Theme.of(context).textTheme.bodyLarge,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadInformation,
                              child: const Text('再試行'),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _getFilteredList().length,
                        itemBuilder: (context, index) {
                          final info = _getFilteredList()[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: InformationCard(information: info),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
