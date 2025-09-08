
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/common/cubit/auth_user_cubit.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../init_dependencies_main.dart';
import '../../data/models/story_model.dart';
import '../../domain/entities/story_entities.dart';
import '../../domain/usecase/delet_expired_stories.dart';
import '../../domain/usecase/delete_story.dart';
import '../../domain/usecase/get_stories_usecase.dart';
import '../../domain/usecase/mark_viewed.dart';
import '../../domain/usecase/upload_story_usecase.dart';

part 'story_state.dart';

class StoryCubit extends Cubit<StoryState> {
  final GetStoriesUseCase getStoriesUseCase;
  final UploadStoryUseCase uploadStoryUseCase;
  final MarkStoryViewed markStoryViewedUseCase;
  final DeleteExpiredStories deleteExpiredStoriesUseCase;
  final DeleteStory deleteStoryUseCase;

  StoryCubit(
      this.getStoriesUseCase,
      this.uploadStoryUseCase,
      this.deleteExpiredStoriesUseCase,
      this.markStoryViewedUseCase,
      this.deleteStoryUseCase,) : super(StoryInitial());

  /// Upload story with optimistic UI
  Future<void> uploadStory(String userId, String userName,
      String imageUrl) async {
    // 1️⃣ Update local state immediately
    final currentStories = state is StoryLoaded
        ? List<Story>.from((state as StoryLoaded).stories)
        : <Story>[];

    final newStory = StoryModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      userName: userName,
      imageUrl: imageUrl,
      isViewed: false,
      createdAt: DateTime.now(),
    );

    final existingIndex = currentStories.indexWhere((s) => s.userId == userId);
    if (existingIndex >= 0) {
      currentStories[existingIndex] = newStory;
    } else {
      currentStories.add(newStory);
    }

    emit(StoryLoaded(currentStories));

    // 2️⃣ Persist to backend
    final result = await uploadStoryUseCase(
      UploadStoryParams(userId: userId, imageUrl: imageUrl),
    );

    result.fold(
          (failure) => emit(StoryError(failure.message)),
      // Rollback or show error
          (_) async => await fetchStories(), // Refresh stories from backend
    );
  }


  /// Fetch all stories
  Future<void> fetchStories() async {
    emit(StoryLoading());
    try {
      final result = await getStoriesUseCase();

      result.fold(
            (failure) => emit(StoryError(failure.message)),
            (stories) => emit(StoryLoaded(stories)),
      );
    } catch (e) {
      emit(StoryError("Unexpected error: $e"));
    }
  }

  /// Mark story as viewed
  Future<void> viewStory(String storyId) async {
    try {
      await markStoryViewedUseCase(MarkViewedParams(storyId: storyId));
      await fetchStories(); // Refresh after marking viewed
    } catch (e) {
      emit(StoryError("Failed to mark story viewed: $e"));
    }
  }

  /// Delete expired stories
  Future<void> removeExpiredStories() async {
    try {
      await deleteExpiredStoriesUseCase(NoParams());
      await fetchStories(); // Refresh after deletion
    } catch (e) {
      emit(StoryError("Failed to delete expired stories: $e"));
    }
  }

  Future<void> deleteStory(String storyId) async {
    try {
      // Get current user ID from AuthUserCubit
      final currentUserState = serviceLocater<AuthUserCubit>().state;
      if (currentUserState is! AuthUserLoggedIn) return; // Not logged in

      final currentUserId = currentUserState.user.id;

      // 1️⃣ Get current stories
      final currentStories = state is StoryLoaded
          ? List<Story>.from((state as StoryLoaded).stories)
          : <Story>[];

      // 2️⃣ Find story to delete
      final storyToDelete = currentStories.where((s) => s.id == storyId).toList();
      if (storyToDelete.isEmpty) return; // Story not found

      // 3️⃣ Check ownership
      if (storyToDelete.first.userId != currentUserId) return; // Not your story

      // 4️⃣ Update local state immediately (optimistic UI)
      currentStories.removeWhere((story) => story.id == storyId);
      emit(StoryLoaded(currentStories));

      // 5️⃣ Call DeleteStory UseCase to delete from backend
      final result = await deleteStoryUseCase(DeleteStoryParams(storyId: storyId));
      result.fold(
            (failure) => emit(StoryError("Failed to delete story: ${failure.message}")),
            (_) async => await fetchStories(), // Refresh after deletion
      );
    } catch (e) {
      emit(StoryError("Failed to delete story: $e"));
    }
  }



}
