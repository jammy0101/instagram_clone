import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecasek.dart';
import '../repository/story_repository.dart';

class MarkStoryViewed implements UseCaseK<void, MarkViewedParams> {
  final StoryRepository repository;

  MarkStoryViewed(this.repository);

  @override
  Future<Either<Failure, void>> call(MarkViewedParams params) async {
    try {
      await repository.markViewed(params.storyId);
      return const Right(null); // Success
    } catch (e) {
      return Left(Failure(e.toString())); // Failure
    }
  }
}

class MarkViewedParams {
  final String storyId;

  MarkViewedParams({required this.storyId});
}
