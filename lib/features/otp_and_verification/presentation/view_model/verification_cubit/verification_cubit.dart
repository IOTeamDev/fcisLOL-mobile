import 'dart:async';
import 'dart:math';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:googleapis/analytics/v3.dart';
import 'package:lol/core/models/profile/profile_model.dart';
import 'package:lol/core/network/endpoints.dart';
import 'package:lol/core/network/remote/dio.dart';
import 'package:lol/core/network/remote/send_grid_helper.dart';
import 'package:lol/core/utils/components.dart';
import 'package:lol/core/utils/resources/constants_manager.dart';
import 'package:lol/core/utils/resources/values_manager.dart';
part 'verification_state.dart';

class VerificationCubit extends Cubit<VerificationState> {
  VerificationCubit() : super(VerificationInitial());
  static VerificationCubit get(context) => BlocProvider.of(context);
  late bool canResendCode;
  bool isPasswordCodeVerified = false;
  int id = -1;
  int currentTime = 30;
  late Stream<int> _timerStream;
  late StreamController<int> _timerStreamController;
  Timer? _timer;
  bool obscured = true;
  Stream<int> get timerStream => _timerStream;

  void initializeStream() {
    _timerStreamController = StreamController<int>.broadcast();
    _timerStream = _timerStreamController.stream;
    canResendCode = false;
  }

  void _counter({int counter = 30}) {
    _timer?.cancel();
    canResendCode = false;
    currentTime = counter;

    _timerStreamController.add(currentTime);
    _timer = Timer.periodic(Duration(seconds: AppSizes.s1), (timer) {
      currentTime--;
      _timerStreamController.add(currentTime);
      if (currentTime <= 0) {
        dev.log('timer is off');
        timer.cancel();
        canResendCode = true;
        emit(VerificationTimerCompleteState());
      }
    });
    emit(VerificationTimerStartedState(initialTime: counter));
  }

  void sendVerificationCode({
    required String recipientEmail,
    String? recipientName,
  }) {
    isPasswordCodeVerified = false;
    emit(SendVerificationCodeToEmailLoading());
    _counter(counter: 60);

    DioHelp.postData(path: SENDVERIFICATIONCODE, data: {
      'recipientEmail':recipientEmail,
      'recipientName':recipientName
    }).then((value){
      emit(SendVerificationCodeToEmailSuccess());
    }).catchError((e){

      emit(
        SendVerificationCodeToEmailFailed(
          errMessage: 'Unable to send code now, please try again',
        ),
      );

    });

  }

  void verifyEmail({required String otp, required String recipientEmail}) {
    emit(EmailVerifiedLoading());
    DioHelp.postData(path: CHECKVERIFICATIONCODE, data: {
      'email':recipientEmail,
      'otp':otp
    }).then((value){
      if(value.statusCode == 400){
        emit(EmailVerifiedFailed(errMessage: value.data['message']));
      } else if(value.statusCode == 200){
        isPasswordCodeVerified = true;
        emit(EmailVerifiedSuccess());
      }
    }).catchError((e){
      emit(EmailVerifiedFailed(errMessage: 'Oops! Something went wrong'));
    });
  }

  void updateForgottenPassword(String sentEmail, String otp, String newPassword){
    emit(VerificationUpdatePasswordLoadingState());
    DioHelp.postData(
      path: RESETPASSWORD,
      data: {
        'email': sentEmail,
        'otp': otp,
        'newPassword': newPassword,
      },
    ).then((value){
      emit(VerificationUpdatePasswordLoadingState());
    });
  }

  void changeEyeState(){
    obscured = !obscured;
    emit(VerificationChangeEyeState());
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _timerStreamController.close();
    return super.close();
  }

}
