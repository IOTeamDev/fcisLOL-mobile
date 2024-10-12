import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:lol/shared/components/components.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_time_patterns.dart';
import 'package:lol/models/fcm_model.dart';
import 'package:lol/modules/admin/bloc/admin_cubit_states.dart';
import 'package:lol/models/admin/announcement_model.dart';
import 'package:lol/models/admin/requests_model.dart';
import 'package:lol/modules/admin/screens/announcements/add_announcement.dart';
import 'package:lol/models/login/login_model.dart';
import 'package:lol/shared/components/components.dart';
import 'package:lol/shared/network/endpoints.dart';
import 'package:lol/shared/network/remote/dio.dart';
import 'package:lol/shared/network/remote/fcm_helper.dart';

import '../../../layout/home/bloc/main_cubit_states.dart';
import '../../../models/profile/profile_model.dart';
import '../../../shared/components/constants.dart';
import '../../../shared/components/navigation.dart';
import '../../../shared/network/local/shared_prefrence.dart';
import '../../../shared/network/remote/fcm_helper.dart';
import '../../auth/bloc/login_cubit.dart';
import '../../year_choose/choosing_year.dart';

//uid null?
class AdminCubit extends Cubit<AdminCubitStates> {
  AdminCubit() : super(InitialAdminState());

  static AdminCubit get(context) => BlocProvider.of(context);

  List<FcmToken> fcmTokens = [];
//List of notifications messages
  Future? getFcmTokens() {
    print("object");
    DioHelp.getData(path: "users").then(
      (value) {
        value.data.forEach((element) {
          fcmTokens.add(FcmToken.fromJson(element));
          // print(fcmTokens[1].semester);
        });
        // fcmTokens.forEach((element) {
        //   if (element.name == "phone") print(element.semester);
        // });
        emit(GetFcmTokensSuccess());
      },
    ).catchError((onError) {
      print(onError.toString());
      emit(GetFcmTokensError());
    });
  }

  AnnouncementModel? announcementModel;
  List<String> notificationsTitles = [
    "New update: Take a look!",
    "Don't Miss That!!!",
    "Take a look at what's new!",
    "Something new is waiting for you!",
    "Just added: Check it out!",
    "We have something new for you! Take a look!",
    "Be the First to Know!",
  ];
  void addAnnouncement(
      {required title,
      description,
      dueDate,
      required type,
      image,
      required currentSemester}) {
    Random random = Random();

    // Get a random index
    int randomIndex = random.nextInt(notificationsTitles.length);
    emit(AdminSaveAnnouncementLoadingState());
    DioHelp.postData(
            path: ANNOUNCEMENTS,
            data: {
              'title': title,
              'content': description ?? '',
              'due_date': dueDate,
              'type': type,
              'semester': currentSemester,
              'image': image??'https://firebasestorage.googleapis.com/v0/b/fcis-da7f4.appspot.com/o/140.jpg?alt=media&token=3e5a4144-20ca-44ce-ba14-57432e49914f'
            },
            token: TOKEN
    ).then((value) {
      sendNotificationToUsers(
          semester: currentSemester,
          title: notificationsTitles[randomIndex],
          body: title
      ); // LOL
      emit(AdminSaveAnnouncementSuccessState());
      getAnnouncements(currentSemester);
    });
  }

  List<AnnouncementModel>? announcements;
  void getAnnouncements(String semester) {
    announcements = null;
    print(SelectedSemester.toString());
    emit(AdminGetAnnouncementLoadingState());
    DioHelp.getData(path: ANNOUNCEMENTS, query: {'semester': semester})
        .then((value) {
      announcements = [];
      value.data.forEach((element) {
        announcements!.add(AnnouncementModel.fromJson(element));
      });
      emit(AdminGetAnnouncementSuccessState(announcements!));
    });
  }

  void updateAnnouncement(final String id,
      {String? title,
      String? content,
      dynamic dueDate,
      String? type,
      required currentSemester}) {
    emit(AdminUpdateAnnouncementLoadingState());
    DioHelp.putData(
        path: ANNOUNCEMENTS,
        data: {
          'title': title,
          'content': content,
          'due_date': dueDate,
          'type': type,
          'semester': currentSemester
        },
        token: TOKEN,
        query: {'id': int.parse(id)}).then((value) {
      print(value.data);
      // Assuming the response returns the updated announcement
      AnnouncementModel updatedAnnouncement =
          AnnouncementModel.fromJson(value.data);

      // Update the local announcements list
      if (announcements != null) {
        int index = announcements!.indexWhere((ann) => ann.id.toString() == id);
        if (index != -1) {
          announcements![index] = updatedAnnouncement;
        }
      }
      emit(AdminUpdateAnnouncementSuccessState());
    }).catchError((error) {
      emit(AdminUpdateAnnouncementErrorState(error.toString()));
    });
  }

  void deleteAnnouncement(int id, semester) {
    emit(AdminDeleteAnnouncementLoadingState());
    DioHelp.deleteData(path: ANNOUNCEMENTS, token: TOKEN, query: {'id': id})
        .then((value) {
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

    print(serverKeyAuthorization.toString() + "dsfgsdg");

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
        .then((onValue) => emit(GetFcmTokensSuccess()))
        .catchError((onError) {
      print(onError.toString());
      emit(SendNotificationError());
    });

    // Print response status code and body for debugging
    //   print('Response Status Code: ${response.statusCode}');
    //   print('Response Data: ${response.data}');
    // } catch (e) {
    //   print("Error sending notification: $e");
    // }
  }

  Future<void> sendNotificationToUsers({
  required String semester,
  required String title,
  required String body,
}) async {
  // Wait for FCM tokens to be fetched
  // await getFcmTokens();

  // Ensure the tokens are fetched successfully and the list is populated
  if (fcmTokens.isEmpty) {
    print('No FCM tokens found');
  // await getFcmTokens();
  }

  print(fcmTokens.length); // Print the number of fetched tokens

  // Filter users based on semester
  List<FcmToken> filteredUsers = fcmTokens.where((user) => user.semester == semester).toList();

  if (filteredUsers.isEmpty) {
    print('No users found for semester: $semester');
    return; // Exit early if no users are found for the semester
  }

  // Send notifications to each user
  for (var user in filteredUsers) {
    if (user.fcmToken != null) {
      print('${user.semester} - Sending notification to: ${user.fcmToken}');
      await sendFCMNotification(title: title, body: body, token: user.fcmToken!);
    }
  }

  print('Notifications sent successfully');
}

}
