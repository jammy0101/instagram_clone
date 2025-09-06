
import 'package:fpdart/fpdart.dart';
import '../../../../core/entities/user.dart';
import '../../../../core/errors/failure.dart';

//this is just an interface
// AuthRepository (domain contract)
// Says what the app can do: "sign up", "login".
// Doesn’t know about Supabase.
// Just an interface/contract.
abstract interface class AuthRepository{

  Future<Either<Failure,User>>  signUpWithEmailPassword({
    required String fullName,
    required String email,
    required String password,
    required String userName,
});

  Future<Either<Failure,User>>  loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure,User>> currentUser();

  Future<Either<Failure,void>> logout();
}