import 'dart:developer' as dev;
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lol/core/models/profile/profile_model.dart';
import 'package:lol/core/network/endpoints.dart';
import 'package:lol/core/network/remote/dio.dart';
import 'package:lol/core/network/remote/send_grid_helper.dart';
import 'package:lol/core/utils/resources/constants_manager.dart';
part 'verification_state.dart';

class VerificationCubit extends Cubit<VerificationState> {
  VerificationCubit() : super(VerificationInitial());

  // late bool canResendCode;
  // int currentTime = 30;
  // late Stream<int> _timerStream;
  // late StreamController<int> _timerStreamController;
  // Timer? _timer;

  // Stream<int> get timerStream => _timerStream;

  // void _initializeStream() {
  //   _timerStreamController = StreamController<int>.broadcast();
  //   _timerStream = _timerStreamController.stream;
  //   canResendCode = false;
  // }

  // void counter({int counter = 30}) {
  //   _timer?.cancel();
  //   canResendCode = false;
  //   currentTime = counter;

  //   _timerStreamController.add(currentTime);
  //   _timer = Timer.periodic(Duration(seconds: 1), (timer) {
  //     currentTime--;
  //     _timerStreamController.add(currentTime);
  //     if (currentTime <= 0) {
  //       timer.cancel();
  //       canResendCode = true;
  //       emit(VerificationTimerCompleteState());
  //     }
  //   });
  //   emit(VerificationTimerStartedState(initialTime: counter));
  // }

  int _otp = 000000;

  Future<void> sendVerificationCode({
    required String recepientEmail,
    String? recepientName,
  }) async {
    emit(SendVerificationCodeToEmailLoading());
    Random random = Random();
    _otp = 100000 + random.nextInt(900000);

    try {
      final Response response =
          await MainSenderHelper.post(endPoint: brevoEndPoint, data: {
        "sender": {"name": "UniNotes", "email": "notesu362@gmail.com"},
        "to": [
          {"email": "$recepientEmail", "name": "$recepientName "}
        ],
        "subject": "Verifying UniNotes account",
        "htmlContent":
            "<html><head><style>body { font-family: Arial, sans-serif; background-color: #f4f4f4; padding: 20px; } .container { background-color: #fff; padding: 20px; border-radius: 8px; max-width: 500px; margin: auto; box-shadow: 0 0 10px rgba(0, 0, 0, 0.1); } h2 { color: #333; } p { font-size: 16px; color: #555; } .otp { font-size: 18px; font-weight: bold; color: #007BFF; }</style></head><body><div class='container'><h2>Hello Seif,</h2><p>Welcome to UniNotes! Your one-time password (OTP) is:</p><p class='otp'>$_otp</p><p>Please use this code to complete your verification.</p><p>Best regards,<br>UniNotes Team</p></div></body></html>"
      });
      if (response.data['message'] == null) {
        emit(SendVerificationCodeToEmailSuccess());
      } else {
        debugPrint(response.data['message']);
        emit(SendVerificationCodeToEmailFailed(
          errMessage: response.data['message'],
        ));
      }
    } catch (e) {
      debugPrint(e.toString());
      emit(
        SendVerificationCodeToEmailFailed(
          errMessage: 'Unable to send code now, please try again later',
        ),
      );
    }
  }

  Future<void> verityEmail({required String otp}) async {
    emit(EmailVerifiedLoading());
    try {
      if (otp == _otp.toString()) {
        await DioHelp.patchData(
            path: EDITCURRENTUSER,
            data: {
              'isVerified': true,
            },
            token: AppConstants.TOKEN);
        emit(EmailVerifiedSuccess());
      } else {
        emit(EmailVerifiedFailed(errMessage: 'Incorrect OTP'));
      }
    } catch (e) {
      debugPrint(e.toString());
      emit(EmailVerifiedFailed(errMessage: 'Opps! Something went wrong'));
    }
  }
  // @override
  // Future<void> close() {
  //   _timer?.cancel();
  //   _timerStreamController.close();
  //   return super.close();
  // }
}
