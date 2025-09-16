import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/post_model.dart';
import 'package:image_picker/image_picker.dart';

abstract class PostRemoteDataSource {
  Future<List<PostModel>> fetchFeed({int limit = 10, String? beforeCreatedAt});
  Future<void> likePost(String postId, String userId);
  Future<void> unlikePost(String postId, String userId);
  Future<void> addComment(String postId, String userId, String text);
  Future<void> savePost(String postId, String userId);
  Future<void> unsavePost(String postId, String userId);
  Future<PostModel> createPost(Map<String, dynamic> postData);
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final SupabaseClient client;
  PostRemoteDataSourceImpl(this.client);

  @override
  Future<List<PostModel>> fetchFeed({int limit = 10, String? beforeCreatedAt}) async {
    var query = client
        .from('posts')
        .select('*, users:users(id, username, avatar_url)')
        .order('created_at', ascending: false)
        .limit(limit);

    if (beforeCreatedAt != null) {
      query = client
          .from('posts')
          .select('*, users:users(id, username, avatar_url)')
          .lt('created_at', beforeCreatedAt) // ✅ filter before select
          .order('created_at', ascending: false)
          .limit(limit);
    }

    final res = await query;
    final list = (res as List).map((json) {
      final Map<String, dynamic> postJson = Map<String, dynamic>.from(json);
      if (json['users'] != null) {
        postJson['username'] = json['users']['username'];
        postJson['avatar_url'] = json['users']['avatar_url'];
      }
      return PostModel.fromJson(postJson);
    }).toList();

    return list;
  }

  @override
  Future<void> likePost(String postId, String userId) async {
    try {
      await client.from('likes').insert({'post_id': postId, 'user_id': userId});
    } catch (e) {
      // ignore duplicate key errors
      if (!e.toString().contains('duplicate key')) rethrow;
    }

    // increment likes_count using RPC or raw SQL
    await client.rpc('increment_likes', params: {'post_id_input': postId});
  }

  @override
  Future<void> unlikePost(String postId, String userId) async {
    await client.from('likes').delete().match({'post_id': postId, 'user_id': userId});
    await client.rpc('decrement_likes', params: {'post_id_input': postId});
  }

  @override
  Future<void> addComment(String postId, String userId, String text) async {
    await client.from('comments').insert({
      'post_id': postId,
      'user_id': userId,
      'content': text,
    });

    await client.rpc('increment_comments', params: {'post_id_input': postId});
  }

  @override
  Future<void> savePost(String postId, String userId) async {
    try {
      await client.from('saves').insert({'post_id': postId, 'user_id': userId});
    } catch (e) {
      if (!e.toString().contains('duplicate key')) rethrow;
    }
  }

  @override
  Future<void> unsavePost(String postId, String userId) async {
    await client.from('saves').delete().match({'post_id': postId, 'user_id': userId});
  }

  @override
  Future<PostModel> createPost(Map<String, dynamic> postData) async {
    final res = await client.from('posts').insert(postData).select().single();
    return PostModel.fromJson(res);
  }
  Future<String?> uploadMediaToSupabase(XFile file, {required bool isVideo}) async {
    final storage = Supabase.instance.client.storage;
    final folder = isVideo ? 'videos' : 'images';
    final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.name}';

    try {
      // Upload returns String path, throws exception if fails
      await storage.from('posts_bucket').upload(
        '$folder/$fileName',
        File(file.path),
        fileOptions: FileOptions(
          cacheControl: '3600',
          upsert: false,
        ),
      );

      // getPublicUrl now returns String directly
      final url = storage.from('posts_bucket').getPublicUrl('$folder/$fileName');
      return url; // String
    } catch (e) {
      print('Upload error: $e');
      return null;
    }
  }

}
