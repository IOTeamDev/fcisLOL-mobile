import 'package:dartz/dartz.dart';
import 'package:lol/core/errors/failure.dart';
import 'package:lol/features/auth/domain/repos/auth_repo.dart';

class DeleteAccountUseCase {
  final AuthRepo _authRepo;

  DeleteAccountUseCase(this._authRepo);

  Future<Either<Failure, void>> call({required int userId}) {
    return _authRepo.deleteAccount(userId: userId);
  }
}
