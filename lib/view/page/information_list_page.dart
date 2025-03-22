import 'package:flutter/material.dart';
import 'package:kicca/domain/model/ai_information_model.dart';
import 'package:kicca/services/ai_service.dart';
import 'package:kicca/view/component/information_card.dart';

/// 情報一覧画面
class InformationListPage extends StatefulWidget {
  /// コンストラクタ
  const InformationListPage({super.key});

  @override
  State<InformationListPage> createState() => _InformationListPageState();
}

class _InformationListPageState extends State<InformationListPage> {
  /// 選択中のカテゴリ
  String _selectedCategory = '全て';

  /// 検索キーワード
  final _searchController = TextEditingController();

  /// 情報リスト
  List<AIInformationModel> _informationList = [];

  /// フィルター済みの情報リスト
  List<AIInformationModel> get _filteredList {
    return _informationList.where((info) {
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
    // TODO: AIServiceから情報を取得
    setState(() {
      _informationList = [
        AIInformationModel(
          title: '障害者手帳の申請方法',
          description: '障害者手帳の申請に必要な書類や手続きの流れを解説します。',
          category: '支援制度',
          priority: 90,
          tags: ['障害者手帳', '申請', '手続き'],
          source: '厚生労働省',
        ),
        AIInformationModel(
          title: 'タスク管理アプリ',
          description: '日々のタスクを管理しやすいアプリを紹介します。',
          category: 'ツール・サービス',
          priority: 80,
          tags: ['アプリ', 'タスク管理', '生産性'],
          source: 'アプリレビュー',
        ),
        AIInformationModel(
          title: '集中力を高める方法',
          description: '仕事や勉強に集中するためのテクニックを紹介します。',
          category: '生活の知恵',
          priority: 70,
          tags: ['集中力', '仕事', '勉強'],
          source: '専門家コラム',
        ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
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
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredList.length,
              itemBuilder: (context, index) {
                final info = _filteredList[index];
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
