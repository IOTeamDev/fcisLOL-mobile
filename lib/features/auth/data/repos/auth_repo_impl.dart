import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:lol/core/dependency_injection/service_locator.dart';
import 'package:lol/core/errors/failure.dart';
import 'package:lol/core/network/local/shared_preference.dart';
import 'package:lol/core/resources/constants/constants_manager.dart';
import 'package:lol/core/resources/theme/values/app_strings.dart';
import 'package:lol/features/auth/data/data_sources/auth_api_data_source.dart';
import 'package:lol/features/auth/data/data_sources/firebase_auth_data_source.dart';
import 'package:lol/features/auth/data/models/login_model.dart';
import 'package:lol/features/auth/data/models/registration_user_model.dart';
import 'package:lol/features/auth/data/repos/auth_repo.dart';

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
  Future<Either<Failure, LoginModel>> login(
      {required String email, required String password}) async {
    try {
      final result = await _authApiDataSource.serverLogin(
          email: email, password: password);

      return await result.fold(
        (failure) {
          return Left(failure);
        },
        (loginModel) async {
          await _firebaseMessaging.requestPermission();
          await Cache.writeData(
            key: KeysManager.token,
            value: loginModel.token,
          );
          AppConstants.TOKEN = loginModel.token;
          return Right(loginModel);
        },
      );
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, LoginModel>> register({
    required RegistrationUserModel registrationUserModel,
  }) async {
    final result = await _authApiDataSource.serverRegister(
        registrationUserModel: registrationUserModel);
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
              id: loginModel.user.id,
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
  }
}
