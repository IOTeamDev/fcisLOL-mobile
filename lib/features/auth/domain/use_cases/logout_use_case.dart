import 'package:dartz/dartz.dart';
import 'package:lol/core/errors/failure.dart';
import 'package:lol/features/auth/domain/repos/auth_repo.dart';

class LogoutUseCase {
  final AuthRepo _authRepo;
  LogoutUseCase(this._authRepo);

  Future<Either<Failure, void>> call() {
    return _authRepo.logout();
  }
}
