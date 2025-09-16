import '../repositories/post_repository.dart';

class SavePost {
  final PostRepository repository;
  SavePost(this.repository);

  Future<void> call(String postId, String userId) => repository.savePost(postId, userId);
}
