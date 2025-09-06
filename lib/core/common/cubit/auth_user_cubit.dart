import 'package:bloc/bloc.dart';

import 'package:meta/meta.dart';

import '../../entities/user.dart';

part 'auth_user_state.dart';

class AuthUserCubit extends Cubit<AuthUserState> {
  AuthUserCubit() : super(AuthUserInitial());

  void updateUser(User? user){
    if(user == null){
      emit(AuthUserInitial());
    }else{
      emit(AuthUserLoggedIn(user));
    }
  }
  void logout() => emit(AuthUserInitial());
}
