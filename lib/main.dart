import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/auth/screens/login.dart';
import 'package:lol/main/screens/home.dart';
import 'package:lol/utilities/observer.dart';
import 'package:lol/utilities/shared_prefrence.dart';

bool? isLogin;
late int selectedLevel;
main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Cache.initialize();
  // bool admin = await Cache.readData(key: "Admin") ?? false;
  Bloc.observer = MyBlocObserver();
  isLogin = await Cache.readData(key: "uId") ?? false;
  selectedLevel = await Cache.readData(key: "Level") ?? 0;

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
