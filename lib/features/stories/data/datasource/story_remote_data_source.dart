import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/story_model.dart';

abstract interface class StoryRemoteDataSource {
  Future<List<StoryModel>> getStories();
  Future<void> uploadStory(String userId, String imageUrl);
  Future<void> markViewed(String storyId);
  Future<void> deleteExpiredStories();
}

class StoryRemoteDataSourceImpl implements StoryRemoteDataSource {
  final SupabaseClient client;

  StoryRemoteDataSourceImpl(this.client);

  @override
  Future<List<StoryModel>> getStories() async {
    final response = await client
        .from('stories')
        .select('id, user_id, image_url, is_viewed, created_at, profiles(username)')
        .order('created_at', ascending: false);

    return (response as List).map((json) => StoryModel.fromJson(json)).toList();
  }

  @override
  Future<void> uploadStory(String userId, String imageUrl) async {
    await client.from('stories').insert({
      'user_id': userId,
      'image_url': imageUrl,
      'is_viewed': false,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  @override
  Future<void> markViewed(String storyId) async {
    await client
        .from('stories')
        .update({'is_viewed': true})
        .eq('id', storyId);
  }

  @override
  Future<void> deleteExpiredStories() async {
    final cutoff = DateTime.now().subtract(const Duration(hours: 24));
    await client.from('stories').delete().lt('created_at', cutoff.toIso8601String());
  }
}
