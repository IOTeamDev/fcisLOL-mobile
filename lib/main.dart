import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/admin/bloc/admin_cubit.dart';
import 'package:lol/admin/bloc/admin_cubit_states.dart';
import 'package:lol/admin/screens/admin_panal.dart';
import 'package:lol/auth/bloc/login_cubit.dart';
import 'package:lol/material/cubit/material_cubit.dart';
import 'package:lol/material/screens/material_details.dart';
import 'package:lol/utilities/shared_prefrence.dart';
import 'auth/screens/login.dart';
import 'auth/screens/onboarding.dart';
import 'auth/screens/register.dart';
import 'auth/screens/select_image.dart';
import 'constants/constants.dart';
import 'main/screens/choosing_year.dart';
import 'main/screens/profile.dart';
import 'utilities/dio.dart';
import 'utilities/observer.dart';
import 'package:flutter/material.dart';
import 'main/screens/home.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Cache.initialize();
  await DioHelp.initial();
  await Firebase.initializeApp();
  // bool admin = await Cache.readData(key: "Admin") ?? false;
  Bloc.observer = MyBlocObserver();

  TOKEN = await Cache.readData(key: "token");
  print(TOKEN);

  SelectedSemester = await Cache.readData(key: "semester");
  print(SelectedSemester.toString() + "semester");
  bool isOnBoardFinished =
      await Cache.readData(key: "FinishedOnBoard") ?? false;

  final Widget startPage;
  if (!isOnBoardFinished) {
    startPage = const OnBoarding();
  } else {
    if (SelectedSemester == null && TOKEN == null) {
      startPage = ChoosingYear(loginCubit: LoginCubit(),);//
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
              ..getRequests()),
        BlocProvider(
            create: (BuildContext context) => MaterialCubit()..getMaterials())
      ],
      child: MaterialApp(
        home: LoginScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
