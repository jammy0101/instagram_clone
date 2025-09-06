part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthSignUp extends AuthEvent {
  final String email;
  final String password;
  final String fullName;
  final String userName;

  AuthSignUp({
    required this.email,
    required this.password,
    required this.fullName,
    required this.userName,
  });
}

final class AuthLogin extends AuthEvent {
  final String email;
  final String password;

  AuthLogin({required this.email, required this.password});
}

class AuthLogout extends AuthEvent {}

final class AuthIsUserLoggedIn extends AuthEvent {}
