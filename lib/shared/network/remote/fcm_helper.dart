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
      "private_key_id": "3181027d3c5a10ae9d306910c5ce67ac38333191",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCiBDKXuqBrXDOc\n6tFjkCHEy7qMcW3j8/ElL6JnfaU+8KC/OQ8nmL8He3f2dVyrfbtT3vHeCYeaVDKi\n08uVAanj7SaHKvEQDX0jhei8g7J7olmelk0WIS9+jmjsdC3KcwdgEtCVU4B8D2Yo\ncIds1QIOEouWAisoJkA40iS8gLhvHfqVWOjkiGJJmVLpOhCgni3E+ZVgeUBk/anU\n2j7vKOmqcucZvKOpb1VfmwApatHxqjYuCdWt/XrObKfrdSAOeWC6/wQrJi+Pxc+H\nPdMePmteo9z6nxieYTnCuGNgbqJgfaNCu8xuoVDfV8Id6wE8osVuVr2IX77aBuhy\natYSZt/5AgMBAAECggEABBiPfgkHtuUE/uqUM/Z9EzjORASVDFE4K0WNpsvvOmKl\n6lgbk6h73mQizss6djgRNL7fbNFl6UgRwVVVNAw5qq4dAmY4/pOH4b2am9VA8AAR\n5MsDwFAarPcjdCRbxa+KXT7Lrr4heW08w00skdQ3gRVB49UuabXbUw2vh6b+e+7y\nFzxsXTTvs9TDoUmcu8miIjpyGIkIW+MjwWL5XZa3QRWuuAKSdZxVS+VFVFGsIUML\nCvYEbAW0dtlBljjhhulVApH/jq+/ajEOECcsn/U18Lcxynedzt8m4Nqt91aYepnr\nVe+QSc5E6uApxWAWjtVa6tt403ruFazctPjhDPKZoQKBgQDYNL2n02DXYf6sOYAT\npoMDRYVTwXfybjtCjjbu+jrVD1JtO5IB5x4CoWsyGapn0qMJO+40sWGsRjodjWuA\nrwH1fSXeeJlblTUn5C6KQuiVcZgvGmahwzhFjOu42GREsQo9DL2teWL7gdBs+DXx\nJjiIdMUOIFyeDk2E2Di5CiifMwKBgQC/1iJXlczgAtLQTHwqErCZJiOAuKy435Qz\n9ksf/Nq50SRo603FgyN20HYjPGesF1lUBzfDitH9QU/hCf4lbDs4esPOFvnEU1xP\nO5cZ9FvirBsZzyc/I/koxoGTxmBFCfcRh2L5RgHVF0M3JVrfEirMEV5fF6v4TUDL\nmwYuFnJ0IwKBgQC2oCYrYtOEW1RBqfhToO09kDXEv8FP2GjaGUKxrlCPs/eOKSl1\nzgF9e1gO47sbI8Nvg138yHCWkmN4nwJVmn5vHJ0mRHxV7b0OyyG8zDOmOGOyNfzH\nWx1nMlfStYZMt7bMRrzZkZVYmRizUx5NalmKeggRnKhfIfm84t9W/gu+HQKBgAoh\nf9zKP3CRFZsEfwYlyIe9+OACYLS+se/wkNUWoGJxxg94ZboJi+Tpa2O+++adsQz7\n+JjuCtrqCRLkWTSWu6Xm7dJDaltQ364bgoZPXk7hMekyBGuUNcNOgGdScaETvqWB\nVdu+M7iSKu2NnnfrWLFANZCmCmHpioN2I2RpsQ+rAoGBALSoi8SM/9Yn6qu+u7eD\nLT6mrzR17f9PuLr/i+zZpLb3ClE5b5aNUUo62ciJFQm8gY3lZzL++MXxpBowA8T3\nNq0+syMdLKpElk5kYlyMTACQTOGf6K9AahFT0g8UFoz/OrYYMUbMY+PMBLj+yTCX\nJBJV1uLYmooXZE4Mw/IrMGPw\n-----END PRIVATE KEY-----\n",
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
