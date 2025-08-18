import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lol/core/errors/failure.dart';
import 'package:lol/features/auth/data/models/login_model.dart';
import 'package:lol/features/auth/data/models/registration_user_model.dart';

abstract class AuthRepo {
  Future<Either<Failure, LoginModel>> login(
      {required String email, required String password});

  Future<Either<Failure, LoginModel>> register({
    required RegistrationUserModel registrationUserModel,
  });
}
