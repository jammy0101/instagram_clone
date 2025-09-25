part of 'feed_bloc.dart';


abstract class FeedEvent {}

class LoadFeedEvent extends FeedEvent {
  final int limit;
  LoadFeedEvent({this.limit = 10});
}

class RefreshFeedEvent extends FeedEvent {
  final int limit;
  RefreshFeedEvent({this.limit = 10});
}

class ToggleLikeEvent extends FeedEvent {
  final String postId;
  final String userId;
  ToggleLikeEvent(this.postId, this.userId);
}

class ToggleSaveEvent extends FeedEvent {
  final String postId;
  final String userId;
  ToggleSaveEvent(this.postId, this.userId);
}

class AddCommentEvent extends FeedEvent {
  final String postId;
  final String userId;
  final String text;
  AddCommentEvent({
    required this.postId,
    required this.userId,
    required this.text,
  });

}
class CreatePostEvent extends FeedEvent {
  final String userId;
  final String? username;
  final String? userAvatarUrl;
  final String? content;
  final String? mediaUrl; // <-- add this
  final List<String>? mediaUrls; // optional if you also have multiple files
  final bool isVideo;
  final List<XFile>? mediaFiles;

  CreatePostEvent({
    required this.userId,
    this.username,
    this.userAvatarUrl,
    this.content,
    this.mediaUrl,      // <-- add this
    this.mediaUrls,
    this.isVideo = false,
    this.mediaFiles,
  });
}


class DeletePostEvent extends FeedEvent {
  final String postId;
  final String userId; // add this
  DeletePostEvent({required this.postId, required this.userId});
}


class LoadCommentsEvent extends FeedEvent {
  final String postId;
  LoadCommentsEvent(this.postId);
}

class CommentsLoaded extends FeedState {
  final String postId;
  final List<Comment> comments;
  CommentsLoaded(this.postId, this.comments);
}
