import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/layout/home/bloc/main_cubit.dart';
import 'package:lol/modules/admin/bloc/admin_cubit.dart';
import 'package:lol/modules/admin/bloc/admin_cubit_states.dart';
import 'package:lol/layout/admin_panel/admin_panal.dart';
import 'package:lol/modules/subject/subject_details.dart';
import 'package:lol/shared/network/local/shared_prefrence.dart';
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

late int selectedLevel;
main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Cache.initialize();
  await DioHelp.initial();
  await Firebase.initializeApp();
  Bloc.observer = MyBlocObserver();

  TOKEN = await Cache.readData(key: "token");
  print(TOKEN);
  selectedLevel = await Cache.readData(key: "Level") ?? 0;
  bool isOnBoardFinished =
      await Cache.readData(key: "FinishedOnBoard") ?? false;

  final Widget startPage;
  if (!isOnBoardFinished) {
    startPage = const OnBoarding();
  } else {
    if (selectedLevel == 0 && TOKEN == null) {
      startPage = ChoosingYear(
        loginCubit: LoginCubit(),
      );
    } else {
      startPage = const Home();
    }
  }

  runApp(
    App(
      startPage: startPage,
    ),
  );
}

class App extends StatelessWidget {
  final Widget startPage;
  const App({super.key, required this.startPage});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (BuildContext context) => AdminCubit()
              ..getAnnouncements()
              ..getRequests()
        ),
        BlocProvider(create: (BuildContext context) => SubjectCubit()..getMaterials()),
        if(TOKEN != null)
        BlocProvider(create: (BuildContext context) => MainCubit()..getProfileInfo()),
      ],
      child: BlocConsumer<AdminCubit, AdminCubitStates>(
        builder: (context, state) => MaterialApp(
          home: Home(),
          debugShowCheckedModeBanner: false,
        ),
        listener: (context, state) {},
      ),
    );
  }
}
