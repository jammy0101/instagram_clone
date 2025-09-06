
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/cubit/auth_user_cubit.dart';
import '../../../../core/entities/user.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/usecases/current_user.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/user_login.dart';
import '../../domain/usecases/user_sign_up.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  final CurrentUser _currentUser;
  final AuthUserCubit _authUserCubit;
  final Logout _logout;

  AuthBloc({
    required UserSignUp userSignUp,
    required UserLogin userLogin,
    required CurrentUser currentUser,
    required AuthUserCubit authUserCubit,
    required Logout logout,
  }) : _userSignUp = userSignUp,
       _userLogin = userLogin,
       _currentUser = currentUser,
        _logout = logout,
  _authUserCubit = authUserCubit,
       super(AuthInitial()) {
    on<AuthEvent>((_,emit) => emit(AuthLoading()));
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
    on<AuthIsUserLoggedIn>(_isUserLoggedIn);
    on<AuthLogout>(_onAuthLogout);
  }

  void _onAuthLogout(AuthLogout event,Emitter<AuthState> emit)async{
    emit(AuthLoading());
    final res = await _logout(NoParams());
    res.fold(
          (failure) => emit(AuthFailure(failure.message)),
          (_) {
        _authUserCubit.logout();
        emit(AuthLoggedOut());
      },
    );
  }

  //for sign UP
  void _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    //here i will use the usecase
    final res = await _userSignUp(
      UserSignUpParams(
        email: event.email,
        password: event.password,
        fullName: event.fullName,
        userName: event.userName,
      ),
    );

    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) =>  _emitAuthSuccess(user,emit),
    );
  }

  //for Current User that is Login or Not
  void _isUserLoggedIn(AuthIsUserLoggedIn event, Emitter<AuthState> emit,) async {
    //here i will use the usecase
    final res = await _currentUser(NoParams());

    res.fold(
      (failure) => emit(AuthFailure(failure.message)),

      (user) =>  _emitAuthSuccess(user,emit),

    );
  }

  //for checking current session
  void _emitAuthSuccess(User user,Emitter<AuthState> emit)async{
    _authUserCubit.updateUser(user);
    emit(AuthSuccess(user));
  }


// for Login purpose
  void _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    //here i will use the usecase
    final res = await _userLogin(
      UserLoginParams(
          email: event.email,
          password: event.password
      ),
    );

    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _emitAuthSuccess(user,emit),
    );
  }

}
