

import '../../domain/entity/socila_profile_entity.dart';

abstract class SocialProfileState {}

class SocialProfileInitial extends SocialProfileState {}

class SocialProfileLoading extends SocialProfileState {}

class SocialProfileLoaded extends SocialProfileState {
  final SocialProfileEntity profile;
  SocialProfileLoaded(this.profile);
}

class SocialProfileError extends SocialProfileState {
  final String message;
  SocialProfileError(this.message);
}
