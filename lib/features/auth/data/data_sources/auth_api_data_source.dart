import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lol/core/errors/failure.dart';
import 'package:lol/core/network/endpoints.dart';
import 'package:lol/core/network/remote/dio.dart';
import 'package:lol/features/auth/data/models/login_model.dart';

abstract class AuthApiDataSource {
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
    } on DioException catch (e) {
      if (e.response?.statusCode == 500) {
        return Left(Failure(
            message: e.response?.data['error'] ?? 'Opps! there was an error'));
      } else {
        return Left(Failure(message: e.toString()));
      }
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, LoginModel>> register(
      {required String name,
      required String email,
      required String phone,
      String? photo,
      required String password,
      required String semester,
      String? fcmToken}) async {
    try {
      final response = await DioHelp.postData(path: USERS, data: {
        "name": name,
        "email": email,
        "password": password,
        "phone": phone,
        "photo": photo,
        "semester": semester,
        "fcmToken": fcmToken,
      });
      LoginModel loginModel = LoginModel.fromJson(response.data);
      return Right(loginModel);
    } on DioException catch (e) {
      if (e.response?.statusCode == 500) {
        return Left(Failure(
            message: e.response?.data['error'] ?? 'Opps! there was an error'));
      } else {
        return Left(Failure(message: e.toString()));
      }
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
