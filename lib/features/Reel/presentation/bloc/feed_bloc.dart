
import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../data/models/comment.dart';
import '../../data/models/post_model.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/repositories/post_repository.dart';
import '../../domain/usecase/add_comment.dart';
import '../../domain/usecase/delete_post.dart';
import '../../domain/usecase/get_feed.dart';
import '../../domain/usecase/like_post.dart';
import '../../domain/usecase/save_post.dart';
import '../../domain/usecase/unlike_post.dart';
import '../../domain/usecase/unsave_post.dart';

part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final GetFeed getFeed;
  final LikePost likePost;
  final UnlikePost unlikePost;
  final SavePost savePost;
  final UnsavePost unsavePost;
  final AddComment addComment;
  final PostRepository repository;
  final DeletePost deletePost;

  FeedBloc({
    required this.getFeed,
    required this.likePost,
    required this.unlikePost,
    required this.savePost,
    required this.unsavePost,
    required this.addComment,
    required this.repository,
    required this.deletePost,
  }) : super(FeedInitial()) {
    on<LoadFeedEvent>(_onLoadFeed);
    on<ToggleLikeEvent>(_onToggleLike);
    on<ToggleSaveEvent>(_onToggleSave);
    on<AddCommentEvent>(_onAddComment);
    on<RefreshFeedEvent>(_onRefreshFeed);
    on<CreatePostEvent>(_onCreatePost);
    on<DeletePostEvent>(_onDeletePost);
  }

  Future<void> _onCreatePost(CreatePostEvent event, Emitter<FeedState> emit) async {
    if (state is! FeedLoaded) return;
    final currentPosts = (state as FeedLoaded).posts;

    try {
      // 1️⃣ Optimistic add (temporary post)
      final tempPost = PostModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: event.userId,
        caption: event.content ?? '',
        mediaUrls: event.mediaUrls ?? (event.mediaUrl != null ? [event.mediaUrl!] : []),
        mediaUrl: event.mediaUrl ?? '',
        type: event.isVideo ? 'video' : 'image',
        likesCount: 0,
        commentsCount: 0,
        createdAt: DateTime.now(),
        username: event.username,
        userAvatarUrl: event.userAvatarUrl,
        isSaved: false,
        isLiked: false,
        isVideo: event.isVideo,
        content: event.content ?? '',
      );

      final updatedList = List<Post>.from(currentPosts)..insert(0, tempPost);
      emit(FeedLoaded(updatedList));

      // 2️⃣ Save to server
      final createdPost = await repository.createPost(
        userId: event.userId,
        caption: event.content ?? '',
        mediaUrls: event.mediaUrls ?? (event.mediaUrl != null ? [event.mediaUrl!] : []),
        type: event.isVideo ? 'video' : 'image',
      );

      // 3️⃣ Replace temporary post with server post
      final finalList = updatedList.map((p) => p.id == tempPost.id ? createdPost : p).toList();
      emit(FeedLoaded(finalList));
    } catch (e) {
      emit(FeedError("Failed to create post: $e"));
    }
  }

  Future<void> _onDeletePost(DeletePostEvent event, Emitter<FeedState> emit) async {
    if (state is! FeedLoaded) return;

    final currentPosts = (state as FeedLoaded).posts;
    final updatedPosts = currentPosts.where((p) => p.id != event.postId).toList();

    // Optimistic UI
    emit(FeedLoaded(updatedPosts));

    try {
      await deletePost.call(event.postId, event.userId);
    } catch (e) {
      // Rollback if delete fails
      emit(FeedLoaded(currentPosts));
      print("Delete failed: $e");
    }
  }


  Future<void> _onLoadFeed(LoadFeedEvent e, Emitter<FeedState> emit) async {
    final cachedPosts = repository.getCachedFeed();
    if (cachedPosts.isNotEmpty) {
      emit(FeedLoaded(cachedPosts));
    } else {
      emit(FeedLoading());
    }

    try {
      final posts = await getFeed.call(limit: e.limit);
      emit(FeedLoaded(posts)); // update with fresh remote data
    } catch (_) {
      if (cachedPosts.isEmpty) {
        emit(FeedError("Failed to load feed"));
      }
      // else: keep showing cached posts
    }
  }



  Future<void> _onRefreshFeed(RefreshFeedEvent e, Emitter<FeedState> emit) async {
    try {
      final posts = await getFeed.call(limit: e.limit);
      emit(FeedLoaded(posts));
    } catch (_) {
      emit(FeedError("Refresh failed"));
    }
  }

  Future<void> _onToggleLike(ToggleLikeEvent e, Emitter<FeedState> emit) async {
    if (state is! FeedLoaded) return;
    final current = (state as FeedLoaded).posts;
    final idx = current.indexWhere((p) => p.id == e.postId);
    if (idx == -1) return;

    final post = current[idx];
    final liked = post.isLiked;

    final updated = post.copyWith(
      isLiked: !liked,
      likesCount: liked ? post.likesCount - 1 : post.likesCount + 1,
    );
    final newList = List<Post>.from(current)..[idx] = updated;
    emit(FeedLoaded(newList));

    try {
      if (liked) await unlikePost.call(e.postId, e.userId);
      else await likePost.call(e.postId, e.userId);
    } catch (_) {
      final rolled = List<Post>.from(current)..[idx] = post;
      emit(FeedLoaded(rolled));
    }
  }

  Future<void> _onToggleSave(ToggleSaveEvent e, Emitter<FeedState> emit) async {
    if (state is! FeedLoaded) return;
    final current = (state as FeedLoaded).posts;
    final idx = current.indexWhere((p) => p.id == e.postId);
    if (idx == -1) return;

    final post = current[idx];
    final saved = post.isSaved;

    final updated = post.copyWith(isSaved: !saved);
    final newList = List<Post>.from(current)..[idx] = updated;
    emit(FeedLoaded(newList));

    try {
      if (saved) await unsavePost.call(e.postId, e.userId);
      else await savePost.call(e.postId, e.userId);
    } catch (_) {
      final rolled = List<Post>.from(current)..[idx] = post;
      emit(FeedLoaded(rolled));
    }
  }

  Future<void> _onAddComment(AddCommentEvent e, Emitter<FeedState> emit) async {
    if (state is! FeedLoaded) return;

    try {
      await addComment.call(e.postId, e.userId, e.text);

      final current = (state as FeedLoaded).posts;
      final idx = current.indexWhere((p) => p.id == e.postId);
      if (idx != -1) {
        final post = current[idx];
        final updated = post.copyWith(commentsCount: post.commentsCount + 1);
        final newList = List<Post>.from(current)..[idx] = updated;
        emit(FeedLoaded(newList));
      }
    } catch (_) {}
  }

  @override
  Future<void> close() => super.close();
}
