// // import 'dart:io';
// // import 'package:supabase_flutter/supabase_flutter.dart';
// // import '../models/profile_model.dart';
// //
// // class ProfileRemoteDataSource {
// //   final SupabaseClient supa;
// //
// //   ProfileRemoteDataSource(this.supa);
// //
// //   Future<ProfileModel> fetchProfile(String id) async {
// //     final res = await supa.from('profiles').select().eq('id', id).single();
// //     return ProfileModel(
// //       id: res['id'],
// //       name: res['name'] ?? '',
// //       username: res['username'] ?? '',
// //       bio: res['bio'] ?? '',
// //       avatarUrl: res['avatar_url'],
// //       phone: res['phone'],
// //       address: res['address'],
// //       age: res['age'],
// //       gender: res['gender'],
// //     );
// //   }
// //
// //   Future<ProfileModel> updateProfile(ProfileModel model) async {
// //     final res = await supa.from('profiles').upsert({
// //       'id': model.id,
// //       'name': model.name,
// //       'username': model.username,
// //       'bio': model.bio,
// //       'avatar_url': model.avatarUrl,
// //       'phone': model.phone,
// //       'address': model.address,
// //       'age': model.age,
// //       'gender': model.gender,
// //     }).select().single();
// //
// //     return ProfileModel(
// //       id: res['id'],
// //       name: res['name'] ?? '',
// //       username: res['username'] ?? '',
// //       bio: res['bio'] ?? '',
// //       avatarUrl: res['avatar_url'],
// //       phone: res['phone'],
// //       address: res['address'],
// //       age: res['age'],
// //       gender: res['gender'],
// //     );
// //   }
// //
// //   Future<String> uploadAvatar(String userId, String filePath) async {
// //     final bytes = await File(filePath).readAsBytes();
// //     final fileName = 'avatars/$userId-${DateTime.now().millisecondsSinceEpoch}.jpg';
// //     await supa.storage.from('public').uploadBinary(fileName, bytes, fileOptions: const FileOptions(upsert: true));
// //     return supa.storage.from('public').getPublicUrl(fileName);
// //   }
// // }
// import 'dart:io';
// import 'package:flutter/cupertino.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../models/profile_model.dart';
//
// class ProfileRemoteDataSource {
//   final SupabaseClient client;
//   ProfileRemoteDataSource(this.client);
//
//   /// Fetch a user profile by ID
//   Future<ProfileModel?> fetchProfile(String userId) async {
//     try {
//       final response = await client
//           .from('user_profiles')
//           .select()
//           .eq('id', userId)
//           .maybeSingle();
//
//       if (response == null) return null;
//       return ProfileModel.fromJson(response);
//     } catch (e) {
//       throw Exception('Failed to fetch user_profiles: $e');
//     }
//   }
//
//   /// Update an existing profile or insert if not exists
//   // Future<ProfileModel> updateProfile(ProfileModel model) async {
//   //   try {
//   //     // final response = await client
//   //     //     .from('user_profiles')
//   //     //     .upsert(model.toJson())
//   //     //     .select()
//   //     //     .single();
//   //    final response = await client
//   //         .from('user_profiles')
//   //         .upsert(model.toJson(), onConflict: 'id')
//   //         .select()
//   //         .single();
//   //
//   //
//   //     return ProfileModel.fromJson(response);
//   //   } catch (e) {
//   //     throw Exception('Failed to update profile: $e');
//   //   }
//   // }
//   Future<ProfileModel> updateProfile(ProfileModel model) async {
//     if (model.id.isEmpty) throw Exception('User ID is required');
//
//     try {
//       final response = await client
//           .from('user_profiles')
//           .upsert(model.toJson(), onConflict: 'id')
//           .select()
//           .single();
//
//       return ProfileModel.fromJson(response);
//     } catch (e) {
//       debugPrint('❌ Failed to update profile: $e');
//       throw Exception('Failed to update profile: $e');
//     }
//   }
//
//   /// Upload avatar and return the public URL
//   Future<String> uploadAvatar(String userId, String filePath) async {
//     try {
//       // Ensure user exists
//       final user = client.auth.currentUser;
//       if (user == null) throw Exception("User not signed in");
//
//       // Read file bytes
//       final bytes = await File(filePath).readAsBytes();
//
//       // Create a unique filename
//       final fileName = '$userId/avatar_${DateTime.now().millisecondsSinceEpoch}.png';
//
//       // Upload the file
//       await client.storage.from('avatars').uploadBinary(
//         fileName,
//         bytes,
//         fileOptions: const FileOptions(upsert: true),
//       );
//
//       // Get public URL
//       final url = client.storage.from('avatars').getPublicUrl(fileName);
//
//       debugPrint('✅ Avatar uploaded: $url');
//
//       return url;
//     } catch (e) {
//       debugPrint('❌ Failed to upload avatar: $e');
//       throw Exception('Failed to upload avatar: $e');
//     }
//   }
// }
//
// lib/features/profile/data/datasource/profile_remote_data_source.dart

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile_model.dart';

class ProfileRemoteDataSource {
  final SupabaseClient client;
  ProfileRemoteDataSource(this.client);

  /// Fetch a profile row from 'profiles' table. Returns null if not found.
  Future<ProfileModel?> fetchProfile(String userId) async {
    try {
      final response = await client
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response == null) return null;

      // ensure Map<String, dynamic>
      final map = Map<String, dynamic>.from(response as Map);
      return ProfileModel.fromJson(map);
    } catch (e) {
      debugPrint('fetchProfile error: $e');
      rethrow;
    }
  }

  /// Upsert profile row, return the updated ProfileModel
  Future<ProfileModel> updateProfile(ProfileModel model) async {
    try {
      final response = await client
          .from('profiles')
          .upsert(model.toJson(), onConflict: 'id')
          .select()
          .single();

      final map = Map<String, dynamic>.from(response as Map);
      return ProfileModel.fromJson(map);
    } catch (e) {
      debugPrint('updateProfile error: $e');
      rethrow;
    }
  }

  /// Upload avatar to 'avatars' bucket and return public URL
  Future<String> uploadAvatar(String userId, String filePath) async {
    try {
      final bytes = await File(filePath).readAsBytes();
      final fileName = '$userId/avatar_${DateTime.now().millisecondsSinceEpoch}.png';

      // upload to bucket 'avatars' (make sure it exists and has public access or set correct policies)
      await client.storage.from('avatars').uploadBinary(
        fileName,
        bytes,
        fileOptions: const FileOptions(upsert: true),
      );

      final url = client.storage.from('avatars').getPublicUrl(fileName);
      // getPublicUrl returns a string in the current client libs — if your version wraps result adjust accordingly
      return url;
    } catch (e) {
      debugPrint('uploadAvatar error: $e');
      rethrow;
    }
  }
}

