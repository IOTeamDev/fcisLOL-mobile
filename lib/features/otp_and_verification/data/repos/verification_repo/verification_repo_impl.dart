import 'package:dartz/dartz.dart';
import 'package:lol/core/errors/failure.dart';
import 'package:lol/features/auth/data/data_sources/firebase_auth_data_source.dart';
import 'package:lol/features/otp_and_verification/data/repos/verification_repo/verification_repo.dart';

class VerificationRepoImpl extends VerificationRepo {
  final FirebaseAuthDataSource _firebaseAuthDataSource;

  VerificationRepoImpl(this._firebaseAuthDataSource);

  @override
  Future<Either<Failure, void>> sendEmailVerification() async {
    return await _firebaseAuthDataSource.sendEmailVerification();
  }
}
