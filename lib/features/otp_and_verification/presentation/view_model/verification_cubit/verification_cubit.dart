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

  int _otp = 000000;

  Future<void> sendVerificationCode({
    required String recipientEmail,
    String? recipientName,
  }) async {
    isPasswordCodeVerified = false;
    emit(SendVerificationCodeToEmailLoading());
    Random random = Random();
    _otp = 100000 + random.nextInt(900000);
    dev.log(_otp.toString());
    _counter(counter: 60);
    try {
      await MainSenderHelper.post(endPoint: brevoEndPoint, data: {
        "sender": {"name": "UniNotes", "email": "notesu362@gmail.com"},
        "to": [
          {"email": "$recipientEmail", "name": "$recipientName "}
        ],
        "subject": "Verifying UniNotes account",
        "htmlContent": "<html><head><style>body { font-family: Arial, sans-serif; background-color: #f4f4f4; padding: 20px; } .container { background-color: #fff; padding: 20px; border-radius: 8px; max-width: 500px; margin: auto; box-shadow: 0 0 10px rgba(0, 0, 0, 0.1); } h2 { color: #333; } p { font-size: 16px; color: #555; } .otp { font-size: 18px; font-weight: bold; color: #007BFF; }</style></head><body><div class='container'><h2>Hello Seif,</h2><p>Welcome to UniNotes! Your one-time password (OTP) is:</p><p class='otp'>$_otp</p><p>Please use this code to complete your verification.</p><p>Best regards,<br>UniNotes Team</p></div></body></html>"
      });
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

  Future<void> verifyEmail({required int id, required String otp, required String recipientEmail}) async {
    emit(EmailVerifiedLoading());
    try {
      if (otp == _otp.toString()) {
        await DioHelp.putData(
          query: {'id': id},
          path: EDITCURRENTUSER,
          data: {
            'email': recipientEmail,
            'isVerified': true,
          },
          token: AppConstants.TOKEN
        );
        isPasswordCodeVerified = true;
        emit(EmailVerifiedSuccess());
      } else {
        emit(EmailVerifiedFailed(errMessage: 'Incorrect OTP'));
      }
    } catch (e) {
      debugPrint(e.toString());
      emit(EmailVerifiedFailed(errMessage: 'Oops! Something went wrong'));
    }
  }

  void updateForgottenPassword(int id, String sentEmail, String newPassword, String confirmNewPassword){
    emit(VerificationUpdatePasswordLoadingState());
    DioHelp.putData(
      query: {'id':id},
      path: EDITCURRENTUSER,
      data: {
        'email': sentEmail,
        'newPassword': newPassword,
        'newPasswordConfirm': confirmNewPassword,
      },
      token: AppConstants.TOKEN
    ).then((value){
      emit(VerificationUpdatePasswordLoadingState());
    });
  }

  int getIdByMail(recipientEmail){
    emit(VerificationGetIDLoadingState());
    DioHelp.getData(
      path: USERID,
      query: {
        'email': recipientEmail
      }
    ).then((value){
      emit(VerificationGetIDSuccessState());
      return value;
    }).catchError((e){
      showToastMessage(message: "Email Doesn't Exist!!", states: ToastStates.ERROR);
    });
    return -1;
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
