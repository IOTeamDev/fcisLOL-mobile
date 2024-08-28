import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/app_contant/modules/home.dart';
import 'package:lol/app_contant/observer.dart';
import 'package:lol/login/login_screen.dart';
import 'package:lol/shared_prefrence/shared_prefrence.dart';

bool? isLogin;
late int Selected_Level;
main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Cache.initialize();
  bool Admin = await Cache.readData(key: "Admin")??false;
  Bloc.observer = MyBlocObserver();
  isLogin = await Cache.readData(key: "uId") ?? false;
  Selected_Level = await Cache.readData(key: "Level") ?? 0;

  runApp(const FCIS_LOL());
}

class FCIS_LOL extends StatelessWidget {
  const FCIS_LOL({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}
