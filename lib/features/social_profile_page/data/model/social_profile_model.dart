

import '../../domain/entity/socila_profile_entity.dart';

class SocialProfileModel extends SocialProfileEntity {
  const SocialProfileModel({
    required super.username,
    required super.bio,
    required super.profileImage,
    required super.posts,
    required super.followers,
    required super.following,
    required super.highlights,
    required super.postsImages,
  });

  factory SocialProfileModel.fromMap(Map<String, dynamic> m) {
    return SocialProfileModel(
      username: m['username'] ?? '',
      bio: m['bio'] ?? '',
      profileImage: m['profileImage'] ?? '',
      posts: (m['posts'] ?? 0) as int,
      followers: (m['followers'] ?? 0) as int,
      following: (m['following'] ?? 0) as int,
      highlights: List<String>.from(m['highlights'] ?? []),
      postsImages: List<String>.from(m['postsImages'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'bio': bio,
      'profileImage': profileImage,
      'posts': posts,
      'followers': followers,
      'following': following,
      'highlights': highlights,
      'postsImages': postsImages,
    };
  }
}
