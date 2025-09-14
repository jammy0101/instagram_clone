// import '../entities/profile_entity.dart';
// import '../repository/profile_repository.dart';
//
// class GetProfile {
//   final ProfileRepository repo;
//   GetProfile(this.repo);
//
//   Future<Profile> call(String id) async => await repo.getProfile(id);
// }
import '../entities/profile_entity.dart';
import '../repository/profile_repository.dart';

class GetProfile {
  final ProfileRepository repo;
  GetProfile(this.repo);

  Future<Profile?> call(String id) => repo.getProfile(id);
}


