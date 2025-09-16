import '../../../../core/errors/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../entity/socila_profile_entity.dart';

abstract class SocialProfileRepository {
  Future<Either<Failure, SocialProfileEntity>> getSocialProfile();
}
