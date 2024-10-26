import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lol/models/current_user/current_user_model.dart';
import 'package:lol/models/leaderboard/leaderboard_model.dart';
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

import 'package:lol/models/admin/announcement_model.dart';

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

  bool isDarkMode = true;

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
  IconData? pickerIcon;
  String? imageName;
  getAnnouncementImage() async {
    emit(GetAnnouncementImageLoading());

    var tempPostImage = await picker.pickImage(source: ImageSource.gallery);
    if (tempPostImage != null) {
      AnnouncementImageFile = File(tempPostImage.path);
      pickerIcon = Icons.close;
      imageName = tempPostImage.path.split('/').last;
      final int sizeInBytes = await AnnouncementImageFile!.length();
      final int sizeInMB = sizeInBytes ~/ (1024 * 1024);
      print(sizeInBytes);
      print(sizeInMB);
      if (sizeInMB <= 1) {
        pickerIcon = Icons.clear;
        showToastMessage(
            message: 'Imaged Picked Successfully', states: ToastStates.SUCCESS);
        emit(GetAnnouncementImageSuccess());
      } else {
        showToastMessage(
            message: 'Image Limit Exceeded', states: ToastStates.WARNING);
        imageName = 'Select Image';
        pickerIcon = Icons.image;
        AnnouncementImageFile = null;
        emit(GetAnnouncementLimitExceed());
      }
    } else {
      pickerIcon = Icons.image;
      imageName = 'Select Image';
      emit(GetAnnouncementImageFailure());
    }
  }

  Future<void> UploadPImage({File? image, bool isUserProfile = true}) async {
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
    Cache.removeValue(key: "token");
    Cache.removeValue(key: "semester"); //SelectedSemester
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => ChoosingYear(loginCubit: LoginCubit()),
        ), //removing all background screens
        (route) => false);
    Future.delayed(Duration(seconds: 1), () {
      TOKEN = null;
      SelectedSemester = null;
    });
    emit(Logout());
  }

  List<RequestsModel>? requests;
  void getRequests({required semester, isAccepted = false}) {
    emit(GetRequestsLoadingState());
    DioHelp.getData(
        path: MATERIAL,
        query: {'semester': semester, 'accepted': isAccepted}).then((value) {
      requests = [];
      value.data.forEach((element) {
        requests!.add(RequestsModel.fromJson(element));
      });

      emit(GetRequestsSuccessState());
    });
  }

  void deleteMaterial(int id, semester, {isMaterial = false}) {
    emit(DeleteMaterialLoadingState());
    DioHelp.deleteData(path: MATERIAL, data: {'id': id}, token: TOKEN)
        .then((value) {
      emit(DeleteMaterialSuccessState());
      getRequests(semester: semester, isAccepted: isMaterial);
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

  List<AnnouncementModel>? announcements;
  void getAnnouncements(String semester) {
    announcements = null;
    print(SelectedSemester.toString());
    emit(GetAnnouncementsLoadingState());
    DioHelp.getData(path: ANNOUNCEMENTS, query: {'semester': semester})
        .then((value) {
      announcements = [];
      value.data.forEach((element) {
        announcements!.add(AnnouncementModel.fromJson(element));
      });
      emit(GetAnnouncementsSuccessState());
    });
  }

  void updateAnnouncement(
    final String id, {
    String? title,
    String? content,
    dynamic dueDate,
    // String? type,
    //dynamic currentSemester,
    //String? image,
  }) {
    print(id);
    print(title);
    print(content);
    print(dueDate);
    //print(currentSemester);
    // print(image);
    emit(UpdateAnnouncementsLoadingState());
    DioHelp.putData(
        path: ANNOUNCEMENTS,
        data: {
          'title': title??"",
          'content': content??"",
          'due_date': dueDate,
          //'type': type,
          //'semester': currentSemester,
          //'image': image,
        },
        token: TOKEN,
        query: {'id': int.parse(id)}).then((value) {
      // Assuming the response returns the updated announcement
      AnnouncementModel updatedAnnouncement = AnnouncementModel.fromJson(value.data);

      // Update the local announcements list
      if (announcements != null) {
        int index = announcements!.indexWhere((ann) => ann.id.toString() == id);
        if (index != -1) {
          announcements![index] = updatedAnnouncement;
        }
      }
      emit(UpdateAnnouncementsSuccessState());
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
          //print('leaderboard size ${notAdminLeaderboardModel!.first}');
        }
//roll
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

  void updateSemester4all() {
    DioHelp.getData(path: "users").then((onValue) {
      onValue.data.forEach((element) {
        if (element['semester'] == "One")
          updateUser(userID: element['id'], semester: "Two");
        if (element['semester'] == "Two")
          updateUser(userID: element['id'], semester: "Three");
        if (element['semester'] == "Three")
          updateUser(userID: element['id'], semester: "Four");
        if (element['semester'] == "Four")
          updateUser(userID: element['id'], semester: "Five");
        if (element['semester'] == "Five")
          updateUser(userID: element['id'], semester: "Six");
      });

      emit(GetUserImageSuccess());
    }).catchError((onError));
  }

  updateUser({
    required int userID,
    String? semester,
    String? fcmToken,
  }) {
    DioHelp.putData(
        token: TOKEN,
        query: {'id': userID},
        path: "users",
        data: {
          if (semester != null) 'semester': semester,
          if (fcmToken != null) 'fcmToken': fcmToken
        }).then((val) {
      print(val.data['id']);
      emit(UpdateUserSuccessState());
    }).catchError((erro) {
      print(erro.toString());
      emit(UpdateUserErrorState());
    });
  }
}
