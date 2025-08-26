import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/config/navigation/app_router.dart';
import 'package:lol/core/network/remote/dio.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_options.dart';
import 'core/dependency_injection/service_locator.dart';
import 'core/my_bloc_observer.dart';
import 'core/network/local/shared_preference.dart';
import 'core/resources/constants/constants_manager.dart';
import 'core/resources/theme/values/app_strings.dart';
import 'core/resources/theme/theme_provider.dart';
import 'core/resources/theme/themes_manager.dart';
import 'core/error/error_screen.dart';
import 'features/on_boarding/presentation/view/onboarding.dart';
import 'features/auth/presentation/view/registration_layout.dart';
import 'features/home/presentation/view/loading_screen.dart';
import 'core/presentation/cubits/main_cubit/main_cubit.dart';
import 'features/admin/presentation/view_model/admin_cubit/admin_cubit.dart';

String? privateKeyId;
String? privateKey;

bool? noMoreStorage = false;
String? apiKey;
String? fcmToken;
Map<String, dynamic> fcisServiceMap = {};
main() async {
  setup();
  WidgetsFlutterBinding.ensureInitialized();
  await Cache.initialize();
  await DioHelp.initial();
  Bloc.observer = MyBlocObserver();
  await Firebase.initializeApp(
      options: kIsWeb ? DefaultFirebaseOptions.currentPlatform : null);
  try {
    fcmToken = await FirebaseMessaging.instance.getToken();
  } catch (error) {
    debugPrint(error.toString());
  }

  FirebaseFirestore.instance
      .collection("indicators")
      .doc("constants")
      .get()
      .then((onValue) {
    noMoreStorage = onValue.data()?["noMoreStorage"] ?? false;
    apiKey = onValue.data()?["apiKey"];
  }).catchError((error) {
    debugPrint('error occurred $error');
  });

  // await FirebaseFirestore.instance
  //     .collection("4notifications")
  //     .doc("private_keys")
  //     .get()
  //     .then((value) {
  //   fcisServiceMap = value.data()?["fcisServiceMap"];
  //   privateKey = value.data()?["private_key"];
  //   privateKeyId = value.data()?["private_key_id"];
  //   privateKey = privateKey!.replaceAll(r'\n', '\n').trim();
  // });

  AppConstants.TOKEN = Cache.sharedpref.getString(KeysManager.token);
  AppConstants.SelectedSemester =
      await Cache.sharedpref.getString(KeysManager.semester);

  ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
    return ErrorScreen(errorDetails: errorDetails);
  };
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: const Uninotes(),
  ));
}

class Uninotes extends StatelessWidget {
  const Uninotes({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => MainCubit()),
        BlocProvider(
            create: (BuildContext context) => AdminCubit()..getFcmTokens()),
      ],
      child: MaterialApp.router(
        routerConfig: AppRouter.router,
        theme: darkTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.dark,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
