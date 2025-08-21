import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:lol/core/dependency_injection/service_locator.dart';
import 'package:lol/core/resources/theme/values/app_strings.dart';
import 'package:lol/features/otp_and_verification/data/repos/ticker_repo/ticker_repo.dart';
import 'package:lol/features/otp_and_verification/data/repos/verification_repo/verification_repo.dart';

part 'email_verification_state.dart';

class EmailVerificationCubit extends Cubit<EmailVerificationState> {
  final VerificationRepo _verificationRepo;
  EmailVerificationCubit(this._verificationRepo)
      : super(EmailVerificationInitial()) {
    _timer = Timer.periodic(
      const Duration(seconds: 30),
      (timer) async {
        await checkEmailVerified();
      },
    );
  }

  Timer? _timer;

  Future<void> sendEmailVerification() async {
    final response = await _verificationRepo.sendEmailVerification();
    try {
      response.fold(
        (failure) => emit(
          SendingEmailFailed(errMessage: failure.message),
        ),
        (_) => emit(SendingEmailSuccess()),
      );
    } catch (e) {
      emit(SendingEmailFailed(errMessage: AppStrings.sendEmailFailedMessage));
    }
  }

  Future<void> checkEmailVerified() async {
    try {
      final User user = getIt.get<FirebaseAuth>().currentUser!;
      await user.reload();
      if (user.emailVerified) {
        _timer?.cancel(); // Stop the timer once verified
        emit(EmailVerified());
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException during email check: ${e.message}');
    } catch (e) {
      debugPrint('Unexpected error checking email verification: $e');
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
