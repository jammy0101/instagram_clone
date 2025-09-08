// import '../../domain/entities/profile_entity.dart';
// import '../../domain/repository/profile_repository.dart';
// import '../datasource/profile_local_data_source.dart';
// import '../datasource/profile_remote_data_source.dart';
// import '../models/profile_model.dart';
//
// class ProfileRepositoryImpl implements ProfileRepository {
//   final ProfileRemoteDataSource remote;
//   final ProfileLocalDataSource local;
//
//   ProfileRepositoryImpl({required this.remote, required this.local});
//
//   @override
//   Future<Profile> getProfile(String id) async {
//     try {
//       final remoteModel = await remote.fetchProfile(id);
//       await local.cacheProfile(remoteModel);
//       return remoteModel.toEntity();
//     } catch (e) {
//       final cached = local.getCachedProfile(id);
//       if (cached != null) return cached.toEntity();
//       rethrow;
//     }
//   }
//
//   @override
//   Future<Profile> updateProfile(Profile profile) async {
//     final model = ProfileModel.fromEntity(profile);
//     final updated = await remote.updateProfile(model);
//     await local.cacheProfile(updated);
//     return updated.toEntity();
//   }
//
//   @override
//   Future<String> uploadAvatar(String userId, String filePath) async {
//     return await remote.uploadAvatar(userId, filePath);
//   }
// }
import '../../domain/entities/profile_entity.dart';
import '../../domain/repository/profile_repository.dart';
import '../datasource/profile_local_data_source.dart';
import '../datasource/profile_remote_data_source.dart';
import '../models/profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remote;
  final ProfileLocalDataSource local;

  ProfileRepositoryImpl({
    required this.remote,
    required this.local,
  });

  @override
  Future<Profile> getProfile(String id) async {
    try {
      final remoteModel = await remote.fetchProfile(id);

      if (remoteModel != null) {
        // ✅ cache fresh remote profile
        await local.cacheProfile(remoteModel);
        return remoteModel.toEntity();
      } else {
        // ✅ fallback to cache
        final cached = local.getCachedProfile(id);
        if (cached != null) return cached.toEntity();
        throw Exception('Profile not found remotely or in cache');
      }
    } catch (e) {
      // ✅ if remote fails, try local cache
      final cached = local.getCachedProfile(id);
      if (cached != null) return cached.toEntity();
      rethrow; // bubble up if nothing works
    }
  }

  @override
  Future<Profile> updateProfile(Profile profile) async {
    final model = ProfileModel.fromEntity(profile);

    try {
      final updated = await remote.updateProfile(model);
      await local.cacheProfile(updated); // ✅ keep cache in sync
      return updated.toEntity();
    } catch (e) {
      // ✅ if remote fails, at least update local cache
      await local.cacheProfile(model);
      return model.toEntity();
    }
  }

  @override
  Future<String> uploadAvatar(String userId, String filePath) async {
    try {
      final url = await remote.uploadAvatar(userId, filePath);

      // ✅ update profile with new avatar
      final profile = await getProfile(userId);
      final updatedProfile = profile.copyWith(avatarUrl: url);
      await updateProfile(updatedProfile);

      return url;
    } catch (e) {
      throw Exception('Failed to upload avatar: $e');
    }
  }
}
