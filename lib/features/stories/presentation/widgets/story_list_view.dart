import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:horizon/features/stories/data/models/story_model.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/common/cubit/auth_user_cubit.dart';
import '../../../../core/common/storage_service.dart';
import '../../../../core/utils/image_pick.dart';
import '../../../../init_dependencies_main.dart';
import '../cubit/story_cubit.dart';
import '../../domain/entities/story_entities.dart';
import 'story_circle.dart';

class StoryListView extends StatelessWidget {
  final List<Story> stories;

  const StoryListView({super.key, required this.stories});

  Future<void> _pickAndUploadStory(BuildContext context) async {
    final userState = context.read<AuthUserCubit>().state;
    if (userState is! AuthUserLoggedIn) return;
    final userId = userState.user.id;
    final userName = userState.user.userName;

    // Pick media
    final file =
    await pickMedia(mediaType: MediaType.image, source: ImageSource.gallery);
    if (file == null) return;

    // Upload to Supabase
    final storageService = serviceLocater<StorageService>();
    final imageUrl = await storageService.uploadStoryFile(file, userId);

    // Save story in DB
    context.read<StoryCubit>().uploadStory(userId,userName, imageUrl,);
  }

  Widget _buildYourStoryCircle(BuildContext context, List<Story> stories) {
    final userState = context.read<AuthUserCubit>().state;
    if (userState is! AuthUserLoggedIn) return const SizedBox();

    final userId = userState.user.id;

    // Find my story if exists
    final myStory = stories.firstWhere(
          (s) => s.userId == userId,
      orElse: () => StoryModel(
        id: '',
        userId: userId,
        userName: userState.user.userName,
        imageUrl: '',
        isViewed: false,
          createdAt: DateTime.now(),
      ),
    );

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (myStory.imageUrl.isNotEmpty) {
              // Open story viewer
              context.read<StoryCubit>().viewStory(myStory.id);
            } else {
              // Upload new story
              _pickAndUploadStory(context);
            }
          },
          onLongPress: () async {
            // Always allow replacing with new story
            await _pickAndUploadStory(context);
          },
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: myStory.imageUrl.isNotEmpty
                  ? const LinearGradient(
                colors: [Colors.orange, Colors.pink],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
                  : null,
              border: myStory.imageUrl.isEmpty
                  ? Border.all(color: Colors.grey, width: 2)
                  : null,
            ),
            child: CircleAvatar(
              radius: 35,
              backgroundImage: myStory.imageUrl.isNotEmpty
                  ? NetworkImage(myStory.imageUrl)
                  : const AssetImage("assets/images/rashid.jpeg") as ImageProvider,

            ),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          "Your story",
          style: TextStyle(fontSize: 12, color: Colors.white),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: stories.length + 1, // +1 for "Your story"
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildYourStoryCircle(context, stories);
          }
          final story = stories[index - 1];
          return StoryCircle(story: story);
        },
      ),
    );
  }
}