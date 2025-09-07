class Story {
  final String id;
  final String userId;
  final String imageUrl;
  final String userName;
  final bool isViewed;
  final DateTime createdAt;


  Story({
    required this.id,
    required this.userId,
    required this.imageUrl,
    required this.userName,
    this.isViewed = false,
    required this.createdAt,
  });
}
