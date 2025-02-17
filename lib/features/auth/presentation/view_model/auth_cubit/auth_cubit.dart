import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/core/network/local/shared_preference.dart';
import 'package:lol/core/network/remote/dio.dart';
import 'package:lol/core/utils/dependencies_helper.dart';
import 'package:lol/core/utils/resources/constants_manager.dart';
import 'package:lol/core/utils/resources/strings_manager.dart';
import 'package:lol/features/auth/data/models/login_model.dart';
import 'package:lol/features/auth/presentation/view/choosing_year.dart';
import 'package:lol/features/auth/presentation/view_model/login_cubit/login_cubit.dart';

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
      await Cache.writeData(key: KeysManager.token, value: loginModel.token);
      AppConstants.TOKEN = loginModel.token;
      print('token=>>>>>>>>>>${AppConstants.TOKEN}');
      emit(LoginSuccess());
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
