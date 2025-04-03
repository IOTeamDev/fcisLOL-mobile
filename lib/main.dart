import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit_states.dart';
import 'package:lol/core/network/remote/send_grid_helper.dart';
import 'package:lol/core/utils/resources/theme_provider.dart';
import 'package:lol/core/utils/resources/themes_manager.dart';
import 'package:lol/features/admin/presentation/view/announcements/add_announcement.dart';
import 'package:lol/features/auth/presentation/view_model/auth_cubit/auth_cubit.dart';
import 'package:lol/features/home/presentation/view/semester_navigate.dart';
import 'package:lol/features/on_boarding/presentation/view/onboarding.dart';
import 'package:lol/features/otp_and_verification/presentation/view/otp_verification_screen.dart';
import 'package:lol/features/profile/view/edit_profile_screen.dart';
import 'package:lol/features/profile/view/other_profile.dart';
import 'package:lol/features/auth/data/models/login_model.dart';
import 'package:lol/features/admin/presentation/view_model/admin_cubit/admin_cubit.dart';
import 'package:lol/features/admin/presentation/view_model/admin_cubit/admin_cubit_states.dart';
import 'package:lol/features/admin/presentation/view/admin_panal.dart';
import 'package:lol/features/admin/presentation/view/announcements/announcements_list.dart';
import 'package:lol/core/error/error_screen.dart';
import 'package:lol/features/subject/data/repos/subject_repo_imp.dart';
import 'package:lol/features/subject/presentation/cubit/get_material_cubit/get_material_cubit.dart';
import 'package:lol/features/subject/presentation/screens/subject_details.dart';
import 'package:lol/features/support_and_about_us/about_us.dart';
import 'package:lol/features/support_and_about_us/user_advices/presentation/view/feedback_screen.dart';
import 'package:lol/core/utils/dependencies_helper.dart';
import 'package:lol/core/network/local/shared_preference.dart';
import 'package:provider/provider.dart';
import 'core/utils/resources/strings_manager.dart';
import 'features/auth/presentation/view/registration_layout.dart';
import 'features/auth/presentation/view_model/login_cubit/login_cubit.dart';
import 'core/utils/resources/constants_manager.dart';
import 'features/auth/presentation/view/choosing_year.dart';
import 'core/network/remote/dio.dart';
import 'core/observer.dart';
import 'package:flutter/material.dart';
import 'features/home/presentation/view/home.dart';

String? privateKeyId;
String? privateKey;

bool? noMoreStorage = false;
String? apiKey;
String? fcmToken;
Map<String, dynamic> fcisServiceMap = {};
main() async {
  setup();
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  await Cache.initialize();
  await DioHelp.initial();
  await SendGridHelper.initial();
  await Firebase.initializeApp();
  try {
    fcmToken = await FirebaseMessaging.instance.getToken();
  } catch (error) {
    log(error.toString());
  }

  FirebaseFirestore.instance
      .collection("indicators")
      .doc("constants")
      .get()
      .then((onValue) {
    noMoreStorage = onValue.data()?["noMoreStorage"] ?? false;
    apiKey = onValue.data()?["apiKey"];
  }).catchError((error) {
    log('error occurred $error');
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
  });

  Bloc.observer = MyBlocObserver();

  AppConstants.TOKEN = Cache.sharedpref.getString(KeysManager.token);
  AppConstants.SelectedSemester =
      await Cache.sharedpref.getString(KeysManager.semester);
  bool isOnBoardFinished =
      await Cache.readData(key: KeysManager.finishedOnBoard) ?? false;

  final Widget startPage;

  if (!isOnBoardFinished) {
    startPage = const OnBoarding();
  } else {
    if (AppConstants.TOKEN == null && AppConstants.SelectedSemester == null) {
      startPage = RegistrationLayout();
    } else {
      startPage = const Home();
    }
  }

  ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
    return ErrorScreen(errorDetails: errorDetails);
  };
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: App(startPage: startPage),
  ));
}

class App extends StatelessWidget {
  final Widget startPage;

  const App({super.key, required this.startPage});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => MainCubit()),
        BlocProvider(
            create: (BuildContext context) => AdminCubit()..getFcmTokens()),
      ],
      child: MaterialApp(
        home: ChoosingYear(authCubit: AuthCubit()),
        theme: darkTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.dark,
        // theme: Provider.of<ThemeProvider>(context).themeData,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
