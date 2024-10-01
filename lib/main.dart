import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/layout/home/bloc/main_cubit.dart';
import 'package:lol/layout/home/bloc/main_cubit_states.dart';
import 'package:lol/layout/home/semester_navigate.dart';
import 'package:lol/modules/admin/bloc/admin_cubit.dart';
import 'package:lol/modules/admin/bloc/admin_cubit_states.dart';
import 'package:lol/layout/admin_panel/admin_panal.dart';
import 'package:lol/modules/admin/screens/Announcements/add_announcement.dart';
import 'package:lol/modules/admin/screens/announcements/announcements_list.dart';
import 'package:lol/modules/subject/subject_details.dart';
import 'package:lol/modules/support_and_about_us/user_advices/feedback_screen.dart';
import 'package:lol/shared/network/local/shared_prefrence.dart';
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
import 'modules/subject/cubit/subject_cubit.dart';
import 'shared/network/remote/dio.dart';
import 'shared/observer.dart';
import 'package:flutter/material.dart';
import 'layout/home/home.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Cache.initialize();
  await DioHelp.initial();
  await Firebase.initializeApp();
  Bloc.observer = MyBlocObserver();
  bool isDark = await Cache.readData(key: "mode") ?? false;

  TOKEN = await Cache.readData(key: "token");
  print(TOKEN);
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
  bool isDark = false;

  void changeMode() async {
    isDark = !isDark;
    await Cache.writeData(key: "mode", value: isDark);
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
          BlocProvider(
              create: (BuildContext context) => SubjectCubit()),
          BlocProvider(
            create: (BuildContext context) => MainCubit(),
          ),
        ],
        child: Consumer<ThemeProvide>(builder: (context, value, child) {
          return MaterialApp(
            home: LoginScreen(),
            debugShowCheckedModeBanner: false,
            theme: value.isDark ? ThemeData.dark() : ThemeData.light(),
          );
        }));
  }
}
