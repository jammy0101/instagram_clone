// get_feed.dart
import '../entities/post_entity.dart';
import '../repositories/post_repository.dart';


class GetFeed {
  final PostRepository repository;
  GetFeed(this.repository);

  Future<List<Post>> call({int limit = 10}) => repository.getFeed(limit: limit);
}
