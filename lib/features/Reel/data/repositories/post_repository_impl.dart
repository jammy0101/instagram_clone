import '../../domain/entities/post_entity.dart';
import '../../domain/repositories/post_repository.dart';
import '../datasources/post_local_data_source.dart';
import '../datasources/post_remote_data_source.dart';
import '../models/post_model.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remote;
  final PostLocalDataSource local;

  PostRepositoryImpl({required this.remote, required this.local});

  @override
  Future<List<Post>> getFeed({int limit = 20}) async {
    final remotePosts = await remote.fetchFeed(limit: limit);
    // cache locally
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
  Future<void> addComment(String postId, String userId, String text) => remote.addComment(postId, userId, text);

  @override
  Future<Post> createPost({
    required String userId,
    required String caption,
    required List<String> mediaUrls,
    required String type,
  }) async {
    final pm = await remote.createPost({
      'user_id': userId,
      'caption': caption,
      'media_urls': mediaUrls,
      'type': type,
    });

    await local.savePostLocally(pm);
    return pm;
  }

  @override
  List<Post> getCachedFeed() => local.getCachedFeed();
}
