import 'dart:io';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/core/network/endpoints.dart';
import 'package:lol/core/network/local/shared_preference.dart';
import 'package:lol/core/network/remote/dio.dart';
import 'package:lol/core/network/remote/send_grid_helper.dart';
import 'package:lol/core/utils/components.dart';
import 'package:lol/core/utils/service_locator.dart';
import 'package:lol/core/utils/navigation.dart';
import 'package:lol/core/utils/resources/constants_manager.dart';
import 'package:lol/core/utils/resources/strings_manager.dart';
import 'package:lol/features/auth/data/models/login_model.dart';
import 'package:lol/features/auth/presentation/view/choosing_year.dart';
import 'package:lol/features/auth/presentation/view_model/login_cubit/login_cubit.dart';
import 'package:lol/features/home/presentation/view/home.dart';
import 'package:dio/dio.dart';

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
      emit(LoginSuccess());
    } catch (e) {
      emit(LoginFailed(errMessage: e.toString()));
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String phone,
    String? photo,
    required String password,
    required String semester,
    String? fcmToken,
  }) async {
    emit(RegisterLoading());
    try {
      final response = await DioHelp.postData(path: USERS, data: {
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
      AppConstants.SelectedSemester = semester;
      await Cache.writeData(
          key: KeysManager.semester, value: AppConstants.SelectedSemester);

      emit(RegisterSuccess(token: loginModel.token, userEmail: email));
    } on DioException catch (e) {
      if (e.response?.statusCode == 500) {
        emit(RegisterFailed(
            errMessage:
                e.response?.data['error'] ?? 'Opps! there was an error'));
      } else {
        emit(RegisterFailed(errMessage: e.toString()));
      }
    } catch (e) {
      emit(RegisterFailed(errMessage: e.toString()));
    }
  }

  String? userImagePath;

  String? announcementImagePath;

  Future<void> uploadPImage({File? image, bool isUserProfile = true}) async {
    announcementImagePath = null;
    emit(UploadImageLoading());
    if (image == null) return;
    showToastMessage(
        message: StringsManager.uploadImage, states: ToastStates.WARNING);
    final TaskSnapshot uploadTask;
    if (isUserProfile) {
      uploadTask = await FirebaseStorage.instance
          .ref()
          .child(StringsManager.image.toLowerCase() +
              StringsManager.forwardSlash +
              Uri.file(image.path).pathSegments.last)
          .putFile(image);
    } else {
      uploadTask = await FirebaseStorage.instance
          .ref()
          .child(StringsManager.announcements.toLowerCase() +
              StringsManager.forwardSlash +
              Uri.file(image.path).pathSegments.last)
          .putFile(image);
    }

    try {
      final imagePath = await uploadTask.ref.getDownloadURL();
      if (isUserProfile) {
        userImagePath = imagePath;
      } else {
        announcementImagePath = imagePath;
      }
      emit(UploadImageSuccess());
    } on Exception {
      emit(UploadImageFailed());
    }
  }

  static const List<String> semesters = [
    'One',
    'Two',
    'Three',
    'Four',
    'Five',
    'Six',
    'Seven',
    'Eight',
  ];
}
