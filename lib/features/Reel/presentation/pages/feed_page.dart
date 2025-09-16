// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_picker/image_picker.dart';
// import '../../../../core/bottum_navigation_bar/bottom_navigation_bar.dart';
// import '../../domain/entities/post_entity.dart';
// import '../bloc/feed_bloc.dart';
// import '../widgets/post_card.dart';
//
// class FeedPage extends StatefulWidget {
//   final String currentUserId;
//   const FeedPage({Key? key, required this.currentUserId}) : super(key: key);
//
//   @override
//   State<FeedPage> createState() => _FeedPageState();
// }
//
// class _FeedPageState extends State<FeedPage> {
//   late FeedBloc bloc;
//
//   @override
//   void initState() {
//     super.initState();
//     bloc = context.read<FeedBloc>();
//     bloc.add(LoadFeedEvent());
//   }
//
//   Future<void> _refresh() async {
//     bloc.add(RefreshFeedEvent());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Feed")),
//       bottomNavigationBar:   const CustomNavigationBar(),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _openMediaPicker,
//         child: Icon(Icons.add),
//       ),
//
//       body: Column(
//         children: [
//           // ✅ Navigation bar placed at the top of the body
//
//
//           // ✅ Expanded so ListView takes remaining space
//           Expanded(
//             child: BlocBuilder<FeedBloc, FeedState>(
//               builder: (context, state) {
//                 if (state is FeedLoading) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 if (state is FeedLoaded) {
//                   final posts = state.posts;
//                   return RefreshIndicator(
//                     onRefresh: _refresh,
//                     child: ListView.builder(
//                       itemCount: posts.length,
//                       itemBuilder: (context, index) {
//                         final Post p = posts[index];
//                         return PostCard(
//                           post: p,
//                           onLike: () => bloc.add(ToggleLikeEvent(p.id, widget.currentUserId)),
//                           onComment: () => _openComments(p),
//                           onShare: () => _sharePost(p),
//                           onSave: () => bloc.add(ToggleSaveEvent(p.id, widget.currentUserId)),
//                         );
//                       },
//                     ),
//                   );
//                 }
//                 if (state is FeedError) {
//                   return Center(child: Text(state.message));
//                 }
//                 return const SizedBox();
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _openComments(Post p) {
//     showModalBottomSheet(
//       context: context,
//       builder: (_) => Center(child: Text('Comments for ${p.id}')),
//     );
//   }
//
//   void _sharePost(Post p) {
//     // share logic (use share_plus)
//   }
// }
//
//
// void _openMediaPicker() {
//   showModalBottomSheet(
//     context: context,
//     builder: (_) => Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         ListTile(
//           leading: Icon(Icons.image),
//           title: Text('Pick Image'),
//           onTap: () async {
//             Navigator.pop(context);
//             final file = await ImagePicker().pickImage(source: ImageSource.gallery);
//             if (file != null) {
//               final url = await uploadMediaToSupabase(file, isVideo: false);
//               if (url != null) {
//                 bloc.add(CreatePostEvent(userId: widget.currentUserId, mediaUrl: url, isVideo: false));
//               }
//             }
//           },
//         ),
//         ListTile(
//           leading: Icon(Icons.videocam),
//           title: Text('Pick Video'),
//           onTap: () async {
//             Navigator.pop(context);
//             final file = await ImagePicker().pickVideo(source: ImageSource.gallery);
//             if (file != null) {
//               final url = await uploadMediaToSupabase(file, isVideo: true);
//               if (url != null) {
//                 bloc.add(CreatePostEvent(userId: widget.currentUserId, mediaUrl: url, isVideo: true));
//               }
//             }
//           },
//         ),
//       ],
//     ),
//   );
// }
//
// // bottomNavigationBar: const CustomNavigationBar(),
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/bottum_navigation_bar/bottom_navigation_bar.dart';
import '../../../../core/common/cubit/auth_user_cubit.dart';
import '../../../../core/common/storage_service.dart';
import '../../../../core/utils/image_pick.dart';
import '../../../../init_dependencies_main.dart';
import '../../../stories/presentation/cubit/story_cubit.dart';
import '../../domain/entities/post_entity.dart';
import '../bloc/feed_bloc.dart';
import '../widgets/post_card.dart';

class FeedPage extends StatefulWidget {
  final String currentUserId;
  const FeedPage({Key? key, required this.currentUserId}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  late FeedBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = context.read<FeedBloc>();
    bloc.add(LoadFeedEvent());
  }

  Future<void> _refresh() async {
    bloc.add(RefreshFeedEvent());
  }

  // ✅ _openMediaPicker must be inside the State class
  void _openMediaPicker() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.image),
            title: const Text('Pick Image'),
            onTap: () async {
              Navigator.pop(context);
              final file = await ImagePicker().pickImage(source: ImageSource.gallery);
              if (file != null) {
                final url = await uploadMediaToSupabase(file.path, isVideo: false);
                if (url != null) {
                  bloc.add(CreatePostEvent(
                      userId: widget.currentUserId,
                      mediaUrl: url,
                      isVideo: false));
                }
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.videocam),
            title: const Text('Pick Video'),
            onTap: () async {
              Navigator.pop(context);
              final file = await ImagePicker().pickVideo(source: ImageSource.gallery);
              if (file != null) {
                final url = await uploadMediaToSupabase(file.path, isVideo: true);
                if (url != null) {
                  bloc.add(CreatePostEvent(
                      userId: widget.currentUserId,
                      mediaUrl: url,
                      isVideo: true));
                }
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Feed")),
      bottomNavigationBar: const CustomNavigationBar(),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _openMediaPicker,
      //   child: const Icon(Icons.add),
      // ),
      // floatingActionButton: FloatingActionButton(
      //   heroTag: 'feed_fab', // <-- add a unique tag
      //   onPressed: _openMediaPicker,
      //   child: Icon(Icons.add),
      // ),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     showModalBottomSheet(
      //       context: context,
      //       builder: (_) => Column(
      //         mainAxisSize: MainAxisSize.min,
      //         children: [
      //           ListTile(
      //             leading: const Icon(Icons.add_a_photo),
      //             title: const Text('Add Story'),
      //             onTap: () async {
      //               Navigator.pop(context);
      //               await _pickAndUploadStory(); // Add to story section
      //             },
      //           ),
      //           ListTile(
      //             leading: const Icon(Icons.post_add),
      //             title: const Text('Create Post'),
      //             onTap: () async {
      //               Navigator.pop(context);
      //               await _pickAndUploadPost(); // Add to feed
      //             },
      //           ),
      //         ],
      //       ),
      //     );
      //   },
      //   child: const Icon(Icons.add),
      // ),

      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<FeedBloc, FeedState>(
              builder: (context, state) {
                if (state is FeedLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is FeedLoaded) {
                  final posts = state.posts;
                  return RefreshIndicator(
                    onRefresh: _refresh,
                    child: ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final Post p = posts[index];
                        return PostCard(
                          post: p,
                          onLike: () => bloc.add(ToggleLikeEvent(p.id, widget.currentUserId)),
                          onComment: () => _openComments(p),
                          onShare: () => _sharePost(p),
                          onSave: () => bloc.add(ToggleSaveEvent(p.id, widget.currentUserId)),
                        );
                      },
                    ),
                  );
                } else if (state is FeedError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _openComments(Post p) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Center(child: Text('Comments for ${p.id}')),
    );
  }

  void _sharePost(Post p) {
    // share logic (use share_plus)
  }
}

// ✅ Dummy uploadMediaToSupabase function
Future<String?> uploadMediaToSupabase(String filePath, {required bool isVideo}) async {
  // Here you should write your Supabase storage upload logic.
  // Return the uploaded media URL.
  // For testing, just return filePath for now
  return filePath;
}


// Future<void> _pickAndUploadStory() async {
//   final userState = context.read<AuthUserCubit>().state;
//   if (userState is! AuthUserLoggedIn) return;
//
//   final userId = userState.user.id;
//   final userName = userState.user.user_name;
//
//   final file = await pickMedia(
//     mediaType: MediaType.image,
//     source: ImageSource.gallery,
//   );
//   if (file == null) return;
//
//   final storageService = serviceLocater<StorageService>();
//   final imageUrl = await storageService.uploadStoryFile(file, userId);
//
//   context.read<StoryCubit>().uploadStory(userId, userName, imageUrl);
// }