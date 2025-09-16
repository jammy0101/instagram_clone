import '../repositories/post_repository.dart';

class AddComment {
  final PostRepository repository;
  AddComment(this.repository);

  Future<void> call(String postId, String userId, String text) => repository.addComment(postId, userId, text);
}
