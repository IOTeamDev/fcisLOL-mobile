import 'package:dartz/dartz.dart';
import 'package:lol/core/errors/failure.dart';

abstract class VerificationRepo {
  Future<Either<Failure, void>> sendEmailVerification();
}
