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
import 'package:lol/shared/components/components.dart';
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



  Future<void> UploadPImage({AnnouncementImagePath, File? image, bool isUserProfile = true}) async {
    AnnouncementImagePath = null;
    emit(UploadImageLoading());
    if (image == null) return;

    showToastMessage(
        message: 'Uploading your photo', states: ToastStates.WARNING);
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
    SelectedSemester = null;
    Cache.removeValue(key: "token");
    Cache.removeValue(key: "semester"); //SelectedSemester
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => ChoosingYear(loginCubit: LoginCubit()),
        ), //removing all background screens
        (route) => false);
    emit(Logout());
  }

  List<RequestsModel>? requests;
  void getRequests({required semester}) {
    emit(GetRequestsLoadingState());
    DioHelp.getData(
        path: MATERIAL,
        query: {'semester': semester, 'accepted': false}).then((value) {
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
      getRequests(semester: semester);
    });
  }

  void acceptRequest(int id, semester) {
    emit(AcceptRequestLoadingState());
    DioHelp.getData(
            path: ACCEPT, query: {'id': id, 'accepted': true}, token: TOKEN)
        .then((value) {
      emit(AcceptRequestSuccessState());
      getRequests(semester: semester);
    });
  }

  List<LeaderboardModel>? leaderboardModel;
  List<LeaderboardModel>? notAdminLeaderboardModel;

  LeaderboardModel? score4User;

  void getScore4User(int userId) async {
    score4User = null;
    print("${leaderboardModel!.length}dsmksdjkl");
    for (int i = 0; i < leaderboardModel!.length; i++) {
      if (leaderboardModel![i].id == userId) {
        score4User = leaderboardModel![i];
        print(score4User!.score);
        // emit(GetScore4User());
      }
    }
    for (int i = 0; i < notAdminLeaderboardModel!.length; i++) {
      if (notAdminLeaderboardModel![i].id == userId) {
        score4User?.userRank = i + 1;
        print(score4User?.userRank);
        // emit(GetScore4User());
      }
    }
    print(score4User!.score);
  }

  Future? getLeaderboard(currentSemester) {
    // getProfileInfo();
    notAdminLeaderboardModel = null;
    leaderboardModel = null;
    emit(GetLeaderboardLoadingState());
    DioHelp.getData(path: LEADERBOARD, query: {'semester': currentSemester})
        .then((value) {
      leaderboardModel = [];
      notAdminLeaderboardModel = [];
      value.data.forEach((element) {
        // exclude the admin
        leaderboardModel?.add(LeaderboardModel.fromJson(
            element)); //just to get the score of Admin

        if (element['role'] != "ADMIN") {
          notAdminLeaderboardModel?.add(LeaderboardModel.fromJson(element));
        }
//role
      });
      notAdminLeaderboardModel!.sort((a, b) => b.score!.compareTo(a.score!));
      print(leaderboardModel!.length);
      if (profileModel != null) {
        getScore4User(profileModel!.id);
      } else {
        print("object");
      }
      emit(GetLeaderboardSuccessState());
    }).catchError((onError) {
      print(onError.toString());

      emit(GetLeaderboardErrorState());
    });
    return null;
  }
}
