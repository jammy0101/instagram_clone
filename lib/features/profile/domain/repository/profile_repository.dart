// import '../entities/profile_entity.dart';
//
// abstract class ProfileRepository {
//   Future<Profile> getProfile(String id);
//   Future<Profile> updateProfile(Profile profile);
//   Future<String> uploadAvatar(String userId, String filePath);
// }
import '../entities/profile_entity.dart';

abstract class ProfileRepository {
  /// Fetch profile by user ID.
  /// Falls back to local cache if remote fails.
  Future<Profile> getProfile(String id);

  /// Update profile both remotely and locally.
  Future<Profile> updateProfile(Profile profile);

  /// Upload avatar image to Supabase storage.
  /// Returns the public URL of the uploaded avatar.
  Future<String> uploadAvatar(String userId, String filePath);
}
