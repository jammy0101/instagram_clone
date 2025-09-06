// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:horizon/features/stories/data/models/story_model.dart';
// import 'package:horizon/features/stories/presentation/widgets/story_circle.dart';
// import 'package:image_picker/image_picker.dart';
// import '../../../../core/common/cubit/auth_user_cubit.dart';
// import '../../../../core/common/storage_service.dart';
// import '../../../../core/utils/image_pick.dart';
// import '../../../../init_dependencies_main.dart';
// import '../cubit/story_cubit.dart';
// import '../../domain/entities/story_entities.dart';
//
// class StoryListView extends StatelessWidget {
//   final List<Story> stories;
//
//   const StoryListView({super.key, required this.stories});
//
//   Future<void> _pickAndUploadStory(BuildContext context) async {
//     final userState = context.read<AuthUserCubit>().state;
//     if (userState is! AuthUserLoggedIn) return;
//     final userId = userState.user.id;
//
//     // Pick media
//     final file =
//     await pickMedia(mediaType: MediaType.image, source: ImageSource.gallery);
//     if (file == null) return;
//
//     // Upload to Supabase
//     final storageService = serviceLocater<StorageService>();
//     final imageUrl = await storageService.uploadStoryFile(file, userId);
//
//     // Save story in DB
//     context.read<StoryCubit>().uploadStory(userId, imageUrl);
//   }
//
//   Widget _buildYourStoryCircle(BuildContext context, List<Story> stories) {
//     final userState = context.read<AuthUserCubit>().state;
//     if (userState is! AuthUserLoggedIn) return const SizedBox();
//
//     final userId = userState.user.id;
//
//     // Check if user already has a story
//     // final myStory = stories.firstWhere(
//     //       (s) => s.userId == userId,
//     //   orElse: () => Story(
//     //     id: '',
//     //     userId: userId,
//     //     userName: userState.user.userName,
//     //     imageUrl: '',
//     //     //createdAt: DateTime.now(),
//     //     isViewed: false,
//     //   ),
//     // );
//     final myStory = stories.firstWhere(
//           (s) => s.userId == userId,
//       orElse: () => StoryModel(
//         id: '',
//         userId: userId,
//         userName: userState.user.userName,
//         imageUrl: '',
//         //createdAt: DateTime.now(),
//         isViewed: false,
//       ),
//     );
//
//
//     return Column(
//       children: [
//         GestureDetector(
//           onTap: () {
//             if (myStory.imageUrl.isEmpty) {
//               // Upload new story
//               _pickAndUploadStory(context);
//             } else {
//               // Open story viewer
//               context.read<StoryCubit>().viewStory(myStory.id);
//             }
//           },
//           child: Stack(
//             alignment: Alignment.bottomRight,
//             children: [
//               CircleAvatar(
//                 radius: 35,
//                 backgroundImage: myStory.imageUrl.isNotEmpty
//                     ? NetworkImage(myStory.imageUrl)
//                     : const AssetImage("assets/images/rashid.jpeg")
//                 as ImageProvider,
//               ),
//               if (myStory.imageUrl.isEmpty)
//                 const Positioned(
//                   right: 0,
//                   bottom: 0,
//                   child: CircleAvatar(
//                     radius: 12,
//                     backgroundColor: Colors.orangeAccent,
//                     child: Icon(Icons.add, size: 16, color: Colors.white),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 4),
//         const Text(
//           "Your story",
//           style: TextStyle(fontSize: 12, color: Colors.white),
//         ),
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final now = DateTime.now();
//
//     // Filter out expired stories (older than 24h)
//     // final validStories =
//     // stories.where((s) => now.difference(s.createdAt).inHours < 24).toList();
//
//     final validStories = stories;
//
//     return SizedBox(
//       height: 110,
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         itemCount: validStories.length + 1, // +1 for "Your story"
//         separatorBuilder: (_, __) => const SizedBox(width: 12),
//         itemBuilder: (context, index) {
//           if (index == 0) {
//             return _buildYourStoryCircle(context, validStories);
//           }
//           // final story = validStories[index - 1];
//           // return Column(
//           //   children: [
//           //     Container(
//           //       padding: const EdgeInsets.all(2),
//           //       decoration: BoxDecoration(
//           //         shape: BoxShape.circle,
//           //         border: Border.all(
//           //           color: story.isViewed ? Colors.grey : Colors.red,
//           //           width: 3,
//           //         ),
//           //       ),
//           //       child: CircleAvatar(
//           //         radius: 35,
//           //         backgroundImage: NetworkImage(story.imageUrl),
//           //       ),
//           //     ),
//           //     const SizedBox(height: 4),
//           //     Text(
//           //       story.userName,
//           //       style: const TextStyle(fontSize: 12, color: Colors.white),
//           //     ),
//           //   ],
//           // );
//           final story = validStories[index - 1];
//           return StoryCircle(story: story);
//
//         },
//       ),
//     );
//   }
// }
