import '../repositories/post_repository.dart';

class DeletePost {
  final PostRepository repository;

  DeletePost(this.repository);

  Future<void> call(String postId, String userId) async {
    await repository.deletePost(postId);
  }
}
