import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/ch_ye.dart';
import 'package:lol/drawer.dart';
import 'package:lol/layout/home/bloc/main_cubit.dart';
import 'package:lol/layout/home/bloc/main_cubit_states.dart';
import 'package:lol/layout/home/semester_navigate.dart';
import 'package:lol/layout/profile/other_profile.dart';
import 'package:lol/models/login/login_model.dart';
import 'package:lol/modules/admin/bloc/admin_cubit.dart';
import 'package:lol/modules/admin/bloc/admin_cubit_states.dart';
import 'package:lol/layout/admin_panel/admin_panal.dart';
import 'package:lol/modules/admin/screens/Announcements/add_announcement.dart';
import 'package:lol/modules/admin/screens/announcements/announcements_list.dart';
import 'package:lol/modules/error/error_screen.dart';
import 'package:lol/modules/subject/data/repos/subject_repo_imp.dart';
import 'package:lol/modules/subject/presentation/cubit/get_material_cubit/get_material_cubit_cubit.dart';
import 'package:lol/modules/subject/presentation/screens/subject_details.dart';
import 'package:lol/modules/support_and_about_us/about_us.dart';
import 'package:lol/modules/support_and_about_us/user_advices/feedback_screen.dart';
import 'package:lol/shared/dependencies/dependencies_helper.dart';
import 'package:lol/shared/network/local/shared_prefrence.dart';
import 'package:lol/shared/network/remote/fcm_helper.dart';
import 'package:provider/provider.dart';
import 'modules/auth/bloc/login_cubit.dart';
import 'modules/auth/screens/login.dart';
import 'modules/auth/screens/onboarding.dart';
import 'modules/auth/screens/register.dart';
import 'modules/auth/screens/select_image.dart';
import 'modules/leaderboard/leaderboard_screen.dart';
import 'shared/components/constants.dart';
import 'modules/year_choose/choosing_year.dart';
import 'layout/profile/profile.dart';
import 'modules/subject/presentation/cubit/subject_cubit.dart';
import 'shared/network/remote/dio.dart';
import 'shared/observer.dart';
import 'package:flutter/material.dart';
import 'layout/home/home.dart';

String? private_key_id;
String? private_key;
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.

//   print("Handling a background message: ${message.messageId}");
// }

// void sendNotificationToSemesterThreeUsers(List<UserModel> users) {
//   // Filter users whose semester is three
//   List<UserModel> semesterThreeUsers = users.where((user) => user.semester == 3).toList();

//   for (var user in semesterThreeUsers) {
//     if (user.fcmToken.isNotEmpty) {
//       sendFCMNotification(user.fcmToken);
//     }
//   }
// }
bool? changeSemester = false;
bool? noMoreStorage = false;
String? apiKey;
String? fcmToken;
bool isDark = false;
Map<String, dynamic> fcisServiceMap = {};
main() async {
  setup();

  WidgetsFlutterBinding.ensureInitialized();
  await Cache.initialize();
  await DioHelp.initial();
  await Firebase.initializeApp();
  fcmToken = await FirebaseMessaging.instance.getToken();
  print(fcmToken);

  FirebaseFirestore.instance
      .collection("indicators")
      .doc("constants")
      .get()
      .then((onValue) {
    changeSemester = onValue.data()?["changeSemester"] ?? false;
    noMoreStorage = onValue.data()?["noMoreStorage"] ?? false;
    apiKey = onValue.data()?["apiKey"];
    print("$changeSemester seememmemememmem");
  });

  await FirebaseFirestore.instance
      .collection("4notifications")
      .doc("private_keys")
      .get()
      .then((value) {
    fcisServiceMap = value.data()?["fcisServiceMap"];
    private_key = value.data()?["private_key"];
    private_key_id = value.data()?["private_key_id"];
    private_key = private_key!.replaceAll(r'\n', '\n').trim();

    print(
        "${fcisServiceMap["project_id"]}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
  });
// fCMHelper.initNotifications();

// fCMHelper.sendNotifications(
//   fcmToken: "chUAaG_7Tu68jnmU8UpxSN:APA91bHgHAocyXqRhWLeSw7NFepQMKaefT1i0ust8oQVvYsS1kt4OGk0wXHAqD3U6Erciw1IyPS5FUPNwxgkeNEXF4Q5W76GbTS-NZSexTaZNdLQCq1SZZzDkh23RHktWgqd7vBZLRRn",  // Use the token from step 2
//   title: "Test Notification",
//   body: "This is a test notification.",
// );

  // await initNotifation();
  Bloc.observer = MyBlocObserver();
  isDark = await Cache.readData(key: "mode") ?? false;

  TOKEN = await Cache.readData(key: "token");
  print('token=>>>>>>>>>>>>>>>>>>>>>>>>$TOKEN');
  SelectedSemester = await Cache.readData(key: "semester");
  bool isOnBoardFinished =
      await Cache.readData(key: "FinishedOnBoard") ?? false;

  // TOKEN = null;//
  final Widget startPage;
  if (!isOnBoardFinished) {
    startPage = const OnBoarding();
  } else {
    if (SelectedSemester == null && TOKEN == null) {
      startPage = ChoosingYear(
        loginCubit: LoginCubit(),
      );
    } else {
      startPage = const Home();
    }
  }

  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvide()..loadMode(),
    child: App(startPage: startPage),
  ));
}

class ThemeProvide extends ChangeNotifier {
  bool temp = false;

  void changeMode({bool dontWannaDark = false}) async {
    if (dontWannaDark) {
      temp = false;
      isDark = temp;
      await Cache.writeData(key: "mode", value: false);
    } else {
      temp = !temp;
      await Cache.writeData(key: "mode", value: temp);
      isDark = temp;
    }
    print('Theme mode changed: $isDark'); // Debugging log

    // Notify listeners to rebuild widgets listening to this provider
    notifyListeners();
  }

  Future<void> loadMode() async {
    // Load the dark mode from shared preferences
    isDark = await Cache.readData(key: "mode") ?? false;

    // Notify listeners to rebuild widgets with the loaded theme
    notifyListeners();
  }
}

class App extends StatelessWidget {
  final Widget startPage;
  const App({super.key, required this.startPage});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (BuildContext context) => MainCubit()),
          BlocProvider(create: (BuildContext context) => AdminCubit()),
        ],
        child: Consumer<ThemeProvide>(builder: (context, value, child) {
          // AdminCubit.get(context).getFcmTokens();
          return MaterialApp(
            home: startPage,
            debugShowCheckedModeBanner: false,
            theme: isDark ? ThemeData.dark() : ThemeData.light(),
          );
        }));
  }
}
