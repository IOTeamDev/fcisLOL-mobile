import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/app_contant/modules/home.dart';
import 'package:lol/app_contant/observer.dart';
import 'package:lol/login/login_screen.dart';
import 'package:lol/shared_prefrence/shared_prefrence.dart';

bool? isLogin;
late dynamic selectedLevel;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Cache.initialize();

  Bloc.observer = MyBlocObserver();
  isLogin = await Cache.readData(key: "Token") ?? false;
  selectedLevel = Cache.readData(key: "Level");
  runApp(const FCISLOL());
}

class FCISLOL extends StatelessWidget {
  const FCISLOL({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
