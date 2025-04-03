import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/core/network/endpoints.dart';
import 'package:lol/core/network/remote/send_grid_helper.dart';
import 'package:lol/features/otp_and_verification/cubit/verification_cubit_states.dart';

class VerificationCubit extends Cubit<VerificationCubitStates> {
  VerificationCubit() : super(VerificationInitState()) {
    _initializeStream();
  }
  static VerificationCubit get(context) => BlocProvider.of(context);

  late bool canResendCode;
  int currentTime = 30;
  late Stream<int> _timerStream;
  late StreamController<int> _timerStreamController;
  Timer? _timer;

  Stream<int> get timerStream => _timerStream;

  void _initializeStream() {
    _timerStreamController = StreamController<int>.broadcast();
    _timerStream = _timerStreamController.stream;
    canResendCode = false;
  }

  void counter({int counter = 30}) {
    _timer?.cancel();
    canResendCode = false;
    currentTime = counter;

    _timerStreamController.add(currentTime);
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      currentTime--;
      _timerStreamController.add(currentTime);
      if (currentTime <= 0) {
        timer.cancel();
        canResendCode = true;
        emit(VerificationTimerCompleteState());
      }
    });
    emit(VerificationTimerStartedState(initialTime: counter));
  }

  int _verificationCode = 000000;

  Future<void> sendVerificationCode({
    required String recepientEmail,
    String? recepientName,
  }) async {
    emit(SendVerificationCodeToEmailLoading());
    Random random = Random();
    _verificationCode = 100000 + random.nextInt(900000);

    try {
      await SendGridHelper.post(
        endPoint: sendGridEndPoint,
        data: {
          "personalizations": [
            {
              "to": [
                {"email": recepientEmail, "name": recepientName ?? ""},
              ],
            },
          ],
          "from": {"email": "elnawawyseif@gmail.com"},
          "subject": "Verifying ECommercy account",
          "content": [
            {
              "type": "text/html",
              "value":
                  "Hello ${recepientName ?? ''}, your ECommercy verification code is: <strong>$_verificationCode</strong>",
            },
          ],
        },
      );

      emit(SendVerificationCodeToEmailSuccess());
    } catch (e) {
      debugPrint(e.toString());
      emit(
        SendVerificationCodeToEmailFailed(
          errMessage: 'Unable to send code now, please try again later',
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _timerStreamController.close();
    return super.close();
  }
}
