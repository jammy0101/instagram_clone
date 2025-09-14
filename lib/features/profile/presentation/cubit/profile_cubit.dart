//
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../domain/entities/profile_entity.dart';
// import '../../domain/usecase/get_profile.dart';
// import '../../domain/usecase/update_profile.dart';
// import '../../domain/usecase/upload_avatar.dart';
//
// class ProfileState {
//   final Profile? profile;
//   final bool loading;
//   final String? error;
//
//   ProfileState({this.profile, this.loading = false, this.error});
//
//   ProfileState copyWith({Profile? profile, bool? loading, String? error}) {
//     return ProfileState(
//       profile: profile ?? this.profile,
//       loading: loading ?? this.loading,
//       error: error,
//     );
//   }
// }
//
// class ProfileCubit extends Cubit<ProfileState> {
//   final GetProfile getProfile;
//   final UpdateProfile updateProfile;
//   final UploadAvatar uploadAvatar;
//
//   ProfileCubit({
//     required this.getProfile,
//     required this.updateProfile,
//     required this.uploadAvatar,
//   }) : super(ProfileState());
//   Future<void> loadProfile(String id) async {
//     emit(state.copyWith(loading: true, error: null));
//     try {
//       final profile = await getProfile(id);
//       if (profile == null) {
//         emit(state.copyWith(
//           loading: false,
//           error: "Profile not found remotely or in cache",
//         ));
//       } else {
//         emit(state.copyWith(profile: profile, loading: false));
//       }
//     } catch (e) {
//       emit(state.copyWith(error: e.toString(), loading: false));
//     }
//   }
//
//
//   Future<void> saveProfile(Profile profile) async {
//     emit(state.copyWith(loading: true));
//     try {
//       final updated = await updateProfile(profile);
//       emit(ProfileState(profile: updated));
//     } catch (e) {
//       emit(state.copyWith(error: e.toString()));
//     }
//   }
//
//   Future<void> changeAvatar(String userId, String filePath) async {
//     try {
//       final url = await uploadAvatar(userId, filePath);
//       final newProfile = state.profile?.copyWith(avatarUrl: url);
//       if (newProfile != null) {
//         await saveProfile(newProfile);
//       }
//     } catch (e) {
//       emit(state.copyWith(error: e.toString()));
//     }
//   }
// }
// lib/features/profile/presentation/cubit/profile_cubit.dart

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

  ProfileState copyWith({Profile? profile, bool? loading, String? error}) =>
      ProfileState(
        profile: profile ?? this.profile,
        loading: loading ?? this.loading,
        error: error,
      );
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
    emit(state.copyWith(loading: true, error: null));
    try {
      final profile = await getProfile(id);
      if (profile == null) {
        emit(state.copyWith(loading: false, error: 'Profile not found'));
      } else {
        emit(state.copyWith(profile: profile, loading: false));
      }
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> saveProfile(Profile profile) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final updated = await updateProfile(profile);
      emit(state.copyWith(profile: updated, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> changeAvatar(String userId, String filePath) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final url = await uploadAvatar(userId, filePath);
      final newProfile = state.profile?.copyWith(avatarUrl: url);
      if (newProfile != null) await saveProfile(newProfile);
      emit(state.copyWith(loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
}
