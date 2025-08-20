import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lol/core/errors/failure.dart';
import 'package:lol/features/auth/data/models/login_model.dart';
import 'package:lol/features/auth/data/models/login_request_model.dart';
import 'package:lol/features/auth/data/models/register_request_model.dart';

abstract class AuthRepo {
  /// The login process follows these steps:
  ///
  /// 1. **Server Login**
  ///    - Calls the backend server to authenticate the user with [loginRequestModel].
  ///    - If the server rejects the credentials, a [Failure] is returned immediately.
  ///
  /// 2. **Firebase Login**
  ///    - If the server login succeeds, attempts to log in the same user with Firebase.
  ///    - If Firebase login succeeds, the user’s token is saved locally and returned.
  ///    - If Firebase login fails due to invalid credentials:
  ///       - A Firebase **register** call is made with the same credentials.
  ///       - On successful registration, the token is saved and returned.
  ///       - If registration fails, the error [Failure] is returned.
  ///    - If Firebase login fails for another reason, the error [Failure] is returned.
  Future<Either<Failure, LoginModel>> login({
    required LoginRequestModel loginRequestModel,
  });

  /// The registration process follows these steps:
  ///
  /// 1. **Server Registration**
  ///    - Sends the [registrationUserModel] to the backend server to create the user.
  ///    - If the server registration fails, returns a [Failure] immediately.
  ///    - If it succeeds, a [LoginModel] (with user data and token) is returned.
  ///
  /// 2. **Firebase Registration**
  ///    - After successful server registration, the same user is registered in Firebase
  ///      using their email and password.
  ///    - If Firebase registration fails:
  ///       - The previously created server account is **rolled back** (deleted) by
  ///         calling [_authApiDataSource.serverDeleteAccount].
  ///       - The Firebase failure is returned as a [Failure].
  ///    - If Firebase registration succeeds:
  ///       - Push notification permissions are requested via [_firebaseMessaging].
  ///       - The selected semester from [registrationUserModel.semester] is saved both:
  ///         - In [AppConstants.SelectedSemester].
  ///         - In local [Cache] using [KeysManager.semester].
  ///       - The [LoginModel] from server registration is returned.
  Future<Either<Failure, LoginModel>> register({
    required RegisterRequestModel registrationUserModel,
  });
}
