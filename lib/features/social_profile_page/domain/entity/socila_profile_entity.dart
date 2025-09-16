class SocialProfileEntity {
  final String username;
  final String bio;
  final String profileImage;
  final int posts;
  final int followers;
  final int following;
  final List<String> highlights;
  final List<String> postsImages;

  const SocialProfileEntity({
    required this.username,
    required this.bio,
    required this.profileImage,
    required this.posts,
    required this.followers,
    required this.following,
    required this.highlights,
    required this.postsImages,
  });
}
