//this is the Implementation
// AuthRepositoryImpl (data repository)
// Uses AuthRemoteDataSource.
// Handles exceptions.
// Returns clean result (Either<Failure, Success>).
//this is the actual implementation
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import '../../../../core/constants/constants.dart';
import '../../../../core/entities/user.dart';
import '../../../../core/errors/exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/connection_checker.dart';
import '../../domain/repository/auth_repository.dart';
import '../data_source/auth_remote_data_source.dart';
import '../models/user_model.dart';

// An interface defines a contract (what methods must exist) but does not provide the actual implementation.
// Classes that implement the interface provide the real logic.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final ConnectionChecker connectionChecker;
  AuthRepositoryImpl(this.remoteDataSource, this.connectionChecker);

  @override
  Future<Either<Failure, User>> currentUser() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        final session = remoteDataSource.currentUserSession;

        if (session == null) {
          return left(Failure('User not logged in'));
        }

        return right(
          UserModel(
            id: session.user.id,
            email: session.user.email ?? '',
            fullName: '',
            userName: '',
            password: '',
          ),
        );
      }
      final user = await remoteDataSource.getCurrentUserData();
      if (user == null) {
        return left(Failure('User not logged in'));
      }
      return right(user);
    } on sb.AuthException catch (e) {
      return left(Failure(e.message));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await remoteDataSource.loginWithEmailPassword(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String fullName,
    required String email,
    required String password,
    required String userName,
  }) async {
    return _getUser(
      () async => await remoteDataSource.signUpWithEmailPassword(
        fullName: fullName,
        email: email,
        password: password,
        userName: userName,
      ),
    );
  }

  Future<Either<Failure, User>> _getUser(Future<User> Function() fn) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure(Constants.noConnectionErrorMessage));
      }
      final user = await fn();

      return right(user);
    } on sb.AuthException catch (e) {
      return left(Failure(e.message));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}

// Implements AuthRepository (your domain-level contract).
// Uses a remote data source (AuthRemoteDataSource) to actually call Supabase.
// Handles errors/exceptions and converts them into Failure.
// Returns a safe result wrapped in Either<Failure, User> instead of throwing exceptions.
