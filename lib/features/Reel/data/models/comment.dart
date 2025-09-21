// class Comment {
//   final String id;
//   final String postId;
//   final String userId;
//   final String username;
//   final String userAvatarUrl;
//   final String text;
//   final DateTime createdAt;
//   final List<Comment> replies;
//
//   Comment({
//     required this.id,
//     required this.postId,
//     required this.userId,
//     required this.username,
//     required this.userAvatarUrl,
//     required this.text,
//     required this.createdAt,
//     this.replies = const [],
//   });
//
//   Comment copyWith({List<Comment>? replies, String? text}) {
//     return Comment(
//       id: id,
//       postId: postId,
//       userId: userId,
//       username: username,
//       userAvatarUrl: userAvatarUrl,
//       text: text ?? this.text,
//       createdAt: createdAt,
//       replies: replies ?? this.replies,
//     );
//   }
//
//   factory Comment.fromMap(Map<String, dynamic> map) {
//     return Comment(
//       id: map['id'],
//       postId: map['post_id'],
//       userId: map['user_id'],
//       username: map['username'],
//       userAvatarUrl: map['user_avatar_url'] ?? '',
//       text: map['text'],
//       createdAt: DateTime.parse(map['created_at']),
//       replies: [],
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'post_id': postId,
//       'user_id': userId,
//       'username': username,
//       'user_avatar_url': userAvatarUrl,
//       'text': text,
//       'created_at': createdAt.toIso8601String(),
//     };
//   }
// }
class Comment {
  final String id;
  final String postId;
  final String userId;
  final String username;
  final String userAvatarUrl;
  final DateTime createdAt;
  final String? parentId;
  final List<Comment> replies;
   String text;

  Comment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.username,
    required this.userAvatarUrl,
    required this.createdAt,
    this.parentId,
    this.replies = const [],
    required this.text,
  });

  Comment copyWith({
    String? id,
    String? postId,
    String? userId,
    String? username,
    String? userAvatarUrl,
    DateTime? createdAt,
    String? parentId,
    List<Comment>? replies,
    String? text,
  }) {
    return Comment(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      userAvatarUrl: userAvatarUrl ?? this.userAvatarUrl,
      createdAt: createdAt ?? this.createdAt,
      parentId: parentId ?? this.parentId,
      replies: replies ?? this.replies,
      text: text ?? this.text,
    );
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'],
      postId: map['post_id'],
      userId: map['user_id'],
      username: map['username'],
      userAvatarUrl: map['user_avatar_url'] ?? '',
      createdAt: DateTime.parse(map['created_at']),
      parentId: map['parent_id'],
      text: map['text'],
      replies: [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'post_id': postId,
      'user_id': userId,
      'username': username,
      'user_avatar_url': userAvatarUrl,
      'created_at': createdAt.toIso8601String(),
      'parent_id': parentId,
      'text': text,
    };
  }
}
