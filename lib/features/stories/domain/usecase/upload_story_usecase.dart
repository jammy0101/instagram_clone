import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repository/story_repository.dart';

class UploadStoryUseCase implements UseCase<void, UploadStoryParams> {
  final StoryRepository repository;

  UploadStoryUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(UploadStoryParams params) async {
    try {
      return await repository.uploadStory(params.userId, params.imageUrl);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}

class UploadStoryParams {
  final String userId;
  final String imageUrl;

  UploadStoryParams({
    required this.userId,
    required this.imageUrl,
  });
}
