//
// import 'package:image_picker/image_picker.dart';
// import '../../domain/entities/post_entity.dart';
// import '../../domain/repositories/post_repository.dart';
// import '../datasources/post_local_data_source.dart';
// import '../datasources/post_remote_data_source.dart';
// import '../models/post_model.dart';
//
// class PostRepositoryImpl implements PostRepository {
//   final PostRemoteDataSource remote;
//   final PostLocalDataSource local;
//
//   PostRepositoryImpl({required this.remote, required this.local});
//
//   @override
//   Future<List<Post>> getFeed({int limit = 20}) async {
//     final remotePosts = await remote.fetchFeed(limit: limit);
//     await local.cacheFeed(remotePosts);
//     return remotePosts;
//   }
//
//   @override
//   Future<void> likePost(String postId, String userId) => remote.likePost(postId, userId);
//
//   @override
//   Future<void> unlikePost(String postId, String userId) => remote.unlikePost(postId, userId);
//
//   @override
//   Future<void> savePost(String postId, String userId) => remote.savePost(postId, userId);
//
//   @override
//   Future<void> unsavePost(String postId, String userId) => remote.unsavePost(postId, userId);
//
//   @override
//   Future<void> addComment(String postId, String userId, String text) =>
//       remote.addComment(postId, userId, text);
//
//   @override
//   Future<Post> createPost({
//     required String userId,
//     required String caption,
//     required List<String> mediaUrls,
//     required String type,
//   }) async {
//     // ✅ convert URLs into dummy XFiles or adjust remote to accept both
//     final pm = await remote.createPost(
//       userId: userId,
//       caption: caption,
//       files: [], // leave empty if only URLs provided
//       type: type,
//     );
//
//     await local.savePostLocally(pm);
//     return pm;
//   }
//
//   @override
//   List<Post> getCachedFeed() => local.getCachedFeed();
// }
// lib/features/feed/data/repositories/post_repository_impl.dart
import '../../domain/entities/post_entity.dart';
import '../../domain/repositories/post_repository.dart';
import '../datasources/post_local_data_source.dart';
import '../datasources/post_remote_data_source.dart';
import '../models/comment.dart';
import '../models/post_model.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remote;
  final PostLocalDataSource local;

  PostRepositoryImpl({required this.remote, required this.local});

  @override
  Future<List<Post>> getFeed({int limit = 20}) async {
    final remotePosts = await remote.fetchFeed(limit: limit);
    await local.cacheFeed(remotePosts);
    return remotePosts;
  }

  @override
  Future<void> likePost(String postId, String userId) => remote.likePost(postId, userId);

  @override
  Future<void> unlikePost(String postId, String userId) => remote.unlikePost(postId, userId);

  @override
  Future<void> savePost(String postId, String userId) => remote.savePost(postId, userId);

  @override
  Future<void> unsavePost(String postId, String userId) => remote.unsavePost(postId, userId);

  @override
  Future<void> addComment(String postId, String userId, String text) =>
      remote.addComment(postId, userId, text);

  @override
  Future<void> deletePost(String postId) async {
    // 1. Delete from server
    await remote.deletePost(postId);

    // 2. Delete locally
    await local.deletePostLocally(postId);
  }

  @override
  Future<Post> createPost({
    required String userId,
    required String caption,
    required List<String> mediaUrls,
    required String type,
  }) async {
    final pm = await remote.createPost(
      userId: userId,
      caption: caption,
      mediaUrls: mediaUrls,
      type: type,
    );

    await local.savePostLocally(pm);
    return pm;
  }

  @override
  List<Post> getCachedFeed() => local.getCachedFeed();
}
