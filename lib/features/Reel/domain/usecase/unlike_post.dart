import '../repositories/post_repository.dart';

class UnlikePost {
  final PostRepository repository;
  UnlikePost(this.repository);

  Future<void> call(String postId, String userId) => repository.unlikePost(postId, userId);
}
