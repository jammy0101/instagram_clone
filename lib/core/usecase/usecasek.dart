abstract class UseCaseK<Type, Params> {
  Future<Type> call(Params params);
}

class NoParams {}


// import 'package:fpdart/fpdart.dart';
//
// import '../errors/failure.dart';
//
// abstract interface class UseCaseK<SuccessType, Params> {
//   Future<Either<Failure, SuccessType>> call(Params params);
// }
//
// class NoParams {}



// import 'package:fpdart/fpdart.dart';
// import 'package:horizon/core/errors/failure.dart';
//
//
// abstract interface class UseCase<SuccessType, Params> {
//   Future<Either<Failure, SuccessType>> call(Params params);
// }
//
// class NoParams {}
