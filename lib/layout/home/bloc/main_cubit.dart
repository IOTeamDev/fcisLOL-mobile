import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lol/models/current_user/current_user_model.dart';
import 'package:lol/models/leaderboard/leaderboard_model.dart';
import 'package:lol/modules/admin/bloc/admin_cubit_states.dart';
import 'package:lol/modules/auth/bloc/login_cubit.dart';
import 'package:lol/modules/auth/bloc/login_cubit_states.dart';
import 'package:lol/models/login/login_model.dart';
import 'package:lol/shared/components/constants.dart';
import 'package:lol/layout/home/bloc/main_cubit_states.dart';
import 'package:lol/models/profile/profile_model.dart';
import 'package:lol/modules/year_choose/choosing_year.dart';
import 'package:lol/layout/home/home.dart';
import 'package:lol/shared/network/endpoints.dart';
import 'package:lol/shared/network/remote/dio.dart';
import 'package:lol/shared/components/navigation.dart';
import 'package:lol/shared/network/local/shared_prefrence.dart';

import 'package:lol/models/admin/requests_model.dart';

//uid null?
class MainCubit extends Cubit<MainCubitStates> {
  MainCubit() : super(InitialMainState());
  static MainCubit get(context) => BlocProvider.of(context);

  bool opendedDrawer = false;
  void openDrawerState() {
    opendedDrawer = true;
    emit(OpenDrawerState());
  }

  void closeDrawerState() {
    opendedDrawer = false;
    emit(CloseDrawerState());
  }

  bool isDarkMode = false;

  File? userImageFile;
  String? userImagePath;
  var picker = ImagePicker();

  getUserImage({required bool fromGallery}) async {
    emit(GetUserImageLoading());

    var tempPostImage = await picker.pickImage(
        source: fromGallery ? ImageSource.gallery : ImageSource.camera);
    if (tempPostImage != null) {
      userImageFile = File(tempPostImage.path);
      final int sizeInBytes = await userImageFile!.length();
      final int sizeInMB = sizeInBytes ~/ (1024 * 1024);
      print(sizeInBytes);
      print(sizeInMB);
      if (sizeInMB <= 1) {
        emit(GetUserImageSuccess());
      } else {
        userImageFile = null;
        emit(GetUserImageLimitExceed());
      }
    } else {
      emit(GetUserImageFailure());
    }
  }

  File? AnnouncementImageFile;
  String? AnnouncementImagePath;
  getAnnouncementImage() async {
    emit(GetAnnouncementImageLoading());

    var tempPostImage = await picker.pickImage(source: ImageSource.gallery);
    if (tempPostImage != null) {
      AnnouncementImageFile = File(tempPostImage.path);
      final int sizeInBytes = await AnnouncementImageFile!.length();
      final int sizeInMB = sizeInBytes ~/ (1024 * 1024);
      print(sizeInBytes);
      print(sizeInMB);
      if (sizeInMB <= 1) {
        emit(GetAnnouncementImageSuccess());
      } else {
        AnnouncementImageFile = null;
        emit(GetAnnouncementLimitExceed());
      }
    } else {
      emit(GetAnnouncementImageFailure());
    }
  }

  Future<void> UploadPImage({File? image, bool isUserProfile = true}) async {
    emit(UploadImageLoading());
    if (image == null) return;

    final uploadTask = await FirebaseStorage.instance
        .ref()
        .child("images/${Uri.file(image.path).pathSegments.last}")
        .putFile(image);

    try {
      final imagePath = await uploadTask.ref.getDownloadURL();
      if (isUserProfile) {
        userImagePath = imagePath;
      } else {
        AnnouncementImagePath = imagePath;
      }
      emit(UploadImageSuccess());
    } on Exception {
      emit(UploadImageFailure());
      // // TODO
    }
  }

  ProfileModel? profileModel;
  getProfileInfo() {
    if (TOKEN == null) return;

    emit(GetProfileLoading());
    profileModel = null;

    DioHelp.getData(path: CURRENTUSER, token: TOKEN).then(
      (value) {
        profileModel = ProfileModel.fromJson(value.data);
        emit(GetProfileSuccess());
      },
    );
  }

  void logout(context) {
    TOKEN = null;
    Cache.removeValue(key: "token");
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => ChoosingYear(loginCubit: LoginCubit()),
        ),
        (route) => false);
    emit(Logout());
  }

  List<RequestsModel>? requests;
  void getRequests({required semester}) {
    emit(GetRequestsLoadingState());
    DioHelp.getData(
        path: MATERIAL,
        query: {'semester': 'One', 'accepted': false}).then((value) {
      requests = [];
      value.data.forEach((element) {
        requests!.add(RequestsModel.fromJson(element));
      });

      emit(GetRequestsSuccessState());
    });
  }

  void deleteMaterial(int id, semester) {
    emit(DeleteMaterialLoadingState());
    DioHelp.deleteData(path: MATERIAL, data: {'id': id}, token: TOKEN)
        .then((value) {
      emit(DeleteMaterialSuccessState());
      getRequests(semester: 'one');
    });
  }

  void acceptRequest(int id) {
    emit(AcceptRequestLoadingState());
    DioHelp.getData(
            path: ACCEPT, query: {'id': id, 'accepted': true}, token: TOKEN)
        .then((value) {
      emit(AcceptRequestSuccessState());
      getRequests(semester: semester);
    });
  }
}
