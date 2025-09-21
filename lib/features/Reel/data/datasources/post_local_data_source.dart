
import 'package:hive/hive.dart';
import '../models/post_model.dart';

abstract class PostLocalDataSource {
  Future<void> cacheFeed(List<PostModel> posts);
  List<PostModel> getCachedFeed();
  Future<void> savePostLocally(PostModel post);
  Future<void> deletePostLocally(String postId);
}

class PostLocalDataSourceImpl implements PostLocalDataSource {
  final Box<PostModel> feedBox;
  PostLocalDataSourceImpl(this.feedBox);

  @override
  Future<void> cacheFeed(List<PostModel> posts) async {
    final Map<String, PostModel> map = {for (var p in posts) p.id: p};
    await feedBox.putAll(map);
  }

  @override
  List<PostModel> getCachedFeed() {
    final list = feedBox.values.toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  @override
  Future<void> savePostLocally(PostModel post) async {
    await feedBox.put(post.id, post);
  }

  @override
  Future<void> deletePostLocally(String postId) async {
    await feedBox.delete(postId);
  }
}
