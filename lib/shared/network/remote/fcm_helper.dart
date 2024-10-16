import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:lol/shared/components/components.dart';

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
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "fcis-da7f4",
      "private_key_id": "790cfc197c9f0fd271275774af95467ee4c50055",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQD9nEbJ6q6JRtZL\nqJiTtZDdLd5IgTfoj7WvoVDpFoZJcquNDGjFQPgjsgQcFgCeKq9zNcrYqJtc93Cp\nKz60fDOkMiD+UJKl/uc1zO0cmNzTl8wbCooMEvaynli1Apzw3FgUog9vEnWqzYi+\njIim8oPFS+8rPWMxR7off6+0sMZzIUxM06ZQ+M2vU0bcZ3PN0GwMvhGHEY4LLK/v\nRv68Qrc1Gov5Tlk7uyIvfawm3Li9UstELg2YJDbCuye3ZtpTkMTvDkjq+qGb8NxV\njhEExeDfoYk9fj4SNCd4/2s5J8kxYNUjOWNPEhAjX71SeJYM5gjm1KUjV0kmjhhA\nNu4s3KFpAgMBAAECggEAAiSyWPXDqpuXh01qF7J8wk/HTYXRDQU85/p1KnkjIqcG\nUeN5VbRwPG3+WKXrdKq/75l0aMsZAArD0BwyVBhqH9DAJGIWMTKzrcnY9alJkXy6\nj/5xbvtwjA8oSQRYAvWbxXXeq0XEypAg4BpkM8QALthO0cbbqiCU7zv3Jk/pp3Kr\n6bdkMIOqBh7j+Zs4zqodic1FGaIm87XTSuLBsYKMaz3SBTQw+/srLn4nn0iv/RBZ\nOvOkCbuHBx22Kf2DLNLn83lts7yKJn5N2hkztnp56afRRxmbmUM4wwRW7Ua6o6kl\n/rV70ZAIi68GsHTztHkD5kwYbUbKcMOnbPli26184QKBgQD+6pPPy7prAohRod2Z\n4GkmHE8vj9iCRY3Hcx2ljBwmChocg9fcg3eMx9VXKshkcM6hjDTu/QIcnsfYTWCb\nML+KsNBp7qqLfdSrEwiL2pFp5Pk8go8MKitYL7mcB6IJLReE2AcTmbsMF1lBMomA\n26Ltabdlb7baE2YDQGVLZiiMSQKBgQD+sEcpPWG510v7hw6KxUki90gLqn8z7mWm\n7blYI/bDLrRIZFJKfdc9DOlGgvS3UwEqywpmIcajzyRY2ou+1g4NheFZkK6ogO0P\n2nG7nvAq4vqaEitcuDjd91vnwIAvV4W7W8mrJPitZmjgUGZBTzQHhw3G9C0SquMg\nb+5eoVYsIQKBgQCk3O9Ft7vT02p4aRgZmbJHbI2l9AERl4wvTvsAgxH9ZBEpGfe0\nbO4XhXIrksbRdsecYUImwkjoW6Rh9wEgvTFTsDDKIgn4dyPglEm1sWDUPLsYcFO1\niVxJB2yiRal9B8WrK8+/1G/NTRhzewzE4seHhhSPLOX0OhGCztX0IpjcyQKBgQCw\nFDUOeOZgck2Qtt3B6QVYTDeeASDySUYz8zRpkGugo2B2kA0ofPnatltsqUsAlz0+\nVaN52q4XQDVzzJxCsoCCruWOY22tB31dsXth6E9IhyYUcK1T6/U82C/M+JRmpo7J\nanrxfJ0EXMHzGwKm8lgZQDCxNM0Yk9Z07Y2SFN6boQKBgA0aeoxRLKYoO9AVcLC2\ni+NrPsa5Tdin/CDULyhVEUcqWW3/gGLUB+tUjUvYhuWt7ZP8d4qsmLNKwVXas4DG\n+aSZo+y/qF2sfpmtgvadU2VjxjQHugiFt4nA+Ir/fmUg8U+Bmxh3RIlpy5jiyPZr\nAfQyz0U9+3la0KrLFBy1zCVx\n-----END PRIVATE KEY-----\n",
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

      print(serverKeyAuthorization.toString() + "dsfgsdg");

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
