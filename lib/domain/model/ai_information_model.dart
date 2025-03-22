import 'dart:convert';

/// AIによる情報収集・提供のモデル
class AIInformationModel {
  /// 情報のタイトル
  final String title;

  /// 説明
  final String description;

  /// カテゴリ
  final String category;

  /// 優先度（0-100）
  final int priority;

  /// タグ
  final List<String> tags;

  /// 情報源
  final String source;

  /// 作成日時
  final DateTime createdAt;

  /// コンストラクタ
  AIInformationModel({
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.tags,
    required this.source,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// JSONからモデルを作成
  factory AIInformationModel.fromJson(Map<String, dynamic> json) {
    return AIInformationModel(
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      priority: json['priority'] as int,
      tags: List<String>.from(json['tags'] as List),
      source: json['source'] as String,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  /// モデルをJSONに変換
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'priority': priority,
      'tags': tags,
      'source': source,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// モデルをコピー
  AIInformationModel copyWith({
    String? title,
    String? description,
    String? category,
    int? priority,
    List<String>? tags,
    String? source,
    DateTime? createdAt,
  }) {
    return AIInformationModel(
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      tags: tags ?? this.tags,
      source: source ?? this.source,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
