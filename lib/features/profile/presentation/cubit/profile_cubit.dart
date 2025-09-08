// import 'package:bloc/bloc.dart';
// import 'package:meta/meta.dart';
//
// part 'profile_state.dart';
//
// class ProfileCubit extends Cubit<ProfileState> {
//   ProfileCubit() : super(ProfileInitial());
// }
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/usecase/get_profile.dart';
import '../../domain/usecase/update_profile.dart';
import '../../domain/usecase/upload_avatar.dart';

class ProfileState {
  final Profile? profile;
  final bool loading;
  final String? error;

  ProfileState({this.profile, this.loading = false, this.error});

  ProfileState copyWith({Profile? profile, bool? loading, String? error}) {
    return ProfileState(
      profile: profile ?? this.profile,
      loading: loading ?? this.loading,
      error: error,
    );
  }
}

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfile getProfile;
  final UpdateProfile updateProfile;
  final UploadAvatar uploadAvatar;

  ProfileCubit({
    required this.getProfile,
    required this.updateProfile,
    required this.uploadAvatar,
  }) : super(ProfileState());

  Future<void> loadProfile(String id) async {
    emit(state.copyWith(loading: true));
    try {
      final profile = await getProfile(id);
      emit(ProfileState(profile: profile));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> saveProfile(Profile profile) async {
    emit(state.copyWith(loading: true));
    try {
      final updated = await updateProfile(profile);
      emit(ProfileState(profile: updated));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> changeAvatar(String userId, String filePath) async {
    try {
      final url = await uploadAvatar(userId, filePath);
      final newProfile = state.profile?.copyWith(avatarUrl: url);
      if (newProfile != null) {
        await saveProfile(newProfile);
      }
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
