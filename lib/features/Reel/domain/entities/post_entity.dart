// // lib/features/feed/domain/entities/post_entity.dart
// import 'package:meta/meta.dart';
//
// @immutable
// class Post {
//   final String id;
//   final String userId;
//   final String caption;
//   final List<String> mediaUrls; // full URLs (images or video urls)
//   final String type; // 'image' | 'video'
//   final int likesCount;
//   final int commentsCount;
//   final DateTime createdAt;
//   final String? username;
//   final String? userAvatarUrl;
//   final bool isSaved; // local flag
//   final bool isLiked; // local flag by current user
//
//   const Post({
//     required this.id,
//     required this.userId,
//     required this.caption,
//     required this.mediaUrls,
//     required this.type,
//     required this.likesCount,
//     required this.commentsCount,
//     required this.createdAt,
//     this.username,
//     this.userAvatarUrl,
//     this.isSaved = false,
//     this.isLiked = false,
//   });
//
//   Post copyWith({
//     String? id,
//     String? userId,
//     String? caption,
//     List<String>? mediaUrls,
//     String? type,
//     int? likesCount,
//     int? commentsCount,
//     DateTime? createdAt,
//     String? username,
//     String? userAvatarUrl,
//     bool? isSaved,
//     bool? isLiked,
//   }) {
//     return Post(
//       id: id ?? this.id,
//       userId: userId ?? this.userId,
//       caption: caption ?? this.caption,
//       mediaUrls: mediaUrls ?? this.mediaUrls,
//       type: type ?? this.type,
//       likesCount: likesCount ?? this.likesCount,
//       commentsCount: commentsCount ?? this.commentsCount,
//       createdAt: createdAt ?? this.createdAt,
//       username: username ?? this.username,
//       userAvatarUrl: userAvatarUrl ?? this.userAvatarUrl,
//       isSaved: isSaved ?? this.isSaved,
//       isLiked: isLiked ?? this.isLiked,
//     );
//   }
// }
// lib/features/feed/domain/entities/post_entity.dart
import 'package:meta/meta.dart';

@immutable
class Post {
  final String id;
  final String userId;
  final String mediaUrl;
  final bool isVideo;
  final String content;
  final int likesCount;
  final int commentsCount;
  final bool isLiked;
  final bool isSaved;
  final DateTime createdAt;
  final String caption;
  final List<String> mediaUrls;
  final String type;

  // NEW FIELDS
  final String? username;
  final String? userAvatarUrl;

  const Post({
    required this.id,
    required this.userId,
    required this.mediaUrl,
    required this.isVideo,
    required this.content,
    required this.likesCount,
    required this.commentsCount,
    required this.isLiked,
    required this.isSaved,
    required this.createdAt,
    required this.caption,
    required this.mediaUrls,
    required this.type,
    this.username,
    this.userAvatarUrl,
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
    id: json['id'] as String,
    userId: json['user_id'] as String,
    mediaUrl: json['media_url'] as String? ?? '',
    isVideo: json['is_video'] as bool? ?? false,
    content: json['content'] as String? ?? '',
    likesCount: json['likes_count'] as int? ?? 0,
    commentsCount: json['comments_count'] as int? ?? 0,
    isLiked: json['is_liked'] as bool? ?? false,
    isSaved: json['is_saved'] as bool? ?? false,
    createdAt: DateTime.parse(json['created_at'] as String),
    caption: json['caption'] as String? ?? '',
    mediaUrls: (json['media_urls'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList() ??
        [],
    type: json['type'] as String? ?? 'image',
    username: json['username'] as String?,
    userAvatarUrl: json['avatar_url'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'media_url': mediaUrl,
    'is_video': isVideo,
    'content': content,
    'likes_count': likesCount,
    'comments_count': commentsCount,
    'is_liked': isLiked,
    'is_saved': isSaved,
    'created_at': createdAt.toIso8601String(),
    'caption': caption,
    'media_urls': mediaUrls,
    'type': type,
    'username': username,
    'avatar_url': userAvatarUrl,
  };

  Post copyWith({
    String? id,
    String? userId,
    String? mediaUrl,
    bool? isVideo,
    String? content,
    int? likesCount,
    int? commentsCount,
    bool? isLiked,
    bool? isSaved,
    DateTime? createdAt,
    String? caption,
    List<String>? mediaUrls,
    String? type,
    String? username,
    String? userAvatarUrl,
  }) =>
      Post(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        mediaUrl: mediaUrl ?? this.mediaUrl,
        isVideo: isVideo ?? this.isVideo,
        content: content ?? this.content,
        likesCount: likesCount ?? this.likesCount,
        commentsCount: commentsCount ?? this.commentsCount,
        isLiked: isLiked ?? this.isLiked,
        isSaved: isSaved ?? this.isSaved,
        createdAt: createdAt ?? this.createdAt,
        caption: caption ?? this.caption,
        mediaUrls: mediaUrls ?? this.mediaUrls,
        type: type ?? this.type,
        username: username ?? this.username,
        userAvatarUrl: userAvatarUrl ?? this.userAvatarUrl,
      );
}
