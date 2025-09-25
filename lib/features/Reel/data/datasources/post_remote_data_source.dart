
import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../Reel/data/models/post_model.dart';
import 'package:image_picker/image_picker.dart';

import '../models/comment.dart';

abstract class PostRemoteDataSource {
  Future<List<PostModel>> fetchFeed({int limit = 5, String? beforeCreatedAt});
  Future<void> likePost(String postId, String userId);
  Future<void> unlikePost(String postId, String userId);
  Future<void> addComment(String postId, String userId, String text);
  Future<void> savePost(String postId, String userId);
  Future<void> unsavePost(String postId, String userId);
  Future<void> deletePost(String postId);

  /// Create post with multiple media URLs
  Future<PostModel> createPost({
    required String userId,
    required String caption,
    required List<String> mediaUrls,
    required String type, // "image", "video", "mixed"
  });

  /// Upload a file to Supabase storage
  Future<String?> uploadMediaToSupabase(XFile file, {required bool isVideo});
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final SupabaseClient client;
  PostRemoteDataSourceImpl(this.client);

  @override
  Future<List<PostModel>> fetchFeed({int limit = 10, String? beforeCreatedAt}) async {
    var query = client
        .from('posts')
        .select('*, profiles!inner(user_name, avatar_url)')
        .order('created_at', ascending: false)
        .limit(limit);

    if (beforeCreatedAt != null) {
      query = client
          .from('posts')
          .select('*, profiles!inner(user_name, avatar_url)')
          .lt('created_at', beforeCreatedAt) // ✅ works now
          .order('created_at', ascending: false)
          .limit(limit);
    }


    final res = await query;

    final list = (res as List).map((json) {
      final Map<String, dynamic> postJson = Map<String, dynamic>.from(json);

      // attach profile fields
      if (json['profiles'] != null) {
        postJson['username'] = json['profiles']['user_name'];
        postJson['avatar_url'] = json['profiles']['avatar_url'];
      }

      // handle media_urls
      final mediaUrls = (json['media_urls'] as List?)?.map((e) => e.toString()).toList() ?? [];
      postJson['media_urls'] = mediaUrls;
      postJson['media_url'] = mediaUrls.isNotEmpty ? mediaUrls.first : '';
      postJson['is_video'] = (json['type'] == 'video');

      return PostModel.fromJson(postJson);
    }).toList();

    return list;
  }



  @override
  Future<void> likePost(String postId, String userId) async {
    try {
      await client.from('likes').insert({'post_id': postId, 'user_id': userId});
    } catch (e) {
      if (!e.toString().contains('duplicate key')) rethrow;
    }
  }

  @override
  Future<void> unlikePost(String postId, String userId) async {
    await client.from('likes').delete().match({'post_id': postId, 'user_id': userId});
  }

  @override
  Future<void> addComment(String postId, String userId, String text) async {
    await client.from('comments').insert({
      'post_id': postId,
      'user_id': userId,
      'content': text,
    });
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




  /// createPost with media_urls column directly in posts
  @override
  Future<PostModel> createPost({
    required String userId,
    required String caption,
    required List<String> mediaUrls,
    required String type,
  }) async {
    // Step 1: Insert post with media URLs
    final postRes = await client.from('posts').insert({
      'user_id': userId,
      'caption': caption,
      'media_urls': mediaUrls,
      'type': type,
    }).select().single();

    // Step 2: Fetch user profile
    final profileRes = await client
        .from('profiles')
        .select('user_name, avatar_url')
        .eq('id', userId)
        .single();

    final postJson = {
      ...postRes,
      'username': profileRes['user_name'],
      'avatar_url': profileRes['avatar_url'],
      'media_url': mediaUrls.isNotEmpty ? mediaUrls.first : '',
      'is_video': type == 'video',
    };

    return PostModel.fromJson(postJson);
  }

  /// Upload a file (image or video) to Supabase storage
  @override
  Future<String?> uploadMediaToSupabase(XFile file, {required bool isVideo}) async {
    final storage = Supabase.instance.client.storage;
    final folder = isVideo ? 'videos' : 'images';
    final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.name}';

    try {
      final Uint8List bytes = await file.readAsBytes();
      await storage.from('posts_bucket').uploadBinary(
        '$folder/$fileName',
        bytes,
        fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
      );

      final url = storage.from('posts_bucket').getPublicUrl('$folder/$fileName');
      return url;
    } catch (e) {
      print('Upload error: $e');
      return null;
    }
  }

  Future<void> deletePost(String postId) async {
    final supabase = Supabase.instance.client;

    final res = await supabase.from('posts').delete().eq('id', postId);

    if (res == null || (res is List && res.isEmpty)) {
      throw Exception("Delete failed: no rows affected");
    }
  }

// @override
  // Future<void> deletePost(String postId) async {
  //   final supabase = Supabase.instance.client;
  //
  //   final response = await supabase
  //       .from('posts')
  //       .delete()
  //       .eq('id', postId);
  //
  //   // Check for error
  //   if (response.error != null) {
  //     throw Exception(response.error!.message);
  //   }
  // }

}