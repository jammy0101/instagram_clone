// import '../entities/profile_entity.dart';
// import '../repository/profile_repository.dart';
//
// class UpdateProfile {
//   final ProfileRepository repo;
//   UpdateProfile(this.repo);
//
//   Future<Profile> call(Profile profile) async => await repo.updateProfile(profile);
// }
import '../entities/profile_entity.dart';
import '../repository/profile_repository.dart';

class UpdateProfile {
  final ProfileRepository repo;
  UpdateProfile(this.repo);

  Future<Profile> call(Profile profile) => repo.updateProfile(profile);
}
