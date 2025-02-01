import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:lol/main.dart';
import 'package:lol/core/utils/components.dart';

class FCMHelper {
  // creat instance of fbm
  static final _firebaseMessaging = FirebaseMessaging.instance;

  // initialize notifications for this app or device
  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    // get device token
    String? deviceToken = await _firebaseMessaging.getToken();
    print(
        "===================Device FirebaseMessaging Token====================");
    print(deviceToken);
    print(
        "===================Device FirebaseMessaging Token====================");
  }

  Future<String?> getAccessToken() async {
    print("$private_key_id---------");
    print(private_key);

    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "fcis-da7f4",
      "private_key_id": private_key_id,
      "private_key": private_key,
      "client_email":
          "firebase-adminsdk-7wunf@fcis-da7f4.iam.gserviceaccount.com",
      "client_id": "114518216051661235216",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-7wunf%40fcis-da7f4.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    try {
      http.Client client = await auth.clientViaServiceAccount(
          auth.ServiceAccountCredentials.fromJson(serviceAccountJson), scopes);

      auth.AccessCredentials credentials =
          await auth.obtainAccessCredentialsViaServiceAccount(
              auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
              scopes,
              client);

      client.close();
      print(
          "Access Token: ${credentials.accessToken.data}"); // Print Access Token
      return credentials.accessToken.data;
    } catch (e) {
      print("Error getting access token: $e");
      return null;
    }
  }

  // handle notifications when received
  void handleMessages(RemoteMessage? message) {
    if (message != null) {
      // navigatorKey.currentState?.pushNamed(NotificationsScreen.routeName, arguments: message);
      showToastMessage(
        message: "on Background Message notification",
        states: ToastStates.SUCCESS,
      );
    }
  }

  // handel notifications in case app is terminated
  void handleBackgroundNotifications() async {
    FirebaseMessaging.instance.getInitialMessage().then((handleMessages));
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessages);
  }

  Map<String, dynamic> getBody({
    required String fcmToken,
    required String title,
    required String body,
  }) {
    return {
      "message": {
        "token": fcmToken,
        "notification": {
          "title": title,
          "body": body,
        },
        "android": {
          "notification": {
            "notification_priority": "PRIORITY_MAX",
            "sound": "default",
            "icon":
                "notification_icon", // Add your icon name here without the extension
          },
        },
        "apns": {
          "payload": {
            "aps": {"content_available": true},
          },
        },
      },
    };
  }

  Future<void> sendNotifications({
    required String fcmToken,
    required String title,
    required String body,
  }) async {
    try {
      var serverKeyAuthorization = await getAccessToken();

      print("${serverKeyAuthorization}dsfgsdg");

      // change your project id
      const String urlEndPoint =
          "https://fcm.googleapis.com/v1/projects/fcis-da7f4/messages:send";

      Dio dio = Dio();
      dio.options.headers['Content-Type'] = 'application/json';
      dio.options.headers['Authorization'] = 'Bearer $serverKeyAuthorization';

      var response = await dio.post(
        urlEndPoint,
        data: getBody(
          fcmToken: fcmToken,
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
}
