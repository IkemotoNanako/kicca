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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('支援情報一覧'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              try {
                await _loadData();
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('データの読み込みに失敗しました: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            tooltip: 'データを再読み込み',
          ),
        ],
      ),
      body: Consumer<AIServiceProvider>(
        builder: (context, aiProvider, child) {
          if (aiProvider.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    semanticsLabel: 'データを読み込んでいます',
                  ),
                  SizedBox(height: 16),
                  Text('データを読み込んでいます...'),
                ],
              ),
            );
          }

          if (aiProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 48,
                    semanticLabel: 'エラー',
                  ),
                  const SizedBox(height: 16),
                  Text(
                    aiProvider.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () async {
                      try {
                        await _loadData();
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('データの読み込みに失敗しました: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('再試行'),
                  ),
                ],
              ),
            );
          }

          final filteredInformation =
              _getFilteredInformation(aiProvider.informationList);

          if (filteredInformation.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Colors.blue,
                    size: 48,
                    semanticLabel: '情報',
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '表示する情報がありません',
                    style: TextStyle(fontSize: 16),
                  ),
                  if (_selectedCategory != null || _searchQuery.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    const Text(
                      '検索条件を変更してみてください',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ],
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Semantics(
                        label: '情報を検索',
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: '検索',
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Semantics(
                        label: 'カテゴリフィルター',
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Tooltip(
                                message: 'すべてのカテゴリを表示',
                                child: FilterChip(
                                  label: const Text('すべて'),
                                  selected: _selectedCategory == null,
                                  onSelected: (selected) {
                                    setState(() {
                                      _selectedCategory = null;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Tooltip(
                                message: '支援制度のみ表示',
                                child: FilterChip(
                                  label: const Text('支援制度'),
                                  selected: _selectedCategory == '支援制度',
                                  onSelected: (selected) {
                                    setState(() {
                                      _selectedCategory =
                                          selected ? '支援制度' : null;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Tooltip(
                                message: 'ツール・サービスのみ表示',
                                child: FilterChip(
                                  label: const Text('ツール・サービス'),
                                  selected: _selectedCategory == 'ツール・サービス',
                                  onSelected: (selected) {
                                    setState(() {
                                      _selectedCategory =
                                          selected ? 'ツール・サービス' : null;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Tooltip(
                                message: '生活の知恵のみ表示',
                                child: FilterChip(
                                  label: const Text('生活の知恵'),
                                  selected: _selectedCategory == '生活の知恵',
                                  onSelected: (selected) {
                                    setState(() {
                                      _selectedCategory =
                                          selected ? '生活の知恵' : null;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final info = filteredInformation[index];
                    return Semantics(
                      label: '${info.title}の情報カード',
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: InformationCard(
                          key: ValueKey(info.createdAt.toString()),
                          information: info,
                        ),
                      ),
                    );
                  },
                  childCount: filteredInformation.length,
                ),
              ),
            ],
          );
        },
      ),
    );
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
}
