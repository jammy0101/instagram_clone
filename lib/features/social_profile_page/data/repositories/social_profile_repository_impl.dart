
import '../../../../core/errors/failure.dart';
import '../../domain/entity/socila_profile_entity.dart';
import '../../domain/repositories/socila_profile_repository.dart';
import '../datasource/social_profile_remote_datasource.dart';
import '../model/social_profile_model.dart';
import 'package:hive/hive.dart';
import 'dart:convert';
import 'package:fpdart/fpdart.dart';

class SocialProfileRepositoryImpl implements SocialProfileRepository {
  final SocialProfileRemoteDataSource remote;
  final Box<String> cacheBox;

  SocialProfileRepositoryImpl({required this.remote, required this.cacheBox});

  @override
  Future<Either<Failure, SocialProfileEntity>> getSocialProfile() async {
    try {
      final SocialProfileModel model = await remote.fetchSocialProfile();

      await cacheBox.put('cached_social_profile', jsonEncode(model.toMap()));

      return Right(model);
    } catch (e) {
      final cached = cacheBox.get('cached_social_profile');
      if (cached != null) {
        final map = jsonDecode(cached) as Map<String, dynamic>;
        return Right(SocialProfileModel.fromMap(map));
      }
      return Left(Failure(e.toString()));
    }
  }
}
