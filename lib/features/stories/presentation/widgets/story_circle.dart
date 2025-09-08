import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/story_cubit.dart';
import '../../domain/entities/story_entities.dart';
import '../pages/story_viewer.dart';

class StoryCircle extends StatelessWidget {
  final Story story;

  const StoryCircle({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<StoryCubit>().viewStory(story.id);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => StoryViewerPage(story: story)),
        );
      },
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 7),
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: story.isViewed
                  ? null
                  : const LinearGradient(
                      colors: [Colors.orange, Colors.pink],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              border: story.isViewed
                  ? Border.all(color: Colors.grey, width: 2)
                  : null,
            ),
            child: CircleAvatar(
              radius: 32,
              backgroundImage: story.imageUrl.isNotEmpty
                  ? NetworkImage(story.imageUrl)
                  : const AssetImage("assets/images/rashid.jpeg")
                        as ImageProvider,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            story.userName,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}


