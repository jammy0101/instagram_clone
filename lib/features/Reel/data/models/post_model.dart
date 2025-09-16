// lib/features/feed/data/models/post_model.dart
import 'package:hive/hive.dart';
import '../../domain/entities/post_entity.dart';

part 'post_model.g.dart';
//
// @HiveType(typeId: 2)
// class PostModel extends Post {
//   @HiveField(0)
//   final String idHive;
//
//    PostModel({
//     required String id,
//     required String userId,
//     required String caption,
//     required List<String> mediaUrls,
//     required String type,
//     required int likesCount,
//     required int commentsCount,
//     required DateTime createdAt,
//     String? username,
//     String? userAvatarUrl,
//     bool isSaved = false,
//     bool isLiked = false,
//   })  : idHive = id,
//         super(
//         id: id,
//         userId: userId,
//         caption: caption,
//         mediaUrls: mediaUrls,
//         type: type,
//         likesCount: likesCount,
//         commentsCount: commentsCount,
//         createdAt: createdAt,
//         username: username,
//         userAvatarUrl: userAvatarUrl,
//         isSaved: isSaved,
//         isLiked: isLiked,
//       );
//
//   factory PostModel.fromJson(Map<String, dynamic> json) {
//     return PostModel(
//       id: json['id'] as String,
//       userId: json['user_id'] as String,
//       caption: json['caption'] as String? ?? '',
//       mediaUrls: (json['media_urls'] is List) ? List<String>.from(json['media_urls']) : (json['media_urls'] as List<dynamic>).map((e)=>e as String).toList(),
//       type: (json['type'] as String?) ?? 'image',
//       likesCount: (json['likes_count'] as int?) ?? (json['likes_count'] is String ? int.parse(json['likes_count']) : 0),
//       commentsCount: (json['comments_count'] as int?) ?? 0,
//       createdAt: DateTime.parse(json['created_at'] as String),
//       username: json['username'] as String?,
//       userAvatarUrl: json['avatar_url'] as String?,
//     );
//   }
//
//   @override
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'user_id': userId,
//       'caption': caption,
//       'media_urls': mediaUrls,
//       'type': type,
//       'likes_count': likesCount,
//       'comments_count': commentsCount,
//       'created_at': createdAt.toIso8601String(),
//       'username': username,
//       'avatar_url': userAvatarUrl,
//     };
//   }
// }

@HiveType(typeId: 2)
class PostModel extends Post {
  @HiveField(0)
  final String idHive;

  @HiveField(8)
  final String? usernameHive;

  @HiveField(9)
  final String? userAvatarUrlHive;

  PostModel({
    required String id,
    required String userId,
    required String mediaUrl,
    required bool isVideo,
    required String content,
    required String caption,
    required List<String> mediaUrls,
    required String type,
    required int likesCount,
    required int commentsCount,
    required DateTime createdAt,
    String? username,
    String? userAvatarUrl,
    bool isSaved = false,
    bool isLiked = false,
  })  : idHive = id,
        usernameHive = username,
        userAvatarUrlHive = userAvatarUrl,
        super(
        id: id,
        userId: userId,
        mediaUrl: mediaUrl,
        isVideo: isVideo,
        content: content,
        likesCount: likesCount,
        commentsCount: commentsCount,
        createdAt: createdAt,
        caption: caption,
        mediaUrls: mediaUrls,
        type: type,
        isSaved: isSaved,
        isLiked: isLiked,
        username: username,
        userAvatarUrl: userAvatarUrl,
      );

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
    id: json['id'] as String,
    userId: json['user_id'] as String,
    mediaUrl: json['media_url'] as String? ?? '',
    isVideo: json['is_video'] as bool? ?? false,
    content: json['content'] as String? ?? '',
    caption: json['caption'] as String? ?? '',
    mediaUrls: (json['media_urls'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    type: json['type'] as String? ?? 'image',
    likesCount: (json['likes_count'] as int?) ?? 0,
    commentsCount: (json['comments_count'] as int?) ?? 0,
    createdAt: DateTime.parse(json['created_at'] as String),
    username: json['username'] as String?,
    userAvatarUrl: json['avatar_url'] as String?,
    isSaved: json['is_saved'] as bool? ?? false,
    isLiked: json['is_liked'] as bool? ?? false,
  );

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'media_url': mediaUrl,
    'is_video': isVideo,
    'content': content,
    'caption': caption,
    'media_urls': mediaUrls,
    'type': type,
    'likes_count': likesCount,
    'comments_count': commentsCount,
    'created_at': createdAt.toIso8601String(),
    'username': usernameHive,
    'avatar_url': userAvatarUrlHive,
    'is_saved': isSaved,
    'is_liked': isLiked,
  };
}
