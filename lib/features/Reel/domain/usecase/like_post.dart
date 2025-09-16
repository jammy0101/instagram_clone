import '../repositories/post_repository.dart';

class LikePost {
  final PostRepository repository;
  LikePost(this.repository);

  Future<void> call(String postId, String userId) => repository.likePost(postId, userId);
}