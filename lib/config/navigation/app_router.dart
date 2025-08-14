import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lol/config/navigation/routes.dart';
import 'package:lol/core/network/local/shared_preference.dart';
import 'package:lol/core/resources/constants/constants_manager.dart';
import 'package:lol/core/resources/theme/values/app_strings.dart';
import 'package:lol/features/auth/presentation/view/choosing_year/choosing_year.dart';
import 'package:lol/features/auth/presentation/view/login/login.dart';
import 'package:lol/features/auth/presentation/view/register/register.dart';
import 'package:lol/features/auth/presentation/view/registration_layout.dart';
import 'package:lol/features/auth/presentation/cubits/auth_cubit/auth_cubit.dart';
import 'package:lol/features/home/presentation/view/home.dart';
import 'package:lol/features/home/presentation/view/loading_screen.dart';
import 'package:lol/features/on_boarding/presentation/view/onboarding.dart';

abstract class AppRouter {
  static final router = GoRouter(
    initialLocation: _getInitialLocation(),
    routes: [
      //Shared
      GoRoute(
        name: ScreensName.loading,
        path: Routes.loading,
        builder: (context, state) => const LoadingScreen(),
      ),
      GoRoute(
        name: ScreensName.onBoarding,
        path: Routes.onBoarding,
        builder: (context, state) => const OnBoarding(),
      ),

      //Auth
      GoRoute(
        name: ScreensName.login,
        path: Routes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        name: ScreensName.register,
        path: Routes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        name: ScreensName.registrationLayout,
        path: Routes.registrationLayout,
        builder: (context, state) => BlocProvider(
          create: (context) => AuthCubit(),
          child: RegistrationLayout(),
        ),
      ),
      GoRoute(
        name: ScreensName.choosingYear,
        path: Routes.choosingYear,
        builder: (context, state) => ChoosingYear(),
      ),

      //Home
      GoRoute(
        name: ScreensName.home,
        path: Routes.home,
        builder: (context, state) => HomeScreen(),
      )
    ],
  );

  static String _getInitialLocation() {
    bool isOnBoardFinished =
        Cache.readData(key: KeysManager.finishedOnBoard) ?? false;

    final String startPage;

    if (!isOnBoardFinished) {
      startPage = Routes.onBoarding;
    } else {
      if (AppConstants.TOKEN == null && AppConstants.SelectedSemester == null) {
        startPage = Routes.registrationLayout;
      } else {
        startPage = Routes.loading;
      }
    }

    return startPage;
  }
}
