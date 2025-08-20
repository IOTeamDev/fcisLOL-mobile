import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lol/core/errors/failure.dart';
import 'package:lol/core/resources/theme/values/app_strings.dart';
import 'package:lol/features/auth/data/models/login_request_model.dart';
import 'package:lol/features/auth/data/models/register_request_model.dart';
import 'package:lol/features/auth/presentation/auth_constants/auth_strings.dart';

abstract class FirebaseAuthDataSource {
  Future<Either<Failure, void>> firebaseRegister({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserCredential>> firebaseLogin({
    required LoginRequestModel loginRequestModel,
  });

  // Future<Either<Failure, void>> sendEmailVerification();

//  Future<Either<Failure, void>> logout();
}

class FirebaseAuthDataSourceImpl extends FirebaseAuthDataSource {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthDataSourceImpl(this._firebaseAuth);

  @override
  Future<Either<Failure, void>> firebaseRegister({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return right(null);
    } on FirebaseAuthException catch (e) {
      final errMessage = _mapFirebaseAuthError(e.code);
      return left(Failure(message: errMessage, code: e.code));
    } catch (e) {
      return left(Failure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserCredential>> firebaseLogin({
    required LoginRequestModel loginRequestModel,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: loginRequestModel.email,
        password: loginRequestModel.password,
      );
      if (userCredential.user == null) {
        log('Firebase login failed: UserCredential is null');
      } else {
        log('Firebase login successful: ${userCredential.user?.email}');
      }
      return right(userCredential);
    } on FirebaseAuthException catch (e) {
      final errMessage = _mapFirebaseAuthError(e.code);
      return left(Failure(message: errMessage, code: e.code));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  String _mapFirebaseAuthError(String code) {
    switch (code) {
      case 'invalid-email':
        return 'The email address is badly formatted.';
      case 'user-disabled':
        return 'This user has been disabled.';
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists for this email.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'weak-password':
        return 'Your password is too weak. Try a stronger one.';
      case 'too-many-requests':
        return 'Too many requests. Try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      case 'invalid-credential':
        return AuthStrings.invalidCredentialsMessage;
      default:
        return 'An unknown error occurred. Please try again.';
    }
  }
}
