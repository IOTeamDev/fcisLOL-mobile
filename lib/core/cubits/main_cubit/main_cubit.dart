import 'dart:ffi';
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
import 'package:lol/features/previous_exams/data/previous_exams_model.dart';
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
  bool isBottomSheetShown = false;

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
      showToastMessage(
          message: StringsManager.imgPickedSuccessfully,
          states: ToastStates.SUCCESS);
      emit(GetAnnouncementImageSuccess());
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
      final response =
          await DioHelp.getData(path: CURRENTUSER, token: AppConstants.TOKEN);
      profileModel = ProfileModel.fromJson(response.data);
      AppConstants.SelectedSemester = profileModel!.semester;
      await Cache.writeData(
          key: KeysManager.semester, value: profileModel!.semester);

      emit(GetProfileSuccess());
    } catch (e) {
      print(e.toString());

      emit(GetProfileFailure());
    }
  }

  ProfileModel? otherProfile;
  Future<void> getOtherProfile(id) async {
    emit(GetProfileLoading());
    otherProfile = null;
    await DioHelp.getData(
        path: USERS,
        query: {KeysManager.id: id ?? 1, KeysManager.haveMaterial: true}).then(
      (value) {
        print(value.data);
        otherProfile = ProfileModel.fromJson(value.data);
        emit(GetProfileSuccess());
      },
    );
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
  Future<void> getRequests(
      {required String semester, bool isAccepted = false}) async {
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

  Map<String, List<MaterialModel>> allSemestersRequests = {};
  List<MaterialModel> allRequests = [];
  Future<void> getAllSemestersRequests() async {
    allSemestersRequests.clear();
    allRequests.clear();
    emit(GetRequestsLoadingState());
    try {
      for (var semester in AppConstants.semesters) {
        dynamic response = await DioHelp.getData(
          path: MATERIAL,
          query: {KeysManager.semester: semester, KeysManager.accepted: false},
        );
        allSemestersRequests[semester] = [];

        for (var element in response.data) {
          allSemestersRequests[semester]!.add(MaterialModel.fromJson(element));
        }
        ;
      }
      allRequests = allSemestersRequests.values.expand((e) => e).toList();
      emit(GetRequestsSuccessState());
    } catch (e) {
      emit(GetRequestsErrorState());
    }
  }

  void deleteMaterial(int id, semester, {role, isMaterial = false}) {
    emit(DeleteMaterialLoadingState());
    DioHelp.deleteData(
            path: MATERIAL,
            data: {KeysManager.id: id},
            token: AppConstants.TOKEN)
        .then((value) {
      emit(DeleteMaterialSuccessState());
      if (role == KeysManager.developer) {
        getAllSemestersRequests();
      } else {
        getRequests(semester: semester, isAccepted: isMaterial);
      }
    });
  }

  Future<void> acceptRequest(int id, [semester, role]) async {
    emit(AcceptRequestLoadingState());
    try {
      await DioHelp.getData(
          path: ACCEPT,
          query: {KeysManager.id: id, KeysManager.accepted: true},
          token: AppConstants.TOKEN);
      emit(AcceptRequestSuccessState());
      if (role == KeysManager.developer) {
        getAllSemestersRequests();
      } else {
        getRequests(semester: semester);
      }
    } catch (e) {
      emit(AcceptRequestErrorState());
    }
  }

  List<LeaderboardModel>? leaderboardModel;
  List<LeaderboardModel>? notAdminLeaderboardModel;

  Future? getLeaderboard(currentSemester) {
    notAdminLeaderboardModel = [];
    leaderboardModel = [];
    emit(GetLeaderboardLoadingState());
    DioHelp.getData(
        path: LEADERBOARD,
        query: {KeysManager.semester: currentSemester}).then((value) {
      value.data.forEach((element) {
        // exclude the admin
        if (element[StringsManager.role] != KeysManager.admin &&
            element[StringsManager.role] != KeysManager.developer) {
          notAdminLeaderboardModel?.add(LeaderboardModel.fromJson(element));
        } else {
          leaderboardModel?.add(LeaderboardModel.fromJson(
              element)); //just to get the score of Admin
        }
      });

      notAdminLeaderboardModel!.sort((a, b) => b.score!.compareTo(a.score!));
      emit(GetLeaderboardSuccessState());
    }).catchError((onError) {
      print(onError.toString());

      emit(GetLeaderboardErrorState());
    });
    return null;
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
        path: USERS,
        data: {
          if (semester != null) KeysManager.semester: semester,
          if (fcmToken != null) KeysManager.fcmToken: fcmToken,
          if (photo != null) KeysManager.photo: photo
        }).then((val) {
      emit(UpdateUserSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(UpdateUserErrorState());
    });
  }

  Future<void> deleteAccount({required int id}) async {
    emit(DeleteAccountLoading());
    try {
      await DioHelp.deleteData(
          path: USERS, token: AppConstants.TOKEN, query: {KeysManager.id: id});
      await Cache.removeValue(key: KeysManager.token);
      await Cache.removeValue(key: KeysManager.semester);

      AppConstants.TOKEN = null;
      AppConstants.SelectedSemester = null;
      emit(DeleteAccountSuccessState());
    } catch (e) {
      emit(DeleteAccountFailed(errMessage: e.toString()));
    }
  }

  void sendReportBugOrFeedBack(message, {bool isFeedback = false}) {
    DioHelp.postData(
            path: REPORT,
            data: {'name': profileModel?.name ?? 'Guest', 'message': message})
        .then((value) {
      emit(SendingReportOrFeedBackSuccessState());
      showToastMessage(
          message:
              '${isFeedback ? 'Feedback' : 'Bug Report'} Sent Successfully!',
          states: ToastStates.SUCCESS);
    });
  }

  void changeBottomSheetState(isShown) {
    isBottomSheetShown = isShown;
    emit(ChangeBottomSheetState());
  }

  List<PreviousExamModel> previousExamsFinal = [];
  List<PreviousExamModel> previousExamsMid = [];
  List<PreviousExamModel> previousExamsOther = [];
  void getPreviousExams(subject, {bool accepted = true}) {
    emit(GetPreviousExamsLoadingState());
    DioHelp.getData(path: PREVIOUSEXAMS, query: {
      KeysManager.accepted: accepted,
      KeysManager.subject: subject
    }).then((value) {
      previousExamsFinal = [];
      previousExamsMid = [];
      previousExamsOther = [];
      value.data.forEach((element) {
        if (element['type'] == 'Final')
          previousExamsFinal.add(PreviousExamModel.fromJson(element));
        if (element['type'] == 'Mid')
          previousExamsMid.add(PreviousExamModel.fromJson(element));
        if (element['type'] == 'Other')
          previousExamsOther.add(PreviousExamModel.fromJson(element));
      });
      emit(GetPreviousExamsSuccessState());
    });
  }

  void editPreviousExam(id, title, link, semester, subject, type){
    emit(EditPreviousExamsLoadingState());
    print(AppConstants.TOKEN);
    print(id);
    print(title);
    print(link);
    print(semester);
    print(subject);
    print(type);
    DioHelp.patchData(
      path: EDITPREVIOUSEXAMS,
      token: AppConstants.TOKEN,
      data: {
        'id':id,
        'title':title,
        'link':link,
        'semester':semester,
        'subject':subject,
        'type':type,
      }
    ).then((value){
      showToastMessage(message: 'Exam Edited Successfully', states: ToastStates.SUCCESS);
      emit(EditPreviousExamsSuccessState());
      getPreviousExams(subject);
    });
  }

  void deletePreviousExam(id, subject){
    emit(DeletePreviousExamsLoadingState());
    DioHelp.deleteData(
      token: AppConstants.TOKEN,
      path: PREVIOUSEXAMS,
      data: {
        KeysManager.id:id
      }
    ).then((value){
      emit(DeletePreviousExamsSuccessState());
      getPreviousExams(subject);
    });
  }

  void addPreviousExam(
    String title,
    String link,
    String semester,
    String subject,
    String currentSubject,
    String type,
  ) {
    emit(AddPreviousExamsLoadingState());
    DioHelp.postData(token: AppConstants.TOKEN, path: PREVIOUSEXAMS, data: {
      'title': title,
      'link': link,
      'semester': semester,
      'subject': subject,
      'type': type
    }).then((value) {
      if (currentSubject == subject &&
          (profileModel!.role == KeysManager.developer ||
              profileModel!.role == KeysManager.admin)) {
        getPreviousExams(subject);
        showToastMessage(
            message: 'Exam Added Successfully', states: ToastStates.SUCCESS);
      } else {
        showToastMessage(
            message: 'Exam Added Successfully, and Waiting for Admin Approval',
            states: ToastStates.SUCCESS);
      }
      emit(AddPreviousExamsSuccessState());
    });
  }
}
