import 'package:dartz/dartz.dart';
import 'package:lol/core/errors/failure.dart';
import 'package:lol/core/network/remote/dio.dart';
import 'package:lol/features/auth/data/models/login_model.dart';

abstract class AuthApiDataSource {
  Future<Either<Failure, LoginModel>> login(
      {required String email, required String password});
}

class AuthApiDataSourceImpl implements AuthApiDataSource {
  @override
  Future<Either<Failure, LoginModel>> login(
      {required String email, required String password}) async {
    try {
      final response = await DioHelp.postData(path: "login", data: {
        "email": email,
        "password": password,
      });
      final loginModel = LoginModel.fromJson(response.data);
      return Right(loginModel);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
