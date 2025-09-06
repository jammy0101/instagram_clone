// // part of 'story_cubit.dart';
// //
// // @immutable
// // sealed class StoryState {}
// //
// // final class StoryInitial extends StoryState {}
// part of 'story_cubit.dart';
//
// abstract class StoryState {}
//
// class StoryInitial extends StoryState {}
//
// class StoryLoading extends StoryState {}
//
// class StoryLoaded extends StoryState {
//   final List<Story> stories;
//   StoryLoaded(this.stories);
// }
//
// class StoryError extends StoryState {
//   final String message;
//   StoryError(this.message);
// }

part of 'story_cubit.dart';

abstract class StoryState {}

class StoryInitial extends StoryState {}

class StoryLoading extends StoryState {}

class StoryLoaded extends StoryState {
  final List<Story> stories;
  StoryLoaded(this.stories);
}

class StoryError extends StoryState {
  final String message;
  StoryError(this.message);
}
