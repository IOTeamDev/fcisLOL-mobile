import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:lol/core/data/local_data_provider.dart';
import 'package:lol/core/resources/theme/values/app_strings.dart';
import 'package:lol/core/resources/theme/values/values_manager.dart';
import 'package:lol/features/admin/presentation/view_model/admin_cubit/admin_cubit_states.dart';
import 'package:lol/core/utils/components.dart';
import 'dart:developer' as dev;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_time_patterns.dart';
import 'package:lol/core/models/fcm_model.dart';
import 'package:lol/core/models/admin/announcement_model.dart';
import 'package:lol/features/admin/presentation/view/announcements/add_announcement.dart';
import 'package:lol/features/auth/data/models/login_model.dart';
import 'package:lol/core/network/endpoints.dart';
import 'package:lol/core/network/remote/dio.dart';
import 'package:lol/core/network/remote/fcm_helper.dart';
import '../../../../../core/resources/constants/constants_manager.dart';
import '../../../../../core/utils/navigation.dart';
import '../../../../../core/network/local/shared_preference.dart';
import '../../../../auth/presentation/view/choosing_year/choosing_year.dart';
import '../../../../home/data/models/semster_model.dart';

//uid null?
class AdminCubit extends Cubit<AdminCubitStates> {
  AdminCubit() : super(InitialAdminState());

  static AdminCubit get(context) => BlocProvider.of(context);

  List<FcmToken> fcmTokens = [];
  List<FcmToken> adminFcmTokens = [];
//List of notifications messages
  Future? getFcmTokens() {
    DioHelp.getData(path: "users").then(
      (value) {
        value.data.forEach((element) {
          fcmTokens.add(FcmToken.fromJson(element));
          if (element['role'] == 'ADMIN') {
            adminFcmTokens.add(FcmToken.fromJson(element));
          }
        });
        // fcmTokens.forEach((element) {
        //   if (element.name == "phone") print(element.semester);
        // });
        for (var action in adminFcmTokens) {
          // sendFCMNotification(
          //     title: "title",
          //     body: "body",
          //     token:
          //         "chUAaG_7Tu68jnmU8UpxSN:APA91bHgHAocyXqRhWLeSw7NFepQMKaefT1i0ust8oQVvYsS1kt4OGk0wXHAqD3U6Erciw1IyPS5FUPNwxgkeNEXF4Q5W76GbTS-NZSexTaZNdLQCq1SZZzDkh23RHktWgqd7vBZLRRn");
          if (action.fcmToken != null) {}
        }
        emit(GetFcmTokensSuccess());
      },
    ).catchError((onError) {
      print(onError.toString());
      emit(GetFcmTokensError());
    });
    return null;
  }

  AnnouncementModel? announcementModel;
  List<String> notificationsTitles = [
    "New update: Take a look! 🔔",
    "Don't Miss That!!! 🚨",
    "Take a look at what's new! 👀",
    "Something new is waiting for you! 🎉",
    "Just added: Check it out! 🆕",
    "We have something new for you! Take a look! 🌟",
    "Be the First to Know! 🚀",
    "Exciting Update! Tap to Explore 📰",
    "A Little Surprise Just for You! 🎁",
    "Get the Scoop! Fresh News Inside 📢",
  ];
  Future<void> addAnnouncement(
      {required title,
      description,
      dueDate,
      required type,
      String? image,
      required currentSemester}) async {
    Random random = Random();
    // Get a random index
    int randomIndex = random.nextInt(notificationsTitles.length);

    emit(AdminSaveAnnouncementLoadingState());
    try {
      await DioHelp.postData(
          path: Endpoints.ANNOUNCEMENTS,
          data: {
            'title': title,
            'content': description ?? '',
            'due_date': dueDate ?? '',
            'type': type,
            'semester': currentSemester,
            'image': image ?? AppConstants.defaultImage
          },
          token: AppConstants.TOKEN);

      // sendNotificationToUsers(
      //     semester: currentSemester,
      //     title: notificationsTitles[randomIndex],
      //     body: title);
      emit(AdminSaveAnnouncementSuccessState());
    } catch (e) {
      debugPrint(e.toString());
      emit(AdminSaveAnnouncementsErrorState(e.toString()));
    }
  }

  List<AnnouncementModel> announcements = [];
  Future<void> getAnnouncements(String semester) async {
    emit(AdminGetAnnouncementLoadingState());
    try {
      announcements.clear();
      final response = await DioHelp.getData(
          path: Endpoints.ANNOUNCEMENTS,
          query: {KeysManager.semester: semester});
      response.data.forEach((element) {
        announcements.add(AnnouncementModel.fromJson(element));
      });

      emit(AdminGetAnnouncementSuccessState());
    } catch (e) {
      emit(AdminGetAnnouncementsErrorState(e.toString()));
    }
  }

  Map<String, List<AnnouncementModel>> allSemestersAnnouncements = {};
  List<AnnouncementModel> allAnnouncements = [];

  Future<void> getAllSemestersAnnouncements() async {
    emit(AdminGetAnnouncementLoadingState());
    try {
      allSemestersAnnouncements.clear();

      for (var semester in LocalDataProvider.semesters) {
        final response = await DioHelp.getData(
            path: Endpoints.ANNOUNCEMENTS,
            query: {KeysManager.semester: semester});
        allSemestersAnnouncements[semester] = [];
        for (var element in response.data) {
          allSemestersAnnouncements[semester]!
              .add(AnnouncementModel.fromJson(element));
        }
      }
      allAnnouncements =
          allSemestersAnnouncements.values.expand((e) => e).toList();
      emit(AdminGetAnnouncementSuccessState());
    } catch (e) {
      emit(AdminGetAnnouncementsErrorState(e.toString()));
    }
  }

  void updateAnnouncement(
    final int id, {
    String? title,
    String? content,
    dynamic dueDate,
    // String? type,
    //dynamic currentSemester,
    //String? image,
  }) {
    emit(AdminUpdateAnnouncementLoadingState());
    DioHelp.putData(
        path: Endpoints.ANNOUNCEMENTS,
        data: {
          AppStrings.title: title ?? "",
          AppStrings.content: content ?? "",
          AppStrings.dueDate: dueDate,
          //'type': type,
          //'semester': currentSemester,
          //'image': image,
        },
        token: AppConstants.TOKEN,
        query: {KeysManager.id: id}).then((value) {
      // Assuming the response returns the updated announcement
      AnnouncementModel updatedAnnouncement =
          AnnouncementModel.fromJson(value.data);

      // Update the local announcements list
      int index = announcements.indexWhere((ann) => ann.id == id);
      if (index != AppSizes.s1N) {
        announcements[index] = updatedAnnouncement;
      }
      emit(AdminUpdateAnnouncementSuccessState());
    });
  }

  void deleteAnnouncement(int id, semester) {
    emit(AdminDeleteAnnouncementLoadingState());
    DioHelp.deleteData(
        path: Endpoints.ANNOUNCEMENTS,
        token: AppConstants.TOKEN,
        query: {'id': id}).then((value) {
      emit(AdminDeleteAnnouncementSuccessState());
      getAnnouncements(semester);
    });
  }

  // FCMHelper fCMHelper = FCMHelper();

  Future<void> sendFCMNotification({
    required String title,
    required String body,
    required String token,
  }) async {
    FCMHelper fCMHelper = FCMHelper();

    await fCMHelper.initNotifications();
    var serverKeyAuthorization = await fCMHelper.getAccessToken();

    // change your project id
    const String urlEndPoint =
        "https://fcm.googleapis.com/v1/projects/fcis-da7f4/messages:send";

    Dio dio = Dio();
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer $serverKeyAuthorization';

    dio
        .post(
          urlEndPoint,
          data: fCMHelper.getBody(
            fcmToken: token,
            title: title,
            body: body,
          ),
        )
        .then((onValue) => emit(SendNotificationSuccess()))
        .catchError((onError) {
      print(onError.toString());
      emit(SendNotificationError());
    });
  }

  Future<void> sendNotificationToUsers({
    bool sendToAdmin = false,
    required String semester,
    required String title,
    required String body,
  }) async {
    // await FirebaseMessaging.instance.requestPermission();

    // Wait for FCM tokens to be fetched
    // await getFcmTokens();

    // Ensure the tokens are fetched successfully and the list is populated
    if (!sendToAdmin) {
      if (fcmTokens.isEmpty) {
        print('No FCM tokens found');
        // await getFcmTokens();
      }

      // Filter users based on semester
      List<FcmToken> filteredUsers =
          fcmTokens.where((user) => user.semester == semester).toList();

      if (filteredUsers.isEmpty) {
        print('No users found for semester: $semester');
        return; // Exit early if no users are found for the semester
      }

      // Send notifications to each user
      for (var user in filteredUsers) {
        if (user.fcmToken != null) {
          print('${user.semester} - Sending notification to: ${user.fcmToken}');
          await sendFCMNotification(
              title: title, body: body, token: user.fcmToken!);
        }
      }
    } else {
      List<FcmToken> filteredUsers =
          adminFcmTokens.where((user) => user.semester == semester).toList();
      if (filteredUsers.isEmpty) {
        print('No users found for semester: $semester');
        return; // Exit early if no users are found for the semester
      }
      for (var user in filteredUsers) {
        if (user.fcmToken != null) {
          print(
              '${user.semester} - Sending notification to: ${user.name}================================================================');
          await sendFCMNotification(
              title: title, body: body, token: user.fcmToken!);
        }
      }
    }
  }

  File? announcementImageFile;
  String? announcementImagePath;
  IconData pickerIcon = Icons.image;
  String imageName = 'Select Image';
  static const announcementsImagesFolder = 'announcements_images';
  var picker = ImagePicker();
  final _storageRef = FirebaseStorage.instance.ref();

  getAnnouncementImage() async {
    emit(ImagePickingLoadingState());

    var tempPostImage = await picker.pickImage(source: ImageSource.gallery);
    if (tempPostImage != null) {
      announcementImageFile = File(tempPostImage.path);
      imageName = tempPostImage.path.split('/').last;
      pickerIcon = Icons.clear;
      showToastMessage(
          message: 'Imaged Picked Successfully', states: ToastStates.SUCCESS);
      emit(ImagePickingSuccessState());
    } else {
      pickerIcon = Icons.image;
      imageName = 'Select Image';
      emit(ImagePickingErrorState());
    }
  }

  Future<void> uploadImage({File? image}) async {
    emit(UploadImageLoadingState());
    if (image == null) return;
    try {
      final pathRef = _storageRef
          .child('$announcementsImagesFolder/${image.path.split('/').last}');

      UploadTask uploadTask = pathRef.putFile(File(image.path));

      final snapshot = await uploadTask.whenComplete(() => null);
      final imageUrl = await snapshot.ref.getDownloadURL();
      announcementImagePath = imageUrl;
      emit(UploadImageSuccessState());
    } on FirebaseException catch (e) {
      String errMessage;
      if (e.code == 'canceled') {
        errMessage = 'Operation canceled';
      } else if (e.code == 'object-not-found') {
        errMessage = 'Object not found';
      } else if (e.code == 'retry-limit-exceeded') {
        errMessage =
            'The maximum time limit on an operation has been excceded. Try uploading again.';
      } else {
        errMessage = 'Opps. Unknown error occured!';
      }
      emit(UploadImageErrorState(errMessage: errMessage));
    } catch (e) {
      emit(UploadImageErrorState(errMessage: e.toString()));
      return null;
    }
  }

  Future<void> deleteImage({required String image}) async {
    try {
      final String imageName = getImageNameFromUrl(imageUrl: image);
      final pathRef =
          _storageRef.child('${announcementsImagesFolder}/${imageName}');
      await pathRef.delete();
    } on FirebaseException catch (e) {
      String errMessage;
      if (e.code == 'canceled') {
        errMessage = 'Operation canceled';
      } else if (e.code == 'object-not-found') {
        errMessage = 'Object not found';
      } else if (e.code == 'retry-limit-exceeded') {
        errMessage =
            'The maximum time limit on an operation has been excceded. Try uploading again.';
      } else {
        errMessage = 'Opps. Unknown error occured!';
      }
      debugPrint(errMessage);
    } catch (e) {
      return debugPrint(e.toString());
    }
  }
}
