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
      "private_key_id": "65ecfe52787875cc2e579826d10fba890d36e150",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDGvHRWT/NIICC0\nPE7W2nFdZdlwiieYdPZRes7SwKIjnLFnCDmQ7Cqc88gnas0ufTm0JGG7DOtSN7g5\ngpCwJTIQxmbXkjT4W6O+4LTCducyHrWk2OKam4aFTBzkFkZKJXuDqI3j4LiXVHUB\n9wZPhbW8Z6QE6VE3mgtsiZqNNZpW+r0J5PNrRkM47fWDR7N+8btLRFShZIGt82Co\nhHIp4y37n28XpsJGpCPaOdrNVxIn/lpntYh43ASBlNGIbN3pZW7NavO3MKig5yBJ\nXed0xnwUbJ6uBwUAYI8oARL3wlEY6LaJGS83c435lOtedi9hYsGC51TiAxlcR7km\ns1K7alJJAgMBAAECggEADVNkH/Mm890MTFbnOMK3dhoxoQ6by+jQfmipbG90anEO\njS3Q7FiFnUtpuPORSVl7Zcqduf+KWj44Y7TPSQcJdcn+lIcDdxbFTUkpyF4AL80S\n2XhIg4eZAXWifKHIufPhoGj221g9ZbpI8+YxiGIFwa8XtqjtZE4iOiIk7eyG9Od8\njhqCS655JYZcXeghDbbwBBDhyVCt5bdmtmF8MRmp6nlr2o4lhWR7rw5LAaZ5N09K\n0QDjpw/95afymtc4DCX5TCR28Ck3kTHBopujPRcysvviXFM3kS3o8fFnoUyb7kN8\nXMCbr3v39kw868xtQ888Bo3Aswldx5hZped7DprfjQKBgQD+roL2/IDtKix8SAp3\nQq9PcL9tQb5uo6aWZKfFE+xnITzY8iGBYjnFOFKJEh8Tj7t+Vvpa6Dxqynfu/kS1\n3HASJHo83o1xPy6xfQZunHrYyVXNiBfU2vB+obrxjcO1OAmyqj/YXnXKdVg5M+s6\nl342TKnjvBaOyP44SI5C/AICBQKBgQDHw86rA5k94bHLZS7+e9OidB3KP7PKeqSx\nRENd9vTAXnIfJp9ct4AFk5kqYgQLBBAcjUKfik3SStvCXGDMGMh6o+o/fgk2tQ0N\n6YlD73Xt4RLJdzTOG50AaSoerID7R5N281eXv7RDPwSClqojhS9bzxPAB2seEkgs\ncfnMlqCudQKBgQCWgfcvkyV2AvhrMf/NXwFPhyf5n2K0682lDzL+irmocMIOy3j1\nh2DwpkpQav8mhkidbzVgx+H8kk6yVF2yw+UPM7NxiWw5QseLaIGGmL8YolMstYKv\n7fs2OsnJuqevzsAcb/RvH9OopBRRKdeXtrOFz2SPCzahhzKFfItmFpvxKQKBgQCG\n7NklJuwVIOC+mVwRZL+ABV+toDMmeonMdWfvCoMrf18jbSnMLODaY2PbfZJvglID\nhuHN8lM3y3n9H/n9QGwAccAhHFbKzaTAldExwoZrok7XJp3S7FGx2lYpm6gOkLyo\nZhnuk/wEQ4cfUPYfwbBIGWiklh4ilISNCHqJVd+3lQKBgD801IyXNo/irQ72/v/t\nV/GcchnnUluCp1nkj7PKqxIGfpAiy2UEg7SIZlywJPpjSHWAkm6cmTfGs/By8Cab\nydiOAC8FS+VrOls0RujuPawzO5LVo9yjYY68cO1i3Msb47i0lECAVQ25dXVZkT2y\nktzxs012eMTlOJ5faB0xR7ES\n-----END PRIVATE KEY-----\n",
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
