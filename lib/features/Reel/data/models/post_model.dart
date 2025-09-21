// lib/features/feed/data/models/post_model.dart
import 'package:hive/hive.dart';
import '../../domain/entities/post_entity.dart';

part 'post_model.g.dart';


// @HiveType(typeId: 2)
// class PostModel extends Post {
//   @HiveField(0)
//   final String idHive;
//
//   @HiveField(8)
//   final String? usernameHive;
//
//   @HiveField(9)
//   final String? userAvatarUrlHive;
//
//   PostModel({
//     required String id,
//     required String userId,
//     required String mediaUrl,
//     required bool isVideo,
//     required String content,
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
//         usernameHive = username,
//         userAvatarUrlHive = userAvatarUrl,
//         super(
//         id: id,
//         userId: userId,
//         mediaUrl: mediaUrl,
//         isVideo: isVideo,
//         content: content,
//         likesCount: likesCount,
//         commentsCount: commentsCount,
//         createdAt: createdAt,
//         caption: caption,
//         mediaUrls: mediaUrls,
//         type: type,
//         isSaved: isSaved,
//         isLiked: isLiked,
//         username: username,
//         userAvatarUrl: userAvatarUrl,
//       );
//
//   factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
//     id: json['id'] as String,
//     userId: json['user_id'] as String,
//     mediaUrl: json['media_url'] as String? ?? '',
//     isVideo: json['is_video'] as bool? ?? false,
//     content: json['content'] as String? ?? '',
//     caption: json['caption'] as String? ?? '',
//     mediaUrls: (json['media_urls'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
//     type: json['type'] as String? ?? 'image',
//     likesCount: (json['likes_count'] as int?) ?? 0,
//     commentsCount: (json['comments_count'] as int?) ?? 0,
//     createdAt: DateTime.parse(json['created_at'] as String),
//     username: json['username'] as String?,
//     userAvatarUrl: json['avatar_url'] as String?,
//     isSaved: json['is_saved'] as bool? ?? false,
//     isLiked: json['is_liked'] as bool? ?? false,
//   );
//
//   @override
//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'user_id': userId,
//     'media_url': mediaUrl,
//     'is_video': isVideo,
//     'content': content,
//     'caption': caption,
//     'media_urls': mediaUrls,
//     'type': type,
//     'likes_count': likesCount,
//     'comments_count': commentsCount,
//     'created_at': createdAt.toIso8601String(),
//     'username': usernameHive,
//     'avatar_url': userAvatarUrlHive,
//     'is_saved': isSaved,
//     'is_liked': isLiked,
//   };
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

  /// ✅ Parse JSON safely
  factory PostModel.fromJson(Map<String, dynamic> json) {
    final singleUrl = json['media_url'] as String?;
    final listUrls = (json['media_urls'] as List?)
        ?.map((e) => e.toString())
        .toList() ??
        [];

    // Normalize: ensure at least one URL
    final normalizedUrls = listUrls.isNotEmpty
        ? listUrls
        : (singleUrl != null && singleUrl.isNotEmpty ? [singleUrl] : []);

    return PostModel(
      id: json['id'].toString(),
      userId: json['user_id'] as String? ?? '',
      mediaUrl: singleUrl ?? (normalizedUrls.isNotEmpty ? normalizedUrls.first : ''),
      isVideo: json['is_video'] as bool? ?? false,
      content: json['content'] as String? ?? '',
      caption: json['caption'] as String? ?? '',
      mediaUrls: normalizedUrls.cast<String>(), // ✅ always List<String>
      type: json['type'] as String? ?? 'image',
      likesCount: (json['likes_count'] as int?) ?? 0,
      commentsCount: (json['comments_count'] as int?) ?? 0,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      username: json['username'] as String?,
      userAvatarUrl: json['avatar_url'] as String?,
      isSaved: json['is_saved'] as bool? ?? false,
      isLiked: json['is_liked'] as bool? ?? false,
    );
  }

  /// ✅ Ensure mediaUrls is saved as List<String>
  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'media_url': mediaUrl,
    'is_video': isVideo,
    'content': content,
    'caption': caption,
    'media_urls': mediaUrls.map((e) => e.toString()).toList(), // ✅ Fix here
    'type': type,
    'likes_count': likesCount,
    'comments_count': commentsCount,
    'created_at': createdAt.toIso8601String(),
    'username': usernameHive ?? username,
    'avatar_url': userAvatarUrlHive ?? userAvatarUrl,
    'is_saved': isSaved,
    'is_liked': isLiked,
  };
}

