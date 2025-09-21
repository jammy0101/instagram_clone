// import '../entities/post_entity.dart';
//
// abstract class PostRepository {
//   Future<List<Post>> getFeed({int limit = 20});
//
//   Future<Post> createPost({
//     required String userId,
//     required String caption,
//     required List<String> mediaUrls,
//     required String type,
//   });
//
//   Future<void> likePost(String postId, String userId);
//   Future<void> unlikePost(String postId, String userId);
//   Future<void> savePost(String postId, String userId);
//   Future<void> unsavePost(String postId, String userId);
//   Future<void> addComment(String postId, String userId, String text);
//
//   List<Post> getCachedFeed();
// }
// lib/features/feed/domain/repositories/post_repository.dart
import '../../data/models/comment.dart';
import '../entities/post_entity.dart';

abstract class PostRepository {
  Future<List<Post>> getFeed({int limit = 20});
  Future<void> likePost(String postId, String userId);
  Future<void> unlikePost(String postId, String userId);
  Future<void> savePost(String postId, String userId);
  Future<void> unsavePost(String postId, String userId);
  Future<void> addComment(String postId, String userId, String text);
  Future<void> deletePost(String postId);

  /// Domain-level create accepts media URLs (strings).
  Future<Post> createPost({
    required String userId,
    required String caption,
    required List<String> mediaUrls,
    required String type,
  });

  List<Post> getCachedFeed();
}
