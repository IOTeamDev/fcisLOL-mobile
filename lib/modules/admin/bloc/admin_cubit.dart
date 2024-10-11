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
import 'package:lol/shared/network/remote/cloud_messeging.dart';
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
//List of notifications messages
  Future<void>? getFcmTokens() {
    print("object");
    DioHelp.getData(path: "users").then(
      (value) {
        value.data.forEach((element) {
          fcmTokens.add(FcmToken.fromJson(element));
          // print(fcmTokens[0].semester);
        });

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
    "Don't Miss That !",
    "Take a look at what's new!",
    "Something new is waiting for you!",
    "Just added: Check it out!",
    "We have something new for you! Take a look!",
    "Be the First to Know!",
  ];
  void addAnnouncement(
      {required title,
      description,
      required dueDate,
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
              'image': image
            },
            token: TOKEN)
        .then((value) {
      //announcementModel = AnnouncementModel.fromJson(value.data);
      sendNotificationToUsers(
          semester: currentSemester,
          title: notificationsTitles[randomIndex],
          body: title); // LOL

      emit(AdminSaveAnnouncementSuccessState());
      getAnnouncements(currentSemester);
    }).catchError((error) {
      emit(AdminSaveAnnouncementsErrorState(error));
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
  // Future<String?> getAccessToken() async {
  //   final serviceAccountJson = {
  //     "type": "service_account",
  //     "project_id": "fcis-da7f4",
  //     "private_key_id": "2dada9c2e127654c9161f89de3746e6a5d568c82",
  //     "private_key":
  //         "-----BEGIN PRIVATE KEY-----\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQC7MvhxTp5Gt3FW\nLMLa62hg/S6xKxjDFx1NYzolS6sZqflLV7pS4iJ6h/n+KZGpymB8wCed8K73aUwc\nHGNI4I2JuKQdPbifDvhyRf8TB6WuPJvciTZme5LginKL/B86lH0l5rC+Sc6HSm/r\nCc41RUpsnDkRlcGuifs2WNKpTM92atS7suORvmj+fJiBibRpLPL/STxl8mOz5Um8\nv8oiiruq1sM2XWzfBxxNZyJq7Mp3xvlZvM+DPIHkFpw/enfOGEOS4K9hrDaofCjX\nLteRMZ2wHNxLO8oQKVaMvC1K+PbGqRcNQYnU7cCZQSLo+ORqpPZokvJzpd7093bH\ngpfCI26bAgMBAAECggEAGL6xFpE03NYs1h5Ol4+cmY1+GY8/07H/fpZKPlnVQSw1\ntt7e00vvENFem1k1VwNYY8Umt3r0NeImXGToPt7n9reAghkBiYz6DGjyQbq2DOUY\nGTvOBBf7n1DNuXFXU3ADZvoqjMzGzx1o0+HU7ze8kcTIymlIU+ELYvC00ApGNjnJ\nB8OSKJHBLRCSTyJNrmutscMGoBh8C/tND+Y4GdMKeSJcNT9mJ1GXPYlkYjq4QdCR\nZu8XlFrswuUX2Kp5FBBp6NrswMULfqdytuW6QheGgy8slzxlnnBai09tBTVhHnhy\nPx6gUdbxz8FjwF9KRKaiRncobOQ11ZTD4DfY03IF6QKBgQDfm4FvuPodZuVqBcPq\njfSrfPedczzz8lCAkW6dnWfgHF6yNFrl6QUbmLR8T88VJcbdrRtGrfc4dvnz1azq\nEWH+7pcw6MwPIOuT5HBnMlrY+dlJQvfB9oL9vf/FadqvP4tXNa+hrCobcKLdUzl1\n66qFV0nj1zzRJYbZwPWzRGy2TwKBgQDWUUJyVeNcYedmwdlyAmxf0QV05LpWefB7\nLaSvV0TVG/bFVuRQcqG9Hni7N2w9iNKX3LmxKCz+E5s7d0xdSYmO7MfOcjP7kQ1k\n6u3sOVDLyIGUM8PflzZwGoj6Mm5DoapzK467YDGsd3RLYkxe7KUSNLvWFBo/58Wt\nVpUizi979QKBgQDQULAqZDrnL1glCM/3cV5ycM7CaXxsi9+Bl3tk7SK7v9Jc1Lem\nHws6JW5nrXZv7iyxkjaqByIdAYJlLjiUK7OO67oAv7Bzm6i8tAIfseK+5y0NuozU\nr5JjUCG7SZ2IzHtEuOgxhxIHVEz2QjVy7SWEaciVsYygEATsUn7UDrf0swKBgQCn\nOUBfdiSxMLMduqOwEbP+D1nym4XJc9vwQOz+41kR73/c+q+rFcadiekqK1SJrvij\nBdbeJDr3BNVa0PsEzxxGKPq+Wt20rLmGxMhgSViBqTFyMfHjxFj1n77BehgPLVWS\nB6qXCbe4mnxjVY/BgWRLkFn/8C+LLY1Qcv5q6fajAQKBgQC9oap3m0jhLhWBqx4L\nJvaIpzrhXUDpsbO8aaPPar0ZW18RtXP8mnWvcFKKaWupL11mn33bEGGdYMY7kAlR\n6Tm/J9PckKverXbYW1orXdg4qNbEgXuT2xWBXDxvUqEd42nFeDSCSzvfIhfHxn2A\nWq4gDLz/jEepVCFwHsdDGNLCcA==\n-----END PRIVATE KEY-----\n",
  //     "client_email":
  //         "firebase-adminsdk-7wunf@fcis-da7f4.iam.gserviceaccount.com",
  //     "client_id": "114518216051661235216",
  //     "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  //     "token_uri": "https://oauth2.googleapis.com/token",
  //     "auth_provider_x509_cert_url":
  //         "https://www.googleapis.com/oauth2/v1/certs",
  //     "client_x509_cert_url":
  //         "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-7wunf%40fcis-da7f4.iam.gserviceaccount.com",
  //     "universe_domain": "googleapis.com"
  //   };

  //   List<String> scopes = [
  //     "https://www.googleapis.com/auth/userinfo.email",
  //     "https://www.googleapis.com/auth/firebase.database",
  //     "https://www.googleapis.com/auth/firebase.messaging"
  //   ];

  //   try {
  //     http.Client client = await auth.clientViaServiceAccount(
  //         auth.ServiceAccountCredentials.fromJson(serviceAccountJson), scopes);

  //     auth.AccessCredentials credentials =
  //         await auth.obtainAccessCredentialsViaServiceAccount(
  //             auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
  //             scopes,
  //             client);

  //     client.close();
  //     print(
  //         "Access Token: ${credentials.accessToken.data}"); // Print Access Token
  //     return credentials.accessToken.data;
  //   } catch (e) {
  //     print("Error getting access token: $e");
  //     return null;
  //   }
  // }

  Future<void> sendFCMNotification({
    required String title,
    required String body,
    required String token,
  }) async {
    FCMHelper fCMHelper = FCMHelper();

    try {
      var serverKeyAuthorization = await fCMHelper.getAccessToken();

      print(serverKeyAuthorization.toString() + "dsfgsdg");

      // change your project id
      const String urlEndPoint =
          "https://fcm.googleapis.com/v1/projects/fcis-da7f4/messages:send";

      Dio dio = Dio();
      dio.options.headers['Content-Type'] = 'application/json';
      dio.options.headers['Authorization'] = 'Bearer $serverKeyAuthorization';

      var response = await dio.post(
        urlEndPoint,
        data: fCMHelper.getBody(
          fcmToken: token,
          title: title,
          body: body,
        ),
      );

      // Print response status code and body for debugging
      print('Response Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');
    } catch (e) {
      print("Error sending notification: $e");
    }
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
      if (user.fcmToken != null)
        sendFCMNotification(title: title, body: body, token: user.fcmToken!);
    }
  }
}
