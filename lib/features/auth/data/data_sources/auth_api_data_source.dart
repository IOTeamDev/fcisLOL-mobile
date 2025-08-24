import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lol/core/errors/dio_exception_handler.dart';
import 'package:lol/core/errors/failure.dart';
import 'package:lol/core/network/endpoints.dart';
import 'package:lol/core/network/local/shared_preference.dart';
import 'package:lol/core/network/remote/dio.dart';
import 'package:lol/core/resources/constants/constants_manager.dart';
import 'package:lol/core/resources/theme/values/app_strings.dart';
import 'package:lol/features/auth/data/models/login_model.dart';
import 'package:lol/features/auth/data/models/login_request_model.dart';
import 'package:lol/features/auth/data/models/register_request_model.dart';
import 'package:lol/features/auth/presentation/auth_constants/auth_strings.dart';

abstract class AuthApiDataSource {
  Future<Either<Failure, LoginModel>> serverLogin({
    required LoginRequestModel loginRequestModel,
  });

  Future<Either<Failure, LoginModel>> serverRegister({
    required RegisterRequestModel registrationUserModel,
  });

  Future<Either<Failure, void>> serverLogout();

  // returns the failture if there was an error. else, returns the deleted user email
  Future<Either<Failure, String>> serverDeleteAccount({required int userId});
}

class AuthApiDataSourceImpl implements AuthApiDataSource {
  @override
  Future<Either<Failure, LoginModel>> serverLogin({
    required LoginRequestModel loginRequestModel,
  }) async {
    try {
      final response = await DioHelp.postData(
        path: Endpoints.LOGIN,
        data: loginRequestModel.toJson(),
      );

      final loginModel = LoginModel.fromJson(response.data);
      return Right(loginModel);
    } on DioException catch (e) {
      return Left(Failure(
          message: DioExceptionHandler.getMessage(
            e: e,
            badResponseMessage:
                e.response?.data['error'] == 'Invalid credentials'
                    ? AuthStrings.invalidCredentialsMessage
                    : e.response?.data['error'],
          ),
          code: e.response?.statusCode.toString()));
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, LoginModel>> serverRegister({
    required RegisterRequestModel registrationUserModel,
  }) async {
    try {
      final response = await DioHelp.postData(
        path: Endpoints.USERS,
        data: registrationUserModel.toJson(),
      );
      LoginModel loginModel = LoginModel.fromJson(response.data);
      return Right(loginModel);
    } on DioException catch (e) {
      return Left(Failure(
          message: DioExceptionHandler.getMessage(
            e: e,
            badResponseMessage: e.response?.data['error'],
          ),
          code: e.response?.statusCode.toString()));
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> serverLogout() async {
    try {
      await Cache.removeValue(key: KeysManager.token);
      await Cache.removeValue(key: KeysManager.semester);

      AppConstants.TOKEN = null;
      AppConstants.SelectedSemester = null;
      AppConstants.previousExamsSelectedSubject = null;
      AppConstants.previousExamsSelectedSemester = null;
      AppConstants.navigatedSemester = null;
      return Right(null);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, String>> serverDeleteAccount(
      {required int userId}) async {
    try {
      final response = await DioHelp.deleteData(
        path: Endpoints.USERS,
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
      return Left(Failure(
          message: DioExceptionHandler.getMessage(
            e: e,
            badResponseMessage: e.response?.data['error'],
          ),
          code: e.response?.statusCode.toString()));
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
