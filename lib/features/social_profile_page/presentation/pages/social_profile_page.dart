// import 'package:flutter/material.dart';
// import 'package:horizon/features/profile/presentation/pages/edit_profile_page.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
//
// import '../../../../core/bottum_navigation_bar/bottom_navigation_bar.dart';
//
//
// class SocialProfilePage extends StatefulWidget {
//   const SocialProfilePage({super.key});
//
//   @override
//   State<SocialProfilePage> createState() => _SocialProfilePageState();
// }
//
// class _SocialProfilePageState extends State<SocialProfilePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('SocialProfilePage'),
//       ),
//       bottomNavigationBar: const CustomNavigationBar(),
//       body: Column(
//         children: [
//           TextButton(
//             onPressed: (){
//               Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfilePage(userId: Supabase.instance.client.auth.currentUser?.id ?? '')));
//             },
//             child: Text('Edit Profile'),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/bottum_navigation_bar/bottom_navigation_bar.dart';
import '../../../profile/presentation/pages/edit_profile_page.dart';
import '../bloc/social_profile_bloc.dart';
import '../bloc/social_profile_event.dart';
import '../bloc/social_profile_state.dart';


class SocialProfilePage extends StatefulWidget {
  const SocialProfilePage({super.key});

  @override
  State<SocialProfilePage> createState() => _SocialProfilePageState();
}

class _SocialProfilePageState extends State<SocialProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<SocialProfileBloc>().add(LoadSocialProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      bottomNavigationBar: const CustomNavigationBar(),
      body: BlocBuilder<SocialProfileBloc, SocialProfileState>(
        builder: (context, state) {
          if (state is SocialProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SocialProfileLoaded) {
            final profile = state.profile;

            return SingleChildScrollView(
              child: Column(
                children: [
                  // --- Profile Header ---
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(profile.profileImage),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStat("Posts", profile.posts),
                              _buildStat("Followers", profile.followers),
                              _buildStat("Following", profile.following),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // --- Username & Bio ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(profile.username,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 4),
                          Text(profile.bio),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // --- Edit Profile Button ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfilePage(
                                userId: Supabase.instance.client.auth.currentUser?.id ?? '',
                              ),
                            ),
                          );
                        },
                        child: const Text("Edit Profile"),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // --- Highlights ---
                  SizedBox(
                    height: 90,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: profile.highlights.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(
                                  "https://picsum.photos/seed/${profile.highlights[index]}/100",
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                profile.highlights[index],
                                style: const TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  const Divider(),

                  // --- Posts Grid ---
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: profile.postsImages.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 2,
                    ),
                    itemBuilder: (context, index) {
                      return Image.network(
                        profile.postsImages[index],
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ],
              ),
            );
          } else if (state is SocialProfileError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildStat(String label, int count) {
    return Column(
      children: [
        Text(
          "$count",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 4),
        Text(label),
      ],
    );
  }
}
