import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lol/core/errors/failure.dart';
import 'package:lol/core/network/endpoints.dart';
import 'package:lol/core/network/local/shared_preference.dart';
import 'package:lol/core/network/remote/dio.dart';
import 'package:lol/core/resources/constants/constants_manager.dart';
import 'package:lol/core/resources/theme/values/app_strings.dart';
import 'package:lol/features/auth/data/models/login_model.dart';
import 'package:lol/features/auth/data/models/registration_user_model.dart';

abstract class AuthApiDataSource {
  Future<Either<Failure, LoginModel>> serverLogin(
      {required String email, required String password});

  Future<Either<Failure, LoginModel>> serverRegister({
    required RegistrationUserModel registrationUserModel,
  });

  // returns the failture if there was an error. else, returns the deleted user email
  Future<Either<Failure, String>> serverDeleteAccount({required int id});
}

class AuthApiDataSourceImpl implements AuthApiDataSource {
  @override
  Future<Either<Failure, LoginModel>> serverLogin(
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
  Future<Either<Failure, LoginModel>> serverRegister({
    required RegistrationUserModel registrationUserModel,
  }) async {
    try {
      final response = await DioHelp.postData(path: USERS, data: {
        "name": registrationUserModel.name,
        "email": registrationUserModel.email,
        "password": registrationUserModel.password,
        "phone": registrationUserModel.phone,
        "photo": registrationUserModel.photo,
        "semester": registrationUserModel.semester,
        "fcmToken": registrationUserModel.fcmToken,
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

  Future<Either<Failure, String>> serverDeleteAccount({required int id}) async {
    try {
      final response = await DioHelp.deleteData(
        path: USERS,
        token: AppConstants.TOKEN,
        query: {KeysManager.id: id},
      );
      final String deletedUserEmail = response.data['user']['email'];
      await Cache.removeValue(key: KeysManager.token);
      await Cache.removeValue(key: KeysManager.semester);

      AppConstants.TOKEN = null;
      AppConstants.SelectedSemester = null;
      return Right(deletedUserEmail);
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
