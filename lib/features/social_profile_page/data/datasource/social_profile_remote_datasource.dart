import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/social_profile_model.dart';

abstract class SocialProfileRemoteDataSource {
  Future<SocialProfileModel> fetchSocialProfile();
}

class SocialProfileRemoteDataSourceImpl implements SocialProfileRemoteDataSource {
  final SupabaseClient client;
  SocialProfileRemoteDataSourceImpl(this.client);

  @override
  Future<SocialProfileModel> fetchSocialProfile() async {
    final data = await client
        .from('profiles')
        .select()
        .limit(1)
        .maybeSingle();

    if (data == null) {
      // fallback mock profile
      return SocialProfileModel.fromMap({
        'username': 'wallpapers4k',
        'bio': 'Find High Quality HD Pictures.',
        'profileImage': 'https://picsum.photos/200',
        'posts': 1132,
        'followers': 60000,
        'following': 4,
        'highlights': ['Goggles','Graffiti','Clock','Foods','Paints'],
        'postsImages': List.generate(12, (i) => 'https://picsum.photos/seed/p$i/400'),
      });
    }

    return SocialProfileModel.fromMap(Map<String, dynamic>.from(data));
  }
}
