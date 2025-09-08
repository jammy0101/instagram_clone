import '../repository/profile_repository.dart';

class UploadAvatar {
  final ProfileRepository repo;
  UploadAvatar(this.repo);

  Future<String> call(String userId, String filePath) async =>
      await repo.uploadAvatar(userId, filePath);
}
