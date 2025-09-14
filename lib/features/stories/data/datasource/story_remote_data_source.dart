import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/exception.dart';
import '../models/story_model.dart';

abstract interface class StoryRemoteDataSource {
  Future<List<StoryModel>> getStories();
  Future<void> uploadStory(String userId, String imageUrl);
  Future<void> markViewed(String storyId);
  Future<void> deleteExpiredStories();
  Future<void> deleteStory(String storyId);
}

class StoryRemoteDataSourceImpl implements StoryRemoteDataSource {
  final SupabaseClient client;

  StoryRemoteDataSourceImpl(this.client);

  //upload story to the supabase
  @override
  Future<void> uploadStory(String userId, String imageUrl) async {
    try {
      await client.from('stories').insert({
        'user_id': userId,
        'image_url': imageUrl,
        'is_viewed': false,
        'created_at': DateTime.now().toUtc().toIso8601String(),
      });
    } catch (e) {
      debugPrint("❌ Error uploading story: $e");
      throw ServerException(e.toString());
    }
  }

  //deletion of the story
  @override
  Future<void> deleteStory(String storyId) async {
    // Example with Supabase:
    await client.from('stories').delete().eq('id', storyId);
  }


  //getStory from supabase
  @override
  Future<List<StoryModel>> getStories() async {
    try {
      final response = await client
          .from('stories')
          .select('id, user_id, image_url, is_viewed, created_at, profiles(user_name)')
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => StoryModel.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    } catch (e) {
      debugPrint("❌ Error fetching stories: $e");
      throw ServerException(e.toString());
    }
  }




//viewed current story
  @override
  Future<void> markViewed(String storyId) async {
    try{
      await client
          .from('stories')
          .update({'is_viewed': true})
          .eq('id', storyId);

    }catch (e) {
      debugPrint("❌ Error uploading story: $e");
      throw ServerException(e.toString());
    }
  }

  //delete the story
  @override
  Future<void> deleteExpiredStories() async {
    try{
      final cutoff = DateTime.now().subtract(const Duration(hours: 24));
      await client.from('stories').delete().lt('created_at', cutoff.toIso8601String());
    }catch (e) {
      debugPrint("❌ Error uploading story: $e");
      throw ServerException(e.toString());
    }
  }
}
