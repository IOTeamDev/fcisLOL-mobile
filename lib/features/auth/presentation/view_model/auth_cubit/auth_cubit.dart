import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/core/network/remote/dio.dart';
import 'package:lol/features/auth/data/models/login_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  static AuthCubit get(BuildContext context) => BlocProvider.of(context);

  bool hiddenPassword = true;
  togglePassword() {
    hiddenPassword = !hiddenPassword;

    emit(TogglePassword());
  }

  Future<void> login({required String email, required String password}) async {
    emit(LoginLoading());
    try {
      final response = await DioHelp.postData(path: "login", data: {
        "email": email,
        "password": password,
      });
      LoginModel loginModel = LoginModel.fromJson(response.data);
      await FirebaseMessaging.instance.requestPermission();
      emit(LoginSuccess(token: loginModel.token));
    } catch (e) {
      emit(LoginFailed(errMessage: e.toString()));
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String photo,
    required String password,
    required String semester,
    String? fcmToken,
  }) async {
    emit(RegisterLoading());
    try {
      final response = await DioHelp.postData(path: "users", data: {
        "name": name,
        "email": email,
        "password": password,
        "phone": phone,
        "photo": photo,
        "semester": semester,
        "fcmToken": fcmToken,
      });
      LoginModel loginModel = LoginModel.fromJson(response.data);
      await FirebaseMessaging.instance.requestPermission();
      emit(RegisterSuccess(token: loginModel.token));
    } catch (e) {
      emit(RegisterFailed(errMessage: e.toString()));
    }
  }
}
