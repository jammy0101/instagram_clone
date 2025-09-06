import 'package:fpdart/fpdart.dart';
import 'package:horizon/core/errors/failure.dart';
import '../entities/story_entities.dart';
import '../repository/story_repository.dart';

class GetStoriesUseCase {
  final StoryRepository repository;

  GetStoriesUseCase(this.repository);

  Future<Either<Failure, List<Story>>> call() {
    return repository.getStories(); // repository should already return Future<Either<Failure, List<Story>>>
  }
}
