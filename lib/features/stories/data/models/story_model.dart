

import '../../domain/entities/story_entities.dart';

class StoryModel extends Story {
  StoryModel({
    required super.id,
    required super.userId,
    required super.imageUrl,
    required super.userName,
    super.isViewed,
    required super.createdAt,

  });

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      id: json['id']?.toString() ?? '',                //  null-safe
      userId: json['user_id']?.toString() ?? '',       //  null-safe
      imageUrl: json['image_url'] ?? '',               //  default empty string
      userName: json['profiles']?['username'] ?? 'Unknown', //  safe lookup
      isViewed: json['is_viewed'] ?? false,
      //createdAt: DateTime.parse(json['created_at']),
      createdAt: DateTime.parse(json['created_at']).toUtc(),
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'imageUrl': imageUrl,
      'userName': userName,
      'isViewed': isViewed,

    };
  }

  /// ✅ copyWith method
  StoryModel copyWith({
    String? id,
    String? userId,
    String? imageUrl,
    String? userName,
    bool? isViewed,
    DateTime? createdAt,

  }) {
    return StoryModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      imageUrl: imageUrl ?? this.imageUrl,
      userName: userName ?? this.userName,
      isViewed: isViewed ?? this.isViewed,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
