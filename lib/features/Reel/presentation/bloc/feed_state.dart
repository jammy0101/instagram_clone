part of 'feed_bloc.dart';

abstract class FeedState {}

class FeedInitial extends FeedState {}

class FeedLoading extends FeedState {}

class FeedLoaded extends FeedState {
  final List<Post> posts;
  FeedLoaded(this.posts);
}

class FeedError extends FeedState {
  final String message;
  FeedError(this.message);
}
