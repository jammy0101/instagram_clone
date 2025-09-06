
import 'package:fpdart/src/either.dart';
import '../../../../core/entities/user.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repository/auth_repository.dart';

class UserLogin implements UseCase<User,UserLoginParams> {

  final AuthRepository authRepository;
  UserLogin({
    required this.authRepository,
  });

  @override
  Future<Either<Failure, User>> call(UserLoginParams params)async{
    return await authRepository.loginWithEmailPassword(
        email: params.email,
        password: params.password
    );
  }
}

class UserLoginParams {

  final String email;
  final String password;

  UserLoginParams({
    required this.email,
    required this.password,
  });
}