import 'package:flutter/material.dart';

/// AIによる提案を定義するモデルクラス
class AISuggestionModel {
  /// 提案のタイトル
  final String title;

  /// 提案の説明
  final String description;

  /// 提案の優先度（1-5）
  final int priority;

  /// 提案のカテゴリ
  final String category;

  /// 提案のタグ
  final List<String> tags;

  /// 提案の出典
  final String source;

  /// 提案の作成日時
  final DateTime createdAt;

  /// コンストラクタ
  AISuggestionModel({
    required this.title,
    required this.description,
    required this.priority,
    required this.category,
    required this.tags,
    required this.source,
    required this.createdAt,
  }) : assert(priority >= 1 && priority <= 5);

  /// 優先度に応じた色を取得する
  Color getPriorityColor() {
    switch (priority) {
      case 5:
        return Colors.red;
      case 4:
        return Colors.orange;
      case 3:
        return Colors.yellow;
      case 2:
        return Colors.blue;
      case 1:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
