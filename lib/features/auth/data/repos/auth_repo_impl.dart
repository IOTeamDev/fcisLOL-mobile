import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lol/core/dependency_injection/service_locator.dart';
import 'package:lol/core/errors/failure.dart';
import 'package:lol/core/network/local/shared_preference.dart';
import 'package:lol/core/resources/constants/constants_manager.dart';
import 'package:lol/core/resources/theme/values/app_strings.dart';
import 'package:lol/features/auth/data/data_sources/auth_api_data_source.dart';
import 'package:lol/features/auth/data/data_sources/firebase_auth_data_source.dart';
import 'package:lol/features/auth/data/models/login_model.dart';
import 'package:lol/features/auth/data/models/login_request_model.dart';
import 'package:lol/features/auth/data/models/register_request_model.dart';
import 'package:lol/features/auth/data/repos/auth_repo.dart';
import 'package:lol/features/auth/presentation/auth_constants/auth_strings.dart';

class AuthRepoImpl extends AuthRepo {
  final AuthApiDataSource _authApiDataSource;
  final FirebaseMessaging _firebaseMessaging;
  final FirebaseAuthDataSource _firebaseAuthDataSource;

  AuthRepoImpl({
    required AuthApiDataSource authApiDataSource,
    required FirebaseMessaging firebaseMessaging,
    required FirebaseAuthDataSource firebaseAuthDataSource,
  })  : _authApiDataSource = authApiDataSource,
        _firebaseMessaging = firebaseMessaging,
        _firebaseAuthDataSource = firebaseAuthDataSource;

  @override
  Future<Either<Failure, LoginModel>> login({
    required LoginRequestModel loginRequestModel,
  }) async {
    try {
      final serverResult = await _authApiDataSource.serverLogin(
        loginRequestModel: loginRequestModel,
      );

      return await serverResult.fold(
        (serverFailure) {
          return Left(serverFailure);
        },
        (loginModel) async {
          final firebaseResult = await _firebaseAuthDataSource.firebaseLogin(
            loginRequestModel: loginRequestModel,
          );
          return await firebaseResult.fold(
            (firebaseFailure) async {
              if (firebaseFailure.message ==
                  AuthStrings.invalidCredentialsMessage) {
                final registerResponse =
                    await _firebaseAuthDataSource.firebaseRegister(
                  email: loginRequestModel.email,
                  password: loginRequestModel.password,
                );
                return await registerResponse.fold(
                  (failure) {
                    return Left(failure);
                  },
                  (_) async {
                    return Right(
                      await _storeTokenAndReturn(loginModel: loginModel),
                    );
                  },
                );
              }
              return Left(firebaseFailure);
            },
            (_) async {
              return Right(await _storeTokenAndReturn(loginModel: loginModel));
            },
          );
        },
      );
    } catch (e) {
      debugPrint(e.toString());
      return Left(Failure(message: AppStrings.unknownErrorMessage));
    }
  }

  Future<LoginModel> _storeTokenAndReturn({
    required LoginModel loginModel,
  }) async {
    await _firebaseMessaging.requestPermission();
    await Cache.writeData(
      key: KeysManager.token,
      value: loginModel.token,
    );
    AppConstants.TOKEN = loginModel.token;
    return loginModel;
  }

  @override
  Future<Either<Failure, LoginModel>> register({
    required RegisterRequestModel registrationUserModel,
  }) async {
    try {
      final result = await _authApiDataSource.serverRegister(
        registrationUserModel: registrationUserModel,
      );
      return await result.fold(
        (serverFailure) {
          return Left(serverFailure);
        },
        (loginModel) async {
          final firebaseResult = await _firebaseAuthDataSource.firebaseRegister(
            email: registrationUserModel.email,
            password: registrationUserModel.password,
          );
          return await firebaseResult.fold(
            (firebaseFailure) async {
              await _authApiDataSource.serverDeleteAccount(
                id: loginModel.user.id!,
              );
              return Left(firebaseFailure);
            },
            (_) async {
              await _firebaseMessaging.requestPermission();
              AppConstants.SelectedSemester = registrationUserModel.semester;
              await Cache.writeData(
                  key: KeysManager.semester,
                  value: AppConstants.SelectedSemester);
              return Right(loginModel);
            },
          );
        },
      );
    } catch (e) {
      debugPrint(e.toString());
      return Left(Failure(message: AppStrings.unknownErrorMessage));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      final serverResult = await _authApiDataSource.serverLogout();

      return await serverResult.fold(
        (serverFailure) {
          return Left(serverFailure);
        },
        (_) async {
          await _firebaseAuthDataSource.firebaseLogout();
          return Right(null);
        },
      );
    } catch (e) {
      return Left(Failure(message: AppStrings.unknownErrorMessage));
    }
  }
}
