import '../repositories/post_repository.dart';

class UnsavePost {
  final PostRepository repository;
  UnsavePost(this.repository);

  Future<void> call(String postId, String userId) => repository.unsavePost(postId, userId);
}
