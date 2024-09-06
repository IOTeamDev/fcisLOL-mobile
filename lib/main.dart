import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/auth/screens/login.dart';
import 'package:lol/auth/screens/onboarding.dart';
import 'package:lol/auth/screens/register.dart';
import 'package:lol/auth/screens/select_image.dart';
import 'package:lol/constants/constants.dart';
import 'package:lol/main/screens/choosing_year.dart';
import 'package:lol/main/screens/home.dart';
import 'package:lol/main/screens/profile.dart';
import 'package:lol/utilities/dio.dart';
import 'package:lol/utilities/observer.dart';
import 'package:lol/utilities/shared_prefrence.dart';

late int selectedLevel;
main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Cache.initialize();
  await DioHelp.initial();
  // bool admin = await Cache.readData(key: "Admin") ?? false;
  Bloc.observer = MyBlocObserver();

  token = await Cache.readData(key: "token");
  selectedLevel = await Cache.readData(key: "Level") ?? 0;
  bool isOnBoardFinished = await Cache.readData(key: "FinishedOnBoard") ?? false;

  final Widget startPage;
  if (!isOnBoardFinished) {
    startPage = const OnBoarding();
  } else {
    if (selectedLevel == 0 && token == null) {
      startPage = const ChoosingYear();
    } else {
      startPage = const Home();
    }
  }

  runApp(
     App(startPage: startPage,),
  );
}

class App extends StatelessWidget {
  final Widget startPage;
   const App({super.key, required this.startPage});
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: Registerscreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
