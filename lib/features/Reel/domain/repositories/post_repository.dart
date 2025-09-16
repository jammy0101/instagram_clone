import '../entities/post_entity.dart';

abstract class PostRepository {
  Future<List<Post>> getFeed({int limit = 20});

  Future<Post> createPost({
    required String userId,
    required String caption,
    required List<String> mediaUrls,
    required String type,
  });

  Future<void> likePost(String postId, String userId);
  Future<void> unlikePost(String postId, String userId);
  Future<void> savePost(String postId, String userId);
  Future<void> unsavePost(String postId, String userId);
  Future<void> addComment(String postId, String userId, String text);

  List<Post> getCachedFeed();
}
