
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repository/auth_repository.dart';

class Logout implements UseCase<void, NoParams> {
  final AuthRepository repository;
  Logout(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.logout();
  }
}
