import 'package:bloc/bloc.dart';
import '../../domain/usecase/get_social_profile.dart';
import 'social_profile_event.dart';
import 'social_profile_state.dart';

class SocialProfileBloc extends Bloc<SocialProfileEvent, SocialProfileState> {
  final GetSocialProfile getSocialProfile;

  SocialProfileBloc({required this.getSocialProfile})
      : super(SocialProfileInitial()) {
    on<LoadSocialProfileEvent>((event, emit) async {
      emit(SocialProfileLoading());
      final res = await getSocialProfile();
      res.fold(
            (failure) => emit(SocialProfileError(failure.message)),
            (profile) => emit(SocialProfileLoaded(profile)),
      );
    });
  }
}
