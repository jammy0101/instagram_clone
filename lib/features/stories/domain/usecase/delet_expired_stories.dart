import 'package:fpdart/fpdart.dart';
import 'package:horizon/core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repository/story_repository.dart';

class DeleteExpiredStories implements UseCase<void, NoParams> {
  final StoryRepository repository;

  DeleteExpiredStories({required this.repository});

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    try {
      await repository.deleteExpiredStories(); // your repo returns Future<void>
      return const Right(null); //  Wrap void result in Right
    } catch (e) {
      return Left(Failure( e.toString())); //  Wrap exception in Left
    }
  }
}
