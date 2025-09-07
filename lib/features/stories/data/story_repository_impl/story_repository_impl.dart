// import 'package:fpdart/fpdart.dart';
// import 'package:horizon/core/errors/failure.dart';
// import '../../domain/entities/story_entities.dart';
// import '../../domain/repository/story_repository.dart';
// import '../datasource/story_remote_data_source.dart';
//
// class StoryRepositoryImpl implements StoryRepository {
//   final StoryRemoteDataSource remoteDataSource;
//
//   StoryRepositoryImpl(this.remoteDataSource);
//
//   @override
//   Future<Either<Failure, List<Story>>> getStories() async {
//     try {
//       final stories = await remoteDataSource.getStories();
//       return right(stories);
//     } catch (e) {
//       return left(Failure(e.toString()));
//     }
//   }
// }

import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/story_entities.dart';
import '../../domain/repository/story_repository.dart';
import '../datasource/story_remote_data_source.dart';

class StoryRepositoryImpl implements StoryRepository {
  final StoryRemoteDataSource remote;

  StoryRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, List<Story>>> getStories() async {
    try {
      final stories = await remote.getStories();
      return Right(stories);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<void> markViewed(String storyId) async {
    try {
      await remote.markViewed(storyId);
    } catch (e) {
      throw Failure(e.toString());
    }
  }


  @override
  Future<void> deleteExpiredStories() async {
    try {
      await remote.deleteExpiredStories();
    } catch (e) {
      throw Failure(e.toString());
    }
  }
  @override
  Future<void> deleteStory(String storyId) async {
    try {
      await remote.deleteStory(storyId); // Call the remote datasource
    } catch (e) {
      throw Failure(e.toString());
    }
  }


  @override
  Future<Either<Failure, void>> uploadStory(
    String userId,
    String imageUrl,
  ) async {
    try {
      await remote.uploadStory(userId, imageUrl);
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
