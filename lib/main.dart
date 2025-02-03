import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit_states.dart';
import 'package:lol/core/utils/resources/themes_manager.dart';
import 'package:lol/features/admin/presentation/view/announcements/add_announcement.dart';
import 'package:lol/features/home/presentation/view/semester_navigate.dart';
import 'package:lol/features/profile/view/other_profile.dart';
import 'package:lol/features/auth/data/models/login_model.dart';
import 'package:lol/features/admin/presentation/view_model/admin_cubit/admin_cubit.dart';
import 'package:lol/features/admin/presentation/view_model/admin_cubit/admin_cubit_states.dart';
import 'package:lol/features/admin/presentation/view/admin_panal.dart';
import 'package:lol/features/admin/presentation/view/announcements/announcements_list.dart';
import 'package:lol/core/error/error_screen.dart';
import 'package:lol/features/subject/data/repos/subject_repo_imp.dart';
import 'package:lol/features/subject/presentation/cubit/get_material_cubit/get_material_cubit_cubit.dart';
import 'package:lol/features/subject/presentation/screens/subject_details.dart';
import 'package:lol/features/support_and_about_us/about_us.dart';
import 'package:lol/features/support_and_about_us/user_advices/feedback_screen.dart';
import 'package:lol/core/utils/dependencies_helper.dart';
import 'package:lol/core/network/local/shared_preference.dart';
import 'package:lol/core/network/remote/fcm_helper.dart';
import 'package:provider/provider.dart';
import 'core/utils/resources/strings_manager.dart';
import 'features/auth/presentation/view_model/login_cubit/login_cubit.dart';
import 'features/auth/presentation/view/login.dart';
import 'features/auth/presentation/view/onboarding.dart';
import 'features/auth/presentation/view/register.dart';
import 'features/auth/presentation/view/select_image.dart';
import 'features/leaderboard/presentation/view/leaderboard_view.dart';
import 'core/utils/resources/constants_manager.dart';
import 'features/auth/presentation/view/choosing_year.dart';
import 'features/profile/view/profile.dart';
import 'core/network/remote/dio.dart';
import 'core/observer.dart';
import 'package:flutter/material.dart';
import 'features/home/presentation/view/home.dart';

String? privateKeyId;
String? privateKey;
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
// bool isDark = false;
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
    print("$changeSemester");
  });

  await FirebaseFirestore.instance
      .collection("4notifications")
      .doc("private_keys")
      .get()
      .then((value) {
    fcisServiceMap = value.data()?["fcisServiceMap"];
    privateKey = value.data()?["private_key"];
    privateKeyId = value.data()?["private_key_id"];
    privateKey = privateKey!.replaceAll(r'\n', '\n').trim();

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

  AppConstants.TOKEN = await Cache.readData(key: KeysManager.token);
  AppConstants.SelectedSemester =
      await Cache.readData(key: KeysManager.semester);
  bool isOnBoardFinished =
      await Cache.readData(key: KeysManager.finishedOnBoard) ?? false;

  // TOKEN = null;//
  final Widget startPage;
  if (!isOnBoardFinished) {
    startPage = const OnBoarding();
  } else {
    if (AppConstants.SelectedSemester == null && AppConstants.TOKEN == null) {
      startPage = ChoosingYear(
        loginCubit: LoginCubit(),
      );
    } else {
      startPage = const Home();
    }
  }

  runApp(App(
    startPage: startPage,
  ));
}

class App extends StatelessWidget {
  final Widget startPage;

  const App({super.key, required this.startPage});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => MainCubit()
          ..getProfileInfo()
          ..themeData
        ),
        BlocProvider(
          create: (BuildContext context) => AdminCubit()
          ..getAnnouncements(
            MainCubit.get(context).profileModel != null ?
            MainCubit.get(context).profileModel!.semester :
            AppConstants.SelectedSemester!
          )
          ..getFcmTokens()
        ),
      ],
      child: BlocBuilder<MainCubit, MainCubitStates>(
        builder: (context, state) {
          return MaterialApp(
            home: startPage,
            debugShowCheckedModeBanner: false,
            theme: MainCubit.get(context).themeData,
          );
        }
      )
    );
  }
}
