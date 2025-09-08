import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/common/cubit/auth_user_cubit.dart';
import '../../../../init_dependencies_main.dart';
import '../../domain/entities/story_entities.dart';
import '../cubit/story_cubit.dart';

class StoryViewerPage extends StatefulWidget {
  final Story story;
  const StoryViewerPage({super.key, required this.story});

  @override
  State<StoryViewerPage> createState() => _StoryViewerPageState();
}

class _StoryViewerPageState extends State<StoryViewerPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    // If story expired (after 24h), close immediately
    final now = DateTime.now();
    final storyTime = widget.story.createdAt;
    if (now.difference(storyTime).inHours >= 24) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context);
      });
      return;
    }

    // Progress controller (5s duration)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        Navigator.pop(context);
      }
    });

    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  String _timeAgo(DateTime dateTime) {
    final now = DateTime.now().toUtc();
    final storyTime = dateTime.toUtc();
    final diff = now.difference(storyTime);

    if (diff.isNegative) return "just now"; // ✅ Prevent negative values

    if (diff.inMinutes < 60) {
      return "${diff.inMinutes}m ago";
    } else if (diff.inHours < 24) {
      return "${diff.inHours}h ago";
    } else {
      return DateFormat('MMM d').format(storyTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserState = serviceLocater<AuthUserCubit>().state;
    final currentUserId = currentUserState is AuthUserLoggedIn
        ? currentUserState.user.id
        : null;
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Stack(
          children: [
            // Story Image
            Center(
              child: Image.network(widget.story.imageUrl, fit: BoxFit.contain),
            ),

            // Progress bar + header
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Progress indicator
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return LinearProgressIndicator(
                          value: _controller.value,
                          backgroundColor: Colors.white24,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8),

                    // User info row with popup menu
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundImage: NetworkImage(
                                widget.story.imageUrl,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              widget.story.userName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _timeAgo(widget.story.createdAt),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        // Get current user ID

                        // Popup menu
                        PopupMenuButton<String>(
                          color: Colors.grey[900],
                          icon: const Icon(
                            Icons.more_vert,
                            color: Colors.white,
                          ),
                          onSelected: (value) {
                            if (value == "report") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Reported")),
                              );
                            } else if (value == "mute") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Muted")),
                              );
                            } else if (value == "delete") {
                              // Only allow deletion if it's your story
                              if (currentUserId != null &&
                                  widget.story.userId == currentUserId) {
                                context.read<StoryCubit>().deleteStory(
                                  widget.story.id,
                                );
                                Navigator.pop(
                                  context,
                                ); // Close story viewer after deletion
                              }
                            }
                          },
                          itemBuilder: (context) {
                            final items = <PopupMenuEntry<String>>[
                              const PopupMenuItem(
                                value: "report",
                                child: Text("Report"),
                              ),
                              const PopupMenuItem(
                                value: "mute",
                                child: Text("Mute"),
                              ),
                            ];

                            // Add "Delete" only if it's current user's story
                            if (currentUserId != null &&
                                widget.story.userId == currentUserId) {
                              items.add(
                                const PopupMenuItem(
                                  value: "delete",
                                  child: Text("Delete"),
                                ),
                              );
                            }

                            return items;
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
