import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:lol/shared/components/components.dart';

class FCMHelper {
  // creat instance of fbm
  final _firebaseMessaging = FirebaseMessaging.instance;

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

  Future<String?> getAccessToken() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "fcis-da7f4",
      "private_key_id": "2dada9c2e127654c9161f89de3746e6a5d568c82",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQC7MvhxTp5Gt3FW\nLMLa62hg/S6xKxjDFx1NYzolS6sZqflLV7pS4iJ6h/n+KZGpymB8wCed8K73aUwc\nHGNI4I2JuKQdPbifDvhyRf8TB6WuPJvciTZme5LginKL/B86lH0l5rC+Sc6HSm/r\nCc41RUpsnDkRlcGuifs2WNKpTM92atS7suORvmj+fJiBibRpLPL/STxl8mOz5Um8\nv8oiiruq1sM2XWzfBxxNZyJq7Mp3xvlZvM+DPIHkFpw/enfOGEOS4K9hrDaofCjX\nLteRMZ2wHNxLO8oQKVaMvC1K+PbGqRcNQYnU7cCZQSLo+ORqpPZokvJzpd7093bH\ngpfCI26bAgMBAAECggEAGL6xFpE03NYs1h5Ol4+cmY1+GY8/07H/fpZKPlnVQSw1\ntt7e00vvENFem1k1VwNYY8Umt3r0NeImXGToPt7n9reAghkBiYz6DGjyQbq2DOUY\nGTvOBBf7n1DNuXFXU3ADZvoqjMzGzx1o0+HU7ze8kcTIymlIU+ELYvC00ApGNjnJ\nB8OSKJHBLRCSTyJNrmutscMGoBh8C/tND+Y4GdMKeSJcNT9mJ1GXPYlkYjq4QdCR\nZu8XlFrswuUX2Kp5FBBp6NrswMULfqdytuW6QheGgy8slzxlnnBai09tBTVhHnhy\nPx6gUdbxz8FjwF9KRKaiRncobOQ11ZTD4DfY03IF6QKBgQDfm4FvuPodZuVqBcPq\njfSrfPedczzz8lCAkW6dnWfgHF6yNFrl6QUbmLR8T88VJcbdrRtGrfc4dvnz1azq\nEWH+7pcw6MwPIOuT5HBnMlrY+dlJQvfB9oL9vf/FadqvP4tXNa+hrCobcKLdUzl1\n66qFV0nj1zzRJYbZwPWzRGy2TwKBgQDWUUJyVeNcYedmwdlyAmxf0QV05LpWefB7\nLaSvV0TVG/bFVuRQcqG9Hni7N2w9iNKX3LmxKCz+E5s7d0xdSYmO7MfOcjP7kQ1k\n6u3sOVDLyIGUM8PflzZwGoj6Mm5DoapzK467YDGsd3RLYkxe7KUSNLvWFBo/58Wt\nVpUizi979QKBgQDQULAqZDrnL1glCM/3cV5ycM7CaXxsi9+Bl3tk7SK7v9Jc1Lem\nHws6JW5nrXZv7iyxkjaqByIdAYJlLjiUK7OO67oAv7Bzm6i8tAIfseK+5y0NuozU\nr5JjUCG7SZ2IzHtEuOgxhxIHVEz2QjVy7SWEaciVsYygEATsUn7UDrf0swKBgQCn\nOUBfdiSxMLMduqOwEbP+D1nym4XJc9vwQOz+41kR73/c+q+rFcadiekqK1SJrvij\nBdbeJDr3BNVa0PsEzxxGKPq+Wt20rLmGxMhgSViBqTFyMfHjxFj1n77BehgPLVWS\nB6qXCbe4mnxjVY/BgWRLkFn/8C+LLY1Qcv5q6fajAQKBgQC9oap3m0jhLhWBqx4L\nJvaIpzrhXUDpsbO8aaPPar0ZW18RtXP8mnWvcFKKaWupL11mn33bEGGdYMY7kAlR\n6Tm/J9PckKverXbYW1orXdg4qNbEgXuT2xWBXDxvUqEd42nFeDSCSzvfIhfHxn2A\nWq4gDLz/jEepVCFwHsdDGNLCcA==\n-----END PRIVATE KEY-----\n",
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
    String? type,
  }) async {
    try {
      var serverKeyAuthorization = await getAccessToken();

      print(serverKeyAuthorization.toString()+"dsfgsdg");

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
