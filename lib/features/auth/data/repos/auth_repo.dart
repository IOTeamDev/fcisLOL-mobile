import 'package:dartz/dartz.dart';
import 'package:lol/core/errors/failure.dart';
import 'package:lol/features/auth/data/models/login_model.dart';

abstract class AuthRepo {
  Future<Either<Failure, LoginModel>> login(
      {required String email, required String password});

  Future<Either<Failure, LoginModel>> register({
    required String name,
    required String email,
    required String phone,
    String? photo,
    required String password,
    required String semester,
    String? fcmToken,
  });
}
