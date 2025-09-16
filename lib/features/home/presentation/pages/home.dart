import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:horizon/core/bottum_navigation_bar/bottom_navigation_bar.dart';
import 'package:horizon/core/theme/app_pallete.dart';
import 'package:horizon/features/chat/presentation/pages/chat.dart';
import 'package:horizon/features/home/presentation/widgets/app_icon_button.dart';
import 'package:horizon/features/stories/presentation/widgets/story_list_view.dart';
import '../../../../core/common/cubit/auth_user_cubit.dart';
import '../../../../core/common/storage_service.dart';
import '../../../../core/utils/image_pick.dart';
import '../../../../init_dependencies_main.dart';
import '../../../Reel/domain/entities/post_entity.dart';
import '../../../Reel/presentation/bloc/feed_bloc.dart';
import '../../../Reel/presentation/widgets/post_card.dart';
import '../../../stories/presentation/cubit/story_cubit.dart';

class Home extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const Home());
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late FeedBloc feedBloc;

  @override
  void initState() {
    super.initState();
    context.read<StoryCubit>().fetchStories();
    feedBloc = context.read<FeedBloc>();
    feedBloc.add(LoadFeedEvent());
  }

  Future<void> _pickAndUploadPost() async {
    final userState = context.read<AuthUserCubit>().state;
    if (userState is! AuthUserLoggedIn) return;

    final userId = userState.user.id;

    final picker = ImagePicker();

    // Pick either image or video
    final file =
        await picker.pickImage(source: ImageSource.gallery) ??
        await picker.pickVideo(source: ImageSource.gallery);

    if (file == null) return;

    // Upload to Supabase
    final url = await uploadMediaToSupabase(
      file.path,
      isVideo: file.path.endsWith('.mp4'),
    );

    if (url != null) {
      feedBloc.add(
        CreatePostEvent(
          userId: userId,
          mediaUrl: url,
          isVideo: file.path.endsWith('.mp4'),
        ),
      );
    }
  }

  Future<void> _pickAndUploadStory() async {
    final userState = context.read<AuthUserCubit>().state;
    if (userState is! AuthUserLoggedIn) return;

    final userId = userState.user.id;
    final userName = userState.user.user_name;

    final file = await pickMedia(
      mediaType: MediaType.image,
      source: ImageSource.gallery,
    );
    if (file == null) return;

    final storageService = serviceLocater<StorageService>();
    final imageUrl = await storageService.uploadStoryFile(file, userId);

    context.read<StoryCubit>().uploadStory(userId, userName, imageUrl);
  }

  Future<void> _refreshFeed() async {
    feedBloc.add(RefreshFeedEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomNavigationBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            builder: (_) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.add_a_photo),
                  title: const Text('Add Story'),
                  onTap: () async {
                    Navigator.pop(context);
                    await _pickAndUploadStory(); // Add to story section
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.post_add),
                  title: const Text('Create Post'),
                  onTap: () async {
                    Navigator.pop(context);
                    await _pickAndUploadPost(); // Directly opens gallery
                  },
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),

      body: RefreshIndicator(
        onRefresh: _refreshFeed,
        child: CustomScrollView(
          slivers: [
            // Header: Logo + Icons
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 40,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/images/logos_instagram.png',
                      color: AppPallete.whiteColor,
                      height: 50,
                    ),
                    Row(
                      children: [
                        AppIconButton(
                          icon: Icons.add_box_outlined,
                          color: AppPallete.gradient3,
                          onPressed: _pickAndUploadStory,
                        ),
                        const SizedBox(width: 8),
                        AppIconButton(
                          icon: Icons.favorite_border,
                          color: AppPallete.whiteColor,
                          onPressed: () {},
                        ),
                        const SizedBox(width: 8),
                        AppIconButton(
                          icon: Icons.message_outlined,
                          color: AppPallete.whiteColor,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const Chat()),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Stories
            SliverToBoxAdapter(
              child: SizedBox(
                height: 100,
                child: BlocBuilder<StoryCubit, StoryState>(
                  builder: (context, state) {
                    if (state is StoryLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is StoryLoaded) {
                      return StoryListView(stories: state.stories);
                    } else if (state is StoryError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),

            // Divider
            SliverToBoxAdapter(child: Divider(color: Colors.grey[800])),

            // Feed
            BlocBuilder<FeedBloc, FeedState>(
              builder: (context, state) {
                if (state is FeedLoading) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (state is FeedLoaded) {
                  if (state.posts.isEmpty) {
                    return const SliverFillRemaining(
                      child: Center(child: Text("No posts yet")),
                    );
                  }
                  return SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final Post p = state.posts[index];
                      final userState = context.read<AuthUserCubit>().state;
                      final currentUserId = userState is AuthUserLoggedIn
                          ? userState.user.id
                          : "";

                      return PostCard(
                        post: p,
                        onLike: () =>
                            feedBloc.add(ToggleLikeEvent(p.id, currentUserId)),
                        onComment: () => _openComments(p),
                        onShare: () => _sharePost(p),
                        onSave: () =>
                            feedBloc.add(ToggleSaveEvent(p.id, currentUserId)),
                      );
                    }, childCount: state.posts.length),
                  );
                } else if (state is FeedError) {
                  return SliverFillRemaining(
                    child: Center(child: Text(state.message)),
                  );
                }
                return const SliverFillRemaining(child: SizedBox());
              },
            ),
          ],
        ),
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
    // TODO: Implement share logic using share_plus
  }
}

// Dummy Supabase upload function (replace with your logic)
Future<String?> uploadMediaToSupabase(
  String filePath, {
  required bool isVideo,
}) async {
  return filePath; // For testing; replace with actual Supabase upload
}
