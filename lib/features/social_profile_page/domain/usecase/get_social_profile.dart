
import '../../../../core/errors/failure.dart';
import '../entity/socila_profile_entity.dart';
import '../repositories/socila_profile_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetSocialProfile {
  final SocialProfileRepository repository;
  GetSocialProfile(this.repository);

  Future<Either<Failure, SocialProfileEntity>> call() async {
    return await repository.getSocialProfile();
  }
}
