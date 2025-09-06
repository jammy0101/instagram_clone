import 'package:fpdart/src/either.dart';

import '../../../../core/entities/user.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repository/auth_repository.dart';

class UserSignUp implements UseCase<User,UserSignUpParams>{

  final AuthRepository authRepository;
  UserSignUp({
    required this.authRepository,
});

  @override
  Future<Either<Failure, User>> call(UserSignUpParams params)async{
    return await authRepository.signUpWithEmailPassword(
        fullName: params.fullName,
        email: params.email,
        password: params.password,
        userName: params.userName,
    );
  }

}
class UserSignUpParams {
  final String fullName;
  final String email;
  final String password;
  final String userName;

  UserSignUpParams( {
    required this.fullName,
    required this.email,
    required this.password,
    required this.userName,
});
  
}