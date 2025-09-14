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
// lib/features/profile/data/repositories/profile_repository_impl.dart

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
  Future<Profile?> getProfile(String id) async {
    try {
      final remoteModel = await remote.fetchProfile(id);

      if (remoteModel != null) {
        await local.cacheProfile(remoteModel);
        return remoteModel.toEntity();
      } else {
        final cached = local.getCachedProfile(id);
        if (cached != null) return cached.toEntity();
        return null;
      }
    } catch (e) {
      // remote failed -> try cache
      final cached = local.getCachedProfile(id);
      if (cached != null) return cached.toEntity();
      rethrow;
    }
  }

  @override
  Future<Profile> updateProfile(Profile profile) async {
    final model = ProfileModel.fromEntity(profile);

    try {
      final updated = await remote.updateProfile(model);
      await local.cacheProfile(updated);
      return updated.toEntity();
    } catch (e) {
      // fallback: save locally and return
      await local.cacheProfile(model);
      return model.toEntity();
    }
  }

  @override
  Future<String> uploadAvatar(String userId, String filePath) async {
    final url = await remote.uploadAvatar(userId, filePath);

    // update cached/remote profile's avatar_url
    final current = await getProfile(userId);
    if (current != null) {
      final updated = current.copyWith(avatarUrl: url);
      await updateProfile(updated);
    }
    return url;
  }
}
