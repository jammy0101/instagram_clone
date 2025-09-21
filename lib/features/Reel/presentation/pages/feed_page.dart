// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_picker/image_picker.dart';
// import '../../../../core/bottum_navigation_bar/bottom_navigation_bar.dart';
// import '../../domain/entities/post_entity.dart';
// import '../bloc/feed_bloc.dart';
// import '../widgets/comment_section.dart';
// import '../widgets/post_card.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'dart:typed_data'; // ✅ for Uint8List
// import 'package:path/path.dart' show basename;
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
//
//   void _openComments(Post post) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) {
//         return DraggableScrollableSheet(
//           initialChildSize: 0.7, // starts at 70% height
//           minChildSize: 0.4,     // can shrink
//           maxChildSize: 0.95,    // can expand
//           expand: false,
//           builder: (context, scrollController) {
//             return Container(
//               decoration: const BoxDecoration(
//                 color: Colors.green,
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black26,
//                     blurRadius: 8,
//                     offset: Offset(0, -2),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 children: [
//                   // --- small drag handle ---
//                   Container(
//                     width: 40,
//                     height: 5,
//                     margin: const EdgeInsets.symmetric(vertical: 8),
//                     decoration: BoxDecoration(
//                       color: Colors.grey[400],
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//
//                   // --- title bar ---
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text(
//                           "Comments",
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.close),
//                           onPressed: () => Navigator.pop(context),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const Divider(height: 1),
//
//                   // --- comment section ---
//                   Expanded(
//                     child: CommentSection(
//                       postId: post.id,
//                       scrollController: scrollController,
//                       currentUserId: widget.currentUserId,
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Feed")),
//       bottomNavigationBar: const CustomNavigationBar(),
//       body: Column(
//         children: [
//           Expanded(
//             child: BlocBuilder<FeedBloc, FeedState>(
//               builder: (context, state) {
//                 if (state is FeedLoading) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (state is FeedLoaded) {
//                   final posts = state.posts;
//                   return RefreshIndicator(
//                     onRefresh: _refresh,
//                     child: ListView.builder(
//                       itemCount: posts.length,
//                       itemBuilder: (context, index) {
//                         final Post p = posts[index];
//                         return PostCard(
//                           post: p,
//                           onLike: () => bloc.add(
//                             ToggleLikeEvent(p.id, widget.currentUserId),
//                           ),
//                           onComment: () => _openComments(p),
//                           onShare: () => _sharePost(p),
//                           onSave: () => bloc.add(
//                             ToggleSaveEvent(p.id, widget.currentUserId),
//                           ),
//                         );
//                       },
//                     ),
//                   );
//                 } else if (state is FeedError) {
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
//   void _sharePost(Post p) {
//     // share logic (use share_plus)
//   }
//
//   Future<String?> uploadMediaToSupabase(
//     String filePath, {
//     required bool isVideo,
//   }) async {
//     try {
//       final supabase = Supabase.instance.client;
//       final file = File(filePath);
//       final fileName =
//           '${DateTime.now().millisecondsSinceEpoch}_${basename(file.path)}';
//       final bucketName =
//           'posts_bucket'; // 👈 make sure this bucket exists in Supabase
//
//       // ✅ Read file as bytes
//       final Uint8List bytes = await file.readAsBytes();
//
//       // ✅ Upload as binary
//       await supabase.storage
//           .from(bucketName)
//           .uploadBinary(
//             fileName,
//             bytes,
//             fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
//           );
//
//       // ✅ Get public URL
//       final url = supabase.storage.from(bucketName).getPublicUrl(fileName);
//       return url;
//     } catch (e) {
//       print("Upload error: $e");
//       return null;
//     }
//   }
// }
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' show basename;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/bottum_navigation_bar/bottom_navigation_bar.dart';
import '../../domain/entities/post_entity.dart';
import '../bloc/feed_bloc.dart';
import '../widgets/comment_section.dart';
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

  // void _openComments(Post post) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (_) {
  //       return DraggableScrollableSheet(
  //         initialChildSize: 0.7,
  //         minChildSize: 0.4,
  //         maxChildSize: 0.95,
  //         expand: false,
  //         builder: (context, scrollController) {
  //           return Container(
  //             decoration: const BoxDecoration(
  //               color: Colors.blueGrey,
  //               borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
  //               boxShadow: [
  //                 BoxShadow(
  //                   color: Colors.black26,
  //                   blurRadius: 8,
  //                   offset: Offset(0, -2),
  //                 ),
  //               ],
  //             ),
  //             child: CommentSection(
  //               postId: post.id,
  //               scrollController: scrollController,
  //               currentUserId: widget.currentUserId,
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }
  void _openComments(Post post) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // keeps rounded corners visible
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF1E1E1E) // Dark mode bg
                    : Colors.white, // Light mode bg
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // 🔹 Drag handle
                  Container(
                    width: 40,
                    height: 5,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  // 🔹 Comment Section
                  Expanded(
                    child: CommentSection(
                      postId: post.id,
                      scrollController: scrollController,
                      currentUserId: widget.currentUserId,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }


  void _sharePost(Post p) {
    // TODO: add share_plus
  }

  Future<String?> uploadMediaToSupabase(
      String filePath, {
        required bool isVideo,
      }) async {
    try {
      final supabase = Supabase.instance.client;
      final file = File(filePath);
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${basename(file.path)}';
      final bucketName = 'posts_bucket';

      final Uint8List bytes = await file.readAsBytes();
      await supabase.storage.from(bucketName).uploadBinary(
        fileName,
        bytes,
        fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
      );

      return supabase.storage.from(bucketName).getPublicUrl(fileName);
    } catch (e) {
      print("Upload error: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Feed")),
      bottomNavigationBar: const CustomNavigationBar(),
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
                          onLike: () => bloc.add(
                            ToggleLikeEvent(p.id, widget.currentUserId),
                          ),
                          onComment: () => _openComments(p),
                          onShare: () => _sharePost(p),
                          onSave: () => bloc.add(
                            ToggleSaveEvent(p.id, widget.currentUserId),
                          ),
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
}
