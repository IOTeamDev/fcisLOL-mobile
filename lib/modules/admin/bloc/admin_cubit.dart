import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

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

import '../../../layout/home/bloc/main_cubit_states.dart';
import '../../../models/profile/profile_model.dart';
import '../../../shared/components/constants.dart';
import '../../../shared/components/navigation.dart';
import '../../../shared/network/local/shared_prefrence.dart';
import '../../auth/bloc/login_cubit.dart';
import '../../year_choose/choosing_year.dart';

//uid null?
class AdminCubit extends Cubit<AdminCubitStates> {
  AdminCubit() : super(InitialAdminState());

  static AdminCubit get(context) => BlocProvider.of(context);

  List<FcmToken> fcmTokens = [];

  Future<void>? getFcmTokens() {
    DioHelp.getData(path: "users").then(
      (value) {
        value.data.forEach((element) {
          fcmTokens.add(FcmToken.fromJson(element));
        });

        emit(GetFcmTokensSuccess());
      },
    ).catchError((onError) => GetFcmTokensError());
  }

  AnnouncementModel? announcementModel;
  void addAnnouncement(
      {required title,
      description,
      required dueDate,
      required type,
      String? notificationTitle,
      image,
      required currentSemester}) {
    emit(AdminSaveAnnouncementLoadingState());
    DioHelp.postData(
            path: ANNOUNCEMENTS,
            data: {
              'title': title,
              'content': description ?? '',
              'due_date': dueDate,
              'type': type,
              'semester': currentSemester,
              'image': image
            },
            token: TOKEN)
        .then((value) {
      //announcementModel = AnnouncementModel.fromJson(value.data);
      sendNotificationToUsers(
          semester: currentSemester,
          title: notificationTitle ?? "Don't Miss That !",
          body: title); // LOL

      emit(AdminSaveAnnouncementSuccessState());
      getAnnouncements();
    }).catchError((error) {
      emit(AdminSaveAnnouncementsErrorState(error));
    });
  }

  List<AnnouncementModel>? announcements;
  void getAnnouncements() {
    emit(AdminGetAnnouncementLoadingState());
    DioHelp.getData(path: ANNOUNCEMENTS).then((value) {
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

  void deleteAnnouncement(int id) {
    emit(AdminDeleteAnnouncementLoadingState());
    DioHelp.deleteData(path: ANNOUNCEMENTS, token: TOKEN, query: {'id': id})
        .then((value) {
      emit(AdminDeleteAnnouncementSuccessState());
      getAnnouncements();
    });
  }

  Future<void> sendFCMNotification({
    required String title,
    required String body,
    required String token,
  }) async {
    const String serverKey = 'YOUR_SERVER_KEY';
    const String fcmEndpoint = 'https://fcm.googleapis.com/fcm/send';

    final Map<String, dynamic> notification = {
      "to": token,
      "notification": {
        "title": title,
        "body": body,
      },
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id": "1",
        "status": "done"
      }
    };

    http
        .post(Uri.parse(fcmEndpoint),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization': 'key=$serverKey',
            },
            body: jsonEncode(notification))
        .then((onValue) {
      if (onValue.statusCode == 200)
        print('Notification sent successfully');
      else
        print('Failed to send notification: ${onValue.body}');
    }).catchError((onError) => print(onError.toString()));
  }

  void sendNotificationToUsers(
      {required String semester,
      required String title,
      required String body}) async {
    await getFcmTokens();

    // Filter users whose semester is three
    List<FcmToken> filteredUsers =
        fcmTokens.where((user) => user.semester == semester).toList();

    for (var user in filteredUsers) {
      if (user != null)
        sendFCMNotification(title: title, body: body, token: user.fcmToken);
    }
  }
}
