import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lol/core/data/local_data_provider.dart';
import 'package:lol/core/dependency_injection/service_locator.dart';
import 'package:lol/core/models/current_user/current_user_model.dart';
import 'package:lol/core/models/leaderboard/leaderboard_model.dart';
import 'package:lol/core/resources/theme/values/app_strings.dart';
import 'package:lol/core/resources/theme/themes_manager.dart';

import 'package:lol/core/utils/components.dart';
import 'package:lol/core/resources/constants/constants_manager.dart';
import 'package:lol/core/presentation/cubits/main_cubit/main_cubit_states.dart';
import 'package:lol/core/models/profile/profile_model.dart';
import 'package:lol/features/auth/domain/repos/auth_repo.dart';
import 'package:lol/features/auth/domain/use_cases/delete_account_use_case.dart';
import 'package:lol/features/auth/domain/use_cases/logout_use_case.dart';
import 'package:lol/features/auth/presentation/view/choosing_year/choosing_year.dart';
import 'package:lol/features/home/presentation/view/home.dart';
import 'package:lol/core/network/endpoints.dart';
import 'package:lol/core/network/remote/dio.dart';
import 'package:lol/core/utils/navigation.dart';
import 'package:lol/core/network/local/shared_preference.dart';
import 'package:lol/core/models/admin/requests_model.dart';
import 'package:lol/core/models/admin/announcement_model.dart';
import 'package:lol/features/previous_exams/data/previous_exams_model.dart';
import 'package:lol/features/subject/data/models/material_model.dart';
import '../../app_icons.dart';
import '../../../resources/theme/values/values_manager.dart';

//uid null?
class MainCubit extends Cubit<MainCubitStates> {
  MainCubit() : super(InitialMainState());
  static MainCubit get(context) => BlocProvider.of(context);
  IconData? pickerIcon = AppIcons.imageIcon;
  String? imageName = AppStrings.selectImage;
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

  File? announcementImageFile;
  String? announcementImagePath;
  getAnnouncementImage() async {
    emit(GetAnnouncementImageLoading());
    pickerIcon = AppIcons.imageIcon;
    imageName = AppStrings.selectImage;

    var tempPostImage = await picker.pickImage(source: ImageSource.gallery);
    if (tempPostImage != null) {
      announcementImageFile = File(tempPostImage.path);
      pickerIcon = AppIcons.closeIcon;
      imageName = tempPostImage.path.split(AppStrings.forwardSlash).last;
      showToastMessage(
          message: AppStrings.imgPickedSuccessfully,
          states: ToastStates.SUCCESS);
      emit(GetAnnouncementImageSuccess());
    } else {
      imageName = AppStrings.selectImage;
      pickerIcon = AppIcons.imageIcon;
      emit(GetAnnouncementImageFailure());
    }
  }

  ProfileModel? profileModel;
  Future<void> getProfileInfo() async {
    emit(GetProfileLoading());
    try {
      final response = await DioHelp.getData(
          path: Endpoints.CURRENTUSER, token: AppConstants.TOKEN);
      profileModel = ProfileModel.fromJson(response.data);
      AppConstants.SelectedSemester = profileModel!.semester;
      await Cache.writeData(
          key: KeysManager.semester, value: profileModel!.semester);
      print(AppConstants.TOKEN);
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
        path: Endpoints.USERS,
        query: {KeysManager.id: id ?? 1, KeysManager.haveMaterial: true}).then(
      (value) {
        print(value.data);
        otherProfile = ProfileModel.fromJson(value.data);
        emit(GetProfileSuccess());
      },
    );
  }

  Future<void> logout() async {
    try {
      final result = await getIt<LogoutUseCase>().call();
      result.fold(
        (failure) {
          emit(LogoutFailed(errMessage: failure.message));
        },
        (_) {
          profileModel = null;
          previousExamsMid.clear();
          previousExamsFinal.clear();
          previousExamsOther.clear();

          emit(LogoutSuccess());
        },
      );
    } catch (e) {
      emit(LogoutFailed(errMessage: AppStrings.unknownErrorMessage));
    }
  }

  List<MaterialModel>? requests;
  Future<void> getRequests(
      {required String semester, bool isAccepted = false}) async {
    emit(GetRequestsLoadingState());
    try {
      final response = await DioHelp.getData(
        path: Endpoints.MATERIAL,
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
      for (var semester in LocalDataProvider.semesters) {
        dynamic response = await DioHelp.getData(
          path: Endpoints.MATERIAL,
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
            path: Endpoints.MATERIAL,
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
          path: Endpoints.ACCEPT,
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

  List<LeaderboardModel>? notAdminLeaderboardModel;

  Future? getLeaderboard(currentSemester) {
    notAdminLeaderboardModel = [];
    emit(GetLeaderboardLoadingState());
    DioHelp.getData(
        path: Endpoints.LEADERBOARD,
        query: {KeysManager.semester: currentSemester}).then((value) {
      value.data.forEach((element) {
        // exclude the admin
        if (element[AppStrings.role] != KeysManager.admin &&
            element[AppStrings.role] != KeysManager.developer) {
          notAdminLeaderboardModel?.add(LeaderboardModel.fromJson(element));
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
        path: Endpoints.USERS,
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

  updateCurrentUser({
    String? semester,
    String? email,
    String? photo,
    String? password,
    String? phone,
    String? name,
  }) {
    DioHelp.patchData(token: AppConstants.TOKEN, path: Endpoints.USERS, data: {
      if (semester != null) KeysManager.semester: semester,
      if (email != null) KeysManager.email: email,
      if (photo != null) KeysManager.photo: photo,
      if (photo != null) KeysManager.name: name,
      if (photo != null) KeysManager.password: password,
      if (photo != null) KeysManager.phone: phone,
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
      final result = await getIt<DeleteAccountUseCase>().call(userId: id);
      result.fold(
        (failure) {
          emit(DeleteAccountFailed(errMessage: failure.message));
        },
        (_) {
          emit(DeleteAccountSuccessState());
        },
      );
    } catch (e) {
      debugPrint(e.toString());
      emit(DeleteAccountFailed(errMessage: AppStrings.unknownErrorMessage));
    }
  }

  void sendReportBugOrFeedBack(message, {bool isFeedback = false}) {
    DioHelp.postData(
            path: Endpoints.REPORT,
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
    DioHelp.getData(path: Endpoints.PREVIOUSEXAMS, query: {
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

  void editPreviousExam(id, title, link, semester, subject, type) {
    emit(EditPreviousExamsLoadingState());
    print(AppConstants.TOKEN);
    print(id);
    print(title);
    print(link);
    print(semester);
    print(subject);
    print(type);
    DioHelp.patchData(
        path: Endpoints.EDITPREVIOUSEXAMS,
        token: AppConstants.TOKEN,
        data: {
          'id': id,
          'title': title,
          'link': link,
          'semester': semester,
          'subject': subject,
          'type': type,
        }).then((value) {
      showToastMessage(
          message: 'Exam Edited Successfully', states: ToastStates.SUCCESS);
      emit(EditPreviousExamsSuccessState());
      getPreviousExams(subject);
    });
  }

  void deletePreviousExam(id, subject) {
    emit(DeletePreviousExamsLoadingState());
    DioHelp.deleteData(
        token: AppConstants.TOKEN,
        path: Endpoints.PREVIOUSEXAMS,
        data: {KeysManager.id: id}).then((value) {
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
    DioHelp.postData(
        token: AppConstants.TOKEN,
        path: Endpoints.PREVIOUSEXAMS,
        data: {
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
