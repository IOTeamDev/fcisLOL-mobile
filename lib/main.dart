  import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/admin/bloc/admin_cubit.dart';
import 'package:lol/admin/bloc/admin_cubit_states.dart';
  import 'package:lol/admin/screens/admin_panal.dart';
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

  late int selectedLevel;
  main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Cache.initialize();
    await DioHelp.initial();
    // bool admin = await Cache.readData(key: "Admin") ?? false;
    Bloc.observer = MyBlocObserver();

    token = await Cache.readData(key: "token");
    selectedLevel = await Cache.readData(key: "Level") ?? 0;
    bool isOnBoardFinished =await Cache.readData(key: "FinishedOnBoard") ?? false;

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


      return MultiBlocProvider(
        providers: [
          BlocProvider(create: (BuildContext context) => AdminCubit()..getAnnouncements())
        ],
        child: BlocConsumer<AdminCubit, AdminCubitStates>(
          builder:(context, state) => MaterialApp(
            home: AdminPanal(),
            debugShowCheckedModeBanner: false,
          ),
          listener: (context, state){},
        ),
      );
      
    }
  }