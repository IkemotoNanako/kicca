import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kicca/domain/model/ai_information_model.dart';
import 'package:kicca/domain/model/hearing_data_model.dart';
import 'package:kicca/providers/ai_service_provider.dart';
import 'package:kicca/services/hearing_service.dart';
import 'package:kicca/view/component/information_card.dart';

/// 情報一覧画面
class InformationListPage extends StatefulWidget {
  /// コンストラクタ
  const InformationListPage({super.key});

  @override
  State<InformationListPage> createState() => _InformationListPageState();
}

/// 情報一覧画面の状態
class _InformationListPageState extends State<InformationListPage> {
  /// 選択中のカテゴリ
  String? _selectedCategory;

  /// 検索クエリ
  String _searchQuery = '';

  /// ヒヤリングサービス
  late final HearingService _hearingService;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  /// サービスを初期化する
  Future<void> _initializeServices() async {
    final prefs = await SharedPreferences.getInstance();
    _hearingService = HearingService(prefs);
    await _loadData();
  }

  /// データを読み込む
  Future<void> _loadData() async {
    final hearingData = _hearingService.getHearingData();
    if (hearingData != null) {
      final aiProvider = Provider.of<AIServiceProvider>(context, listen: false);
      await aiProvider.generateInformation(hearingData);
    }
  }

  /// フィルタリングされた情報リストを取得
  List<AIInformationModel> _getFilteredInformation(
    List<AIInformationModel> informationList,
  ) {
    return informationList.where((info) {
      final matchesCategory =
          _selectedCategory == null || info.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          info.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          info.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          info.tags.any(
              (tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase()));
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('支援情報一覧'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: Consumer<AIServiceProvider>(
        builder: (context, aiProvider, child) {
          if (aiProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (aiProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    aiProvider.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadData,
                    child: const Text('再試行'),
                  ),
                ],
              ),
            );
          }

          final filteredInformation =
              _getFilteredInformation(aiProvider.informationList);

          if (filteredInformation.isEmpty) {
            return const Center(
              child: Text('表示する情報がありません'),
            );
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        hintText: '検索',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          FilterChip(
                            label: const Text('すべて'),
                            selected: _selectedCategory == null,
                            onSelected: (selected) {
                              setState(() {
                                _selectedCategory = null;
                              });
                            },
                          ),
                          const SizedBox(width: 8),
                          FilterChip(
                            label: const Text('支援制度'),
                            selected: _selectedCategory == '支援制度',
                            onSelected: (selected) {
                              setState(() {
                                _selectedCategory = '支援制度';
                              });
                            },
                          ),
                          const SizedBox(width: 8),
                          FilterChip(
                            label: const Text('ツール・サービス'),
                            selected: _selectedCategory == 'ツール・サービス',
                            onSelected: (selected) {
                              setState(() {
                                _selectedCategory = 'ツール・サービス';
                              });
                            },
                          ),
                          const SizedBox(width: 8),
                          FilterChip(
                            label: const Text('生活の知恵'),
                            selected: _selectedCategory == '生活の知恵',
                            onSelected: (selected) {
                              setState(() {
                                _selectedCategory = '生活の知恵';
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredInformation.length,
                  itemBuilder: (context, index) {
                    final info = filteredInformation[index];
                    return InformationCard(information: info);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
