
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:horizon/core/bottum_navigation_bar/bottom_navigation_bar.dart';
import 'package:horizon/core/theme/app_pallete.dart';
import 'package:horizon/features/authh/presentation/pages/login_page.dart';
import 'package:horizon/features/home/presentation/widgets/app_icon_button.dart';
import 'package:horizon/features/stories/presentation/widgets/story_list_view.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/common/cubit/auth_user_cubit.dart';
import '../../../../core/common/storage_service.dart';
import '../../../../core/utils/image_pick.dart';
import '../../../../init_dependencies_main.dart';
import '../../../stories/presentation/cubit/story_cubit.dart';

class Home extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const Home());

  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    context.read<StoryCubit>().fetchStories();
  }

  Future<void> _pickAndUploadStory() async {
    final userState = context.read<AuthUserCubit>().state;
    if (userState is! AuthUserLoggedIn) return;
    final userId = userState.user.id;
    final userName = userState.user.userName;

    // Step 1: Pick media from gallery
    final file = await pickMedia(
      mediaType: MediaType.image,
      source: ImageSource.gallery,
    );
    if (file == null) return;

    // Step 2: Upload to Supabase Storage
    final storageService = serviceLocater<StorageService>();
    final imageUrl = await storageService.uploadStoryFile(file, userId);

    // Step 3: Save story in DB
    context.read<StoryCubit>().uploadStory(userId, userName,imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomNavigationBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 34),
            // Header Row (Logo + Icons)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
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
                        color: AppPallete.gradient3, // make it blue
                        onPressed: _pickAndUploadStory,
                      ),
                      const SizedBox(width: 5),
                      AppIconButton(
                        icon: Icons.favorite_border,
                        color: AppPallete.whiteColor,
                        onPressed: () {
                          // TODO: Add favorite backend
                        },
                      ),
                      const SizedBox(width: 9),
                      AppIconButton(
                        icon: Icons.message_outlined,
                        color: AppPallete.whiteColor,
                        onPressed: () {
                          // TODO: Add message backend
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            BlocBuilder<StoryCubit, StoryState>(
              builder: (context, state) {
                if (state is StoryLoading) {
                  return const CircularProgressIndicator();
                } else if (state is StoryLoaded) {
                  return StoryListView(stories: state.stories);
                } else if (state is StoryError) {
                  return Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            SizedBox(height: 2),
            Divider(),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                // Call logout
                context.read<AuthUserCubit>().logout();
                // Navigate to LoginPage (replace with your login page)
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
