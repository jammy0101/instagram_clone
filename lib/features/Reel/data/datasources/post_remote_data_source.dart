//
// // lib/features/feed/data/datasources/post_remote_data_source.dart
// import 'dart:typed_data';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../../../Reel/data/models/post_model.dart';
// import 'package:image_picker/image_picker.dart';
//
// abstract class PostRemoteDataSource {
//   Future<List<PostModel>> fetchFeed({int limit = 10, String? beforeCreatedAt});
//   Future<void> likePost(String postId, String userId);
//   Future<void> unlikePost(String postId, String userId);
//   Future<void> addComment(String postId, String userId, String text);
//   Future<void> savePost(String postId, String userId);
//   Future<void> unsavePost(String postId, String userId);
//
//   /// Domain-level create: accept media URLs (strings) and a type.
//   Future<PostModel> createPost({
//     required String userId,
//     required String caption,
//     required List<String> mediaUrls,
//     required String type,
//   });
//
//   /// Helper: upload a file and get a public URL (UI / caller may call this repeatedly).
//   Future<String?> uploadMediaToSupabase(XFile file, {required bool isVideo});
// }
//
// class PostRemoteDataSourceImpl implements PostRemoteDataSource {
//   final SupabaseClient client;
//   PostRemoteDataSourceImpl(this.client);
//
//   @override
//   Future<List<PostModel>> fetchFeed({int limit = 10, String? beforeCreatedAt}) async {
//     var query = client
//         .from('posts')
//         .select('*, profiles:profiles(id, user_name, avatar_url), post_media:post_media(id, media_url, media_type)')
//         .order('created_at', ascending: false)
//         .limit(limit);
//
//     if (beforeCreatedAt != null) {
//       query = client
//           .from('posts')
//           .select('*, profiles:profiles(id, user_name, avatar_url), post_media:post_media(id, media_url, media_type)')
//           .lt('created_at', beforeCreatedAt)
//           .order('created_at', ascending: false)
//           .limit(limit);
//     }
//
//     final res = await query;
//     final list = (res as List).map((json) {
//       final Map<String, dynamic> postJson = Map<String, dynamic>.from(json);
//
//       // attach profile fields
//       if (json['profiles'] != null) {
//         postJson['username'] = json['profiles']['user_name'];
//         postJson['avatar_url'] = json['profiles']['avatar_url'];
//       }
//
//       // normalize post_media -> media_urls + primary media_url/is_video
//       if (json['post_media'] != null) {
//         final media = List<Map<String, dynamic>>.from(json['post_media']);
//         postJson['media_urls'] = media.map((m) => m['media_url'] as String).toList();
//         if (media.isNotEmpty) {
//           postJson['media_url'] = media.first['media_url'] as String;
//           postJson['is_video'] = (media.first['media_type'] as String) == 'video';
//         } else {
//           postJson['media_url'] = '';
//           postJson['is_video'] = false;
//         }
//       } else {
//         postJson['media_urls'] = <String>[];
//         postJson['media_url'] = '';
//         postJson['is_video'] = false;
//       }
//
//       return PostModel.fromJson(postJson);
//     }).toList();
//
//     return list;
//   }
//
//   @override
//   Future<void> likePost(String postId, String userId) async {
//     try {
//       await client.from('likes').insert({'post_id': postId, 'user_id': userId});
//     } catch (e) {
//       if (!e.toString().contains('duplicate key')) rethrow;
//     }
//   }
//
//   @override
//   Future<void> unlikePost(String postId, String userId) async {
//     await client.from('likes').delete().match({'post_id': postId, 'user_id': userId});
//   }
//
//   @override
//   Future<void> addComment(String postId, String userId, String text) async {
//     await client.from('comments').insert({
//       'post_id': postId,
//       'user_id': userId,
//       'content': text,
//     });
//   }
//
//   @override
//   Future<void> savePost(String postId, String userId) async {
//     try {
//       await client.from('saves').insert({'post_id': postId, 'user_id': userId});
//     } catch (e) {
//       if (!e.toString().contains('duplicate key')) rethrow;
//     }
//   }
//
//   @override
//   Future<void> unsavePost(String postId, String userId) async {
//     await client.from('saves').delete().match({'post_id': postId, 'user_id': userId});
//   }
//
//   /// createPost expects you to pass already-uploaded media URLs (List<String>)
//   @override
//   Future<PostModel> createPost({
//     required String userId,
//     required String caption,
//     required List<String> mediaUrls,
//     required String type,
//   }) async {
//     // Step 1: Create post row
//     final postRes = await client.from('posts').insert({
//       'user_id': userId,
//       'caption': caption,
//       'type': type,
//     }).select().single();
//
//     final String postId = postRes['id'] as String;
//
//     // Step 2: Insert post_media rows (if any)
//     for (final url in mediaUrls) {
//       // Infer media_type by file extension (basic)
//       final isVideo = url.toLowerCase().endsWith('.mp4') || url.toLowerCase().endsWith('.mov') || url.toLowerCase().contains('video');
//       await client.from('post_media').insert({
//         'post_id': postId,
//         'media_url': url,
//         'media_type': isVideo ? 'video' : 'image',
//       });
//     }
//
//     // Step 3: Fetch the full post with media + profile
//     final res = await client
//         .from('posts')
//         .select('*, profiles:profiles(id, user_name, avatar_url), post_media:post_media(id, media_url, media_type)')
//         .eq('id', postId)
//         .single();
//
//     final Map<String, dynamic> postJson = Map<String, dynamic>.from(res);
//     if (res['profiles'] != null) {
//       postJson['username'] = res['profiles']['user_name'];
//       postJson['avatar_url'] = res['profiles']['avatar_url'];
//     }
//     if (res['post_media'] != null) {
//       final media = List<Map<String, dynamic>>.from(res['post_media']);
//       postJson['media_urls'] = media.map((m) => m['media_url'] as String).toList();
//       if (media.isNotEmpty) {
//         postJson['media_url'] = media.first['media_url'] as String;
//         postJson['is_video'] = (media.first['media_type'] as String) == 'video';
//       } else {
//         postJson['media_url'] = '';
//         postJson['is_video'] = false;
//       }
//     } else {
//       postJson['media_urls'] = <String>[];
//       postJson['media_url'] = '';
//       postJson['is_video'] = false;
//     }
//
//     return PostModel.fromJson(postJson);
//   }
//
//   /// convenience uploader: UI can call this per XFile, get URL, then call createPost with all URLs
//   @override
//   Future<String?> uploadMediaToSupabase(XFile file, {required bool isVideo}) async {
//     final storage = Supabase.instance.client.storage;
//     final folder = isVideo ? 'videos' : 'images';
//     final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.name}';
//
//     try {
//       final Uint8List bytes = await file.readAsBytes();
//       // uploadBinary is available in newer supabase-dart clients; if not, change to upload()
//       await storage.from('posts_bucket').uploadBinary(
//         '$folder/$fileName',
//         bytes,
//         fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
//       );
//
//       final url = storage.from('posts_bucket').getPublicUrl('$folder/$fileName');
//       return url;
//     } catch (e) {
//       // log and return null on failure
//       print('Upload error: $e');
//       return null;
//     }
//   }
// }
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
    // var query = client
    //     .from('posts')
    //     .select('*, profiles!inner(user_name, avatar_url)')
    //     .order('created_at', ascending: false)
    //     .limit(limit);
    //
    // if (beforeCreatedAt != null) {
    //   query = query.lt('created_at', beforeCreatedAt);
    // }
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

  @override
  Future<void> deletePost(String postId) async {
    final supabase = Supabase.instance.client;

    final response = await supabase
        .from('posts')
        .delete()
        .eq('id', postId);

    // Check for error
    if (response.error != null) {
      throw Exception(response.error!.message);
    }
  }

}
