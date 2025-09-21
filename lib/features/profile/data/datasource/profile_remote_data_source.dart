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