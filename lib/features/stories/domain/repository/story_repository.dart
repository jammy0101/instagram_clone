

import 'package:fpdart/fpdart.dart';
import 'package:horizon/core/errors/failure.dart';
import 'package:horizon/features/stories/domain/entities/story_entities.dart';

abstract interface class StoryRepository{

  Future<Either<Failure,List<Story>>> getStories();
  Future<Either<Failure, void>> uploadStory(String userId, String imageUrl);
  Future<void> markViewed(String storyId);
  Future<void> deleteExpiredStories();
  Future<void> deleteStory(String storyId);
}