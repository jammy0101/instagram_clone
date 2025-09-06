// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../../core/usecase/usecase.dart';
// import '../../data/models/story_model.dart';
// import '../../domain/entities/story_entities.dart';
// import '../../domain/usecase/delet_expired_stories.dart';
// import '../../domain/usecase/get_stories_usecase.dart';
// import '../../domain/usecase/mark_viewed.dart';
// import '../../domain/usecase/upload_story_usecase.dart';
//
// part 'story_state.dart';
//
// class StoryCubit extends Cubit<StoryState> {
//   final GetStoriesUseCase getStoriesUseCase;
//   final UploadStoryUseCase uploadStoryUseCase;
//   final MarkStoryViewed markStoryViewedUseCase;
//   final DeleteExpiredStories deleteExpiredStoriesUseCase;
//
//   StoryCubit(
//     this.getStoriesUseCase,
//     this.uploadStoryUseCase,
//     this.deleteExpiredStoriesUseCase,
//     this.markStoryViewedUseCase,
//   ) : super(StoryInitial());
//
//   // // Future<void> uploadStory(String userId, String imageUrl) async {
//   // //   emit(StoryLoading());
//   // //   final result = await uploadStoryUseCase(userId, imageUrl);
//   // //   result.fold(
//   // //         (failure) => emit(StoryError(failure.message)),
//   // //         (_) async {
//   // //       // refresh stories after uploading
//   // //       await fetchStories();
//   // //     },
//   // //   );
//   // // }
//   // Future<void> uploadStory(String userId, String imageUrl) async {
//   //   emit(StoryLoading());
//   //   final result = await  uploadStoryUseCase(userId, imageUrl);
//   //
//   //   result.fold(
//   //         (failure) => emit(StoryError(failure.message)),
//   //         (_) async => await fetchStories(),
//   //   );
//   // }
//
//   // Future<void> uploadStory(String userId, String imageUrl) async {
//   //   if (state is! StoryLoaded) return; // Only update if stories are loaded
//   //
//   //   final currentStories = List<Story>.from((state as StoryLoaded).stories);
//   //
//   //   final newStory = StoryModel(
//   //     id: DateTime.now().millisecondsSinceEpoch.toString(),
//   //     userId: userId,
//   //     userName: "User",
//   //     imageUrl: imageUrl,
//   //     isViewed: false,
//   //     createdAt: DateTime.now(),
//   //   );
//   //
//   //   final existingIndex = currentStories.indexWhere((s) => s.userId == userId);
//   //
//   //   if (existingIndex >= 0) {
//   //     currentStories[existingIndex] = newStory;
//   //   } else {
//   //     currentStories.add(newStory);
//   //   }
//   //
//   //   emit(StoryLoaded(currentStories));
//   // }
//   Future<void> uploadStory(String userId, String userName, String imageUrl) async {
//     // Step 1: Update local state immediately for optimistic UI
//     final currentStories = state is StoryLoaded
//         ? List<Story>.from((state as StoryLoaded).stories)
//         : <Story>[];
//
//     final newStory = StoryModel(
//       id: DateTime.now().millisecondsSinceEpoch.toString(),
//       userId: userId,
//       userName: userName,
//       imageUrl: imageUrl,
//       isViewed: false,
//       createdAt: DateTime.now(),
//     );
//
//     final existingIndex = currentStories.indexWhere((s) => s.userId == userId);
//     if (existingIndex >= 0) {
//       currentStories[existingIndex] = newStory;
//     } else {
//       currentStories.add(newStory);
//     }
//
//     emit(StoryLoaded(currentStories));
//
//     // Step 2: Persist to backend (Supabase)
//     final result = await uploadStoryUseCase(UploadStoryParams(
//       userId: userId,
//       imageUrl: imageUrl,
//     ));
//
//     result.fold(
//           (failure) => emit(StoryError(failure.message)),
//           (_) async => await fetchStories(), // Refresh from backend
//     );
//   }
//
//
//   Future<void> fetchStories() async {
//     emit(StoryLoading());
//     try {
//       final result = await getStoriesUseCase();
//
//       result.fold(
//         (failure) => emit(StoryError(failure.message)),
//         (stories) => emit(StoryLoaded(stories)),
//       );
//     } catch (e) {
//       emit(StoryError("Unexpected error: $e"));
//     }
//   }
//
//   /// Mark story as viewed
//   Future<void> viewStory(String storyId) async {
//     try {
//       await markStoryViewedUseCase(MarkViewedParams(storyId: storyId));
//       await fetchStories(); // refresh stories
//     } catch (e) {
//       emit(StoryError("Failed to mark story viewed: $e"));
//     }
//   }
//
//   /// Delete expired stories
//   Future<void> removeExpiredStories() async {
//     try {
//       await deleteExpiredStoriesUseCase(NoParams());
//       await fetchStories(); // refresh stories
//     } catch (e) {
//       emit(StoryError("Failed to delete expired stories: $e"));
//     }
//   }
// }
//
// //
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import '../../../../core/usecase/usecase.dart';
// // import '../../domain/entities/story_entities.dart';
// // import '../../domain/usecase/delet_expired_stories.dart';
// // import '../../domain/usecase/get_stories_usecase.dart';
// // import '../../domain/usecase/mark_viewed.dart';
// // import '../../domain/usecase/upload_story_usecase.dart';
// //
// // part 'story_state.dart';
// //
// // class StoryCubit extends Cubit<StoryState> {
// //   final GetStoriesUseCase getStoriesUseCase;
// //   final UploadStoryUseCase uploadStoryUseCase;
// //   final MarkStoryViewed markStoryViewedUseCase;
// //   final DeleteExpiredStories deleteExpiredStoriesUseCase;
// //
// //   StoryCubit(
// //       this.getStoriesUseCase,
// //       this.uploadStoryUseCase,
// //       this.markStoryViewedUseCase,
// //       this.deleteExpiredStoriesUseCase,
// //       ) : super(StoryInitial());
// //
// //   /// Fetch all stories
// //   Future<void> fetchStories() async {
// //     emit(StoryLoading());
// //     final result = await getStoriesUseCase(NoParams());
// //     result.fold(
// //           (failure) => emit(StoryError(failure.message)),
// //           (stories) => emit(StoryLoaded(stories)),
// //     );
// //   }
// //
// //   /// Upload new story
// //   Future<void> uploadStory(String userId, String imageUrl) async {
// //     emit(StoryLoading());
// //     final result =
// //     await uploadStoryUseCase(UploadStoryParams(userId: userId, imageUrl: imageUrl));
// //     result.fold(
// //           (failure) => emit(StoryError(failure.message)),
// //           (_) async => await fetchStories(),
// //     );
// //   }
// //
// //   /// Mark story as viewed
// //   Future<void> viewStory(String storyId) async {
// //     try {
// //       await markStoryViewedUseCase(MarkViewedParams(storyId: storyId));
// //       await fetchStories(); // refresh stories
// //     } catch (e) {
// //       emit(StoryError("Failed to mark story viewed: $e"));
// //     }
// //   }
// //
// //   /// Delete expired stories
// //   Future<void> removeExpiredStories() async {
// //     try {
// //       await deleteExpiredStoriesUseCase(NoParams());
// //       await fetchStories(); // refresh stories
// //     } catch (e) {
// //       emit(StoryError("Failed to delete expired stories: $e"));
// //     }
// //   }
// // }
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecase/usecase.dart';
import '../../data/models/story_model.dart';
import '../../domain/entities/story_entities.dart';
import '../../domain/usecase/delet_expired_stories.dart';
import '../../domain/usecase/get_stories_usecase.dart';
import '../../domain/usecase/mark_viewed.dart';
import '../../domain/usecase/upload_story_usecase.dart';

part 'story_state.dart';

class StoryCubit extends Cubit<StoryState> {
  final GetStoriesUseCase getStoriesUseCase;
  final UploadStoryUseCase uploadStoryUseCase;
  final MarkStoryViewed markStoryViewedUseCase;
  final DeleteExpiredStories deleteExpiredStoriesUseCase;

  StoryCubit(
      this.getStoriesUseCase,
      this.uploadStoryUseCase,
      this.deleteExpiredStoriesUseCase,
      this.markStoryViewedUseCase,
      ) : super(StoryInitial());

  /// Upload story with optimistic UI
  Future<void> uploadStory(String userId, String userName, String imageUrl) async {
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
          (failure) => emit(StoryError(failure.message)), // Rollback or show error
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
}
