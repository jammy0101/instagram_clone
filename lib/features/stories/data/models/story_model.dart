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
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      imageUrl: json['image_url'] ?? '',
      // ✅ use user_name instead of username
      userName: json['profiles']?['user_name'] ?? 'Unknown',
      isViewed: json['is_viewed'] ?? false,
      createdAt: DateTime.parse(json['created_at']).toUtc(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'image_url': imageUrl,
      'user_name': userName,
      'is_viewed': isViewed,
      'created_at': createdAt.toIso8601String(),
    };
  }

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
