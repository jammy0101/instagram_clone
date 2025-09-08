// import 'dart:io';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../models/profile_model.dart';
//
// class ProfileRemoteDataSource {
//   final SupabaseClient supa;
//
//   ProfileRemoteDataSource(this.supa);
//
//   Future<ProfileModel> fetchProfile(String id) async {
//     final res = await supa.from('profiles').select().eq('id', id).single();
//     return ProfileModel(
//       id: res['id'],
//       name: res['name'] ?? '',
//       username: res['username'] ?? '',
//       bio: res['bio'] ?? '',
//       avatarUrl: res['avatar_url'],
//       phone: res['phone'],
//       address: res['address'],
//       age: res['age'],
//       gender: res['gender'],
//     );
//   }
//
//   Future<ProfileModel> updateProfile(ProfileModel model) async {
//     final res = await supa.from('profiles').upsert({
//       'id': model.id,
//       'name': model.name,
//       'username': model.username,
//       'bio': model.bio,
//       'avatar_url': model.avatarUrl,
//       'phone': model.phone,
//       'address': model.address,
//       'age': model.age,
//       'gender': model.gender,
//     }).select().single();
//
//     return ProfileModel(
//       id: res['id'],
//       name: res['name'] ?? '',
//       username: res['username'] ?? '',
//       bio: res['bio'] ?? '',
//       avatarUrl: res['avatar_url'],
//       phone: res['phone'],
//       address: res['address'],
//       age: res['age'],
//       gender: res['gender'],
//     );
//   }
//
//   Future<String> uploadAvatar(String userId, String filePath) async {
//     final bytes = await File(filePath).readAsBytes();
//     final fileName = 'avatars/$userId-${DateTime.now().millisecondsSinceEpoch}.jpg';
//     await supa.storage.from('public').uploadBinary(fileName, bytes, fileOptions: const FileOptions(upsert: true));
//     return supa.storage.from('public').getPublicUrl(fileName);
//   }
// }
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile_model.dart';

class ProfileRemoteDataSource {
  final SupabaseClient client;
  ProfileRemoteDataSource(this.client);

  /// Fetch a user profile by ID
  Future<ProfileModel?> fetchProfile(String userId) async {
    try {
      final response = await client
          .from('user_profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response == null) return null;
      return ProfileModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch user_profiles: $e');
    }
  }

  /// Update an existing profile or insert if not exists
  // Future<ProfileModel> updateProfile(ProfileModel model) async {
  //   try {
  //     // final response = await client
  //     //     .from('user_profiles')
  //     //     .upsert(model.toJson())
  //     //     .select()
  //     //     .single();
  //    final response = await client
  //         .from('user_profiles')
  //         .upsert(model.toJson(), onConflict: 'id')
  //         .select()
  //         .single();
  //
  //
  //     return ProfileModel.fromJson(response);
  //   } catch (e) {
  //     throw Exception('Failed to update profile: $e');
  //   }
  // }
  Future<ProfileModel> updateProfile(ProfileModel model) async {
    if (model.id.isEmpty) throw Exception('User ID is required');

    try {
      final response = await client
          .from('user_profiles')
          .upsert(model.toJson(), onConflict: 'id')
          .select()
          .single();

      return ProfileModel.fromJson(response);
    } catch (e) {
      debugPrint('❌ Failed to update profile: $e');
      throw Exception('Failed to update profile: $e');
    }
  }


  /// Upload an avatar to Supabase Storage and return the public URL
  Future<String> uploadAvatar(String userId, String filePath) async {
    try {
      final fileName = '$userId-avatar.png';

      // await client.storage.from('avatars').upload(
      //   fileName,
      //   File(filePath),
      //   fileOptions: const FileOptions(upsert: true), // overwrite if exists
      // );
      final bytes = await File(filePath).readAsBytes();
      await client.storage.from('avatars').uploadBinary(
        fileName,
        bytes,
        fileOptions: const FileOptions(upsert: true),
      );
      print("Picked file: $filePath, exists: ${File(filePath).existsSync()}");

      final url = client.storage.from('avatars').getPublicUrl(fileName);
      print("Picked file: $filePath, exists: ${File(filePath).existsSync()}");

      return url;
    } catch (e) {
      throw Exception('Failed to upload avatar: $e');
    }
  }


}
