import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lol/core/models/current_user/current_user_model.dart';
import 'package:lol/core/models/leaderboard/leaderboard_model.dart';
import 'package:lol/core/utils/resources/strings_manager.dart';
import 'package:lol/core/utils/resources/themes_manager.dart';
import 'package:lol/features/auth/presentation/view_model/login_cubit/login_cubit.dart';
import 'package:lol/features/auth/presentation/view_model/login_cubit/login_cubit_states.dart';
import 'package:lol/core/utils/components.dart';
import 'package:lol/core/utils/resources/constants_manager.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit_states.dart';
import 'package:lol/core/models/profile/profile_model.dart';
import 'package:lol/features/auth/presentation/view/choosing_year.dart';
import 'package:lol/features/home/presentation/view/home.dart';
import 'package:lol/core/network/endpoints.dart';
import 'package:lol/core/network/remote/dio.dart';
import 'package:lol/core/utils/navigation.dart';
import 'package:lol/core/network/local/shared_preference.dart';
import 'package:lol/core/models/admin/requests_model.dart';
import 'package:lol/core/models/admin/announcement_model.dart';
import 'package:lol/features/subject/data/models/material_model.dart';
import '../../utils/resources/icons_manager.dart';
import '../../utils/resources/values_manager.dart';

//uid null?
class MainCubit extends Cubit<MainCubitStates> {
  MainCubit() : super(InitialMainState());
  static MainCubit get(context) => BlocProvider.of(context);
  IconData? pickerIcon = IconsManager.imageIcon;
  String? imageName = StringsManager.selectImage;
  bool openedDrawer = false;

  void openDrawerState() {
    openedDrawer = true;
    emit(OpenDrawerState());
  }

  void closeDrawerState() {
    openedDrawer = false;
    emit(CloseDrawerState());
  }

  File? userImageFile;
  String? userImagePath;
  var picker = ImagePicker();
  getUserImage({required bool fromGallery}) async {
    emit(GetUserImageLoading());
    pickerIcon = IconsManager.imageIcon;
    imageName = StringsManager.selectImage;
    //const int maxStorageLimit = 1000000000; // 1 GB in bytes

    var tempPostImage = await picker.pickImage(
        source: fromGallery ? ImageSource.gallery : ImageSource.camera);
    if (tempPostImage != null) {
      userImageFile = File(tempPostImage.path);
      pickerIcon = IconsManager.closeIcon;
      imageName = tempPostImage.path.split(StringsManager.forwardSlash).last;
      // final int sizeInBytes = await userImageFile!.length();
      // final int sizeInMB = sizeInBytes ~/ sqrt(AppSizes.s1024);

      emit(GetUserImageSuccess());
      // if (sizeInMB <= AppSizes.s1) {
      // } else {
      //   userImageFile = null;
      //   emit(GetUserImageLimitExceed());
      // }
    } else {
      imageName = StringsManager.selectImage;
      pickerIcon = IconsManager.imageIcon;
      emit(GetUserImageFailure());
    }
  }

  File? announcementImageFile;
  String? announcementImagePath;
  getAnnouncementImage() async {
    emit(GetAnnouncementImageLoading());
    pickerIcon = IconsManager.imageIcon;
    imageName = StringsManager.selectImage;

    var tempPostImage = await picker.pickImage(source: ImageSource.gallery);
    if (tempPostImage != null) {
      announcementImageFile = File(tempPostImage.path);
      pickerIcon = IconsManager.closeIcon;
      imageName = tempPostImage.path.split(StringsManager.forwardSlash).last;
      // final int sizeInBytes = await announcementImageFile!.length();
      // final int sizeInMB = sizeInBytes ~/ sqrt(AppSizes.s1024);
      // print(sizeInBytes);
      // print(sizeInMB);
      //pickerIcon = IconsManager.closeIcon;
      showToastMessage(
          message: StringsManager.imgPickedSuccessfully,
          states: ToastStates.SUCCESS);
      emit(GetAnnouncementImageSuccess());
      // if (sizeInMB <= AppSizes.s1) {
      // } else {
      //   showToastMessage(
      //       message: StringsManager.imgLimitExceeded,
      //       states: ToastStates.WARNING);
      //   imageName = StringsManager.selectImage;
      //   pickerIcon = IconsManager.imageIcon;
      //   announcementImageFile = null;
      //   emit(GetAnnouncementLimitExceed());
      // }
    } else {
      imageName = StringsManager.selectImage;
      pickerIcon = IconsManager.imageIcon;
      emit(GetAnnouncementImageFailure());
    }
  }

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
      emit(UploadImageFailure());
    }
  }

  ProfileModel? profileModel;
  getProfileInfo() async {
    emit(GetProfileLoading());
    try {
      final response = await DioHelp.getData(path: CURRENTUSER, token: AppConstants.TOKEN);
      profileModel = ProfileModel.fromJson(response.data);
      AppConstants.SelectedSemester = profileModel!.semester;
      await Cache.writeData(key: KeysManager.semester, value: profileModel!.semester);
      dev.log('profile semester =====================================> ${profileModel!.semester}');
      dev.log('selected semester =====================================> ${AppConstants.SelectedSemester}');
      emit(GetProfileSuccess());
    } catch (e) {
      print(e.toString());

      emit(GetProfileFailure());
    }
  }

  ProfileModel? otherProfile;
  getOtherProfile(id) {
    emit(GetProfileLoading());
    otherProfile = null;
    DioHelp.getData(
      path: USERS,
      query: {KeysManager.id: id, KeysManager.haveMaterial: true}
    ).then((value) {
      otherProfile = ProfileModel.fromJson(value.data);
      emit(GetProfileSuccess());
    },);
  }

  Future<void> logout(context) async {
    try {
      await Cache.removeValue(key: KeysManager.token);
      await Cache.removeValue(key: KeysManager.semester);

      AppConstants.TOKEN = null;
      AppConstants.SelectedSemester = null;

      emit(LogoutSuccess());
    } catch (e) {
      dev.log('logoutFailed => $e');
      emit(LogoutFailed(errMessage: e.toString()));
    }
  }

  List<MaterialModel>? requests;
  Future<void> getRequests({required String semester, bool isAccepted = false}) async {
    emit(GetRequestsLoadingState());
    try {
      final response = await DioHelp.getData(
        path: MATERIAL,
        query: {KeysManager.semester: semester, KeysManager.accepted: false},
      );
      requests = [];
      response.data.forEach((element) {
        requests!.add(MaterialModel.fromJson(element));
      });
      emit(GetRequestsSuccessState());
    } catch (e) {
      emit(GetRequestsErrorState());
    }
  }

  void deleteMaterial(int id, semester, {isMaterial = false}) {
    emit(DeleteMaterialLoadingState());
    DioHelp.deleteData(
      path: MATERIAL,
      data: {KeysManager.id: id},
      token: AppConstants.TOKEN
    ).then((value) {
      emit(DeleteMaterialSuccessState());
      getRequests(semester: semester, isAccepted: isMaterial);
    });
  }

  void acceptRequest(int id, semester) {
    emit(AcceptRequestLoadingState());
    DioHelp.getData(
      path: ACCEPT,
      query: {KeysManager.id: id, KeysManager.accepted: true},
      token: AppConstants.TOKEN
    ).then((value) {
      emit(AcceptRequestSuccessState());
      getRequests(semester: semester);
    });
  }

  List<LeaderboardModel>? leaderboardModel;
  List<LeaderboardModel>? notAdminLeaderboardModel;
  LeaderboardModel? score4User;

  Future<void> getScore4User(int userId) async {
    score4User = null;
    for (int i = 0; i < leaderboardModel!.length; i++) {
      if (leaderboardModel![i].id == userId) {
        score4User = leaderboardModel![i];
        // emit(GetScore4User());
      }
    }
    for (int i = 0; i < notAdminLeaderboardModel!.length; i++) {
      if (notAdminLeaderboardModel![i].id == userId) {
        score4User?.userRank = i + 1;
        // emit(GetScore4User());
      }
    }
  }

  Future? getLeaderboard(currentSemester) {
    notAdminLeaderboardModel = [];
    leaderboardModel = [];
    emit(GetLeaderboardLoadingState());
    DioHelp.getData(
      path: LEADERBOARD,
      query: {KeysManager.semester: currentSemester}).then((value) {
      value.data.forEach((element) {
        // exclude the admin
        if (element[StringsManager.role] != KeysManager.admin && element[StringsManager.role] != KeysManager.developer) {
          notAdminLeaderboardModel?.add(LeaderboardModel.fromJson(element));
        }
        else{
          leaderboardModel?.add(LeaderboardModel.fromJson(element)); //just to get the score of Admin
        }
      });

      notAdminLeaderboardModel!.sort((a, b) => b.score!.compareTo(a.score!));
      if (profileModel != null) {
        getScore4User(profileModel!.id);
      } else {
        // print("object");
      }
      emit(GetLeaderboardSuccessState());
    }).catchError((onError) {
      print(onError.toString());

      emit(GetLeaderboardErrorState());
    });
    return null;
  }

  void updateSemester4all() {
    DioHelp.getData(path: KeysManager.users).then((onValue) {
      onValue.data.forEach((element) {
        if (element[KeysManager.semester] == StringsManager.one) {
          updateUser(
              userID: element[KeysManager.id], semester: StringsManager.two);
        }
        if (element[KeysManager.semester] == StringsManager.two) {
          updateUser(
              userID: element[KeysManager.id], semester: StringsManager.three);
        }
        if (element[KeysManager.semester] == StringsManager.three) {
          updateUser(
              userID: element[KeysManager.id], semester: StringsManager.four);
        }
        if (element[KeysManager.semester] == StringsManager.four) {
          updateUser(
              userID: element[KeysManager.id], semester: StringsManager.five);
        }
        if (element[KeysManager.semester] == StringsManager.five) {
          updateUser(
              userID: element[KeysManager.id], semester: StringsManager.six);
        }
      });
      emit(GetUserImageSuccess());
    });
  }

  updateUser({
    required int userID,
    String? semester,
    String? fcmToken,
    String? photo,
  }) {
    DioHelp.putData(
        token: AppConstants.TOKEN,
        query: {KeysManager.id: userID},
        path: KeysManager.users,
        data: {
          if (semester != null) KeysManager.semester: semester,
          if (fcmToken != null) KeysManager.fcmToken: fcmToken,
          if (photo != null) KeysManager.photo: photo
        }).then((val) {
      print(val.data[KeysManager.id]);
      emit(UpdateUserSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(UpdateUserErrorState());
    });
  }
}
