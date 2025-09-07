import 'package:fpdart/fpdart.dart';
import 'package:horizon/core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repository/story_repository.dart';

/// UseCase to delete a single story by ID
class DeleteStory implements UseCase<void, DeleteStoryParams> {
  final StoryRepository repository;

  DeleteStory({required this.repository});

  @override
  Future<Either<Failure, void>> call(DeleteStoryParams params) async {
    try {
      // Call repository method to delete the story
      await repository.deleteStory(params.storyId);
      return const Right(null); // Success
    } catch (e) {
      return Left(Failure(e.toString())); // Wrap exception in Left
    }
  }
}

/// Parameters for DeleteStory UseCase
class DeleteStoryParams {
  final String storyId;

  DeleteStoryParams({required this.storyId});
}
