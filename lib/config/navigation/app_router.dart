import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lol/config/navigation/routes.dart';
import 'package:lol/core/dependency_injection/service_locator.dart';
import 'package:lol/core/network/local/shared_preference.dart';
import 'package:lol/core/resources/constants/constants_manager.dart';
import 'package:lol/core/resources/theme/values/app_strings.dart';
import 'package:lol/features/auth/domain/repos/auth_repo.dart';
import 'package:lol/features/auth/presentation/view/choosing_year/choosing_year.dart';
import 'package:lol/features/auth/presentation/view/login/login.dart';
import 'package:lol/features/auth/presentation/view/register/register.dart';
import 'package:lol/features/auth/presentation/view/registration_layout.dart';
import 'package:lol/features/auth/presentation/cubits/auth_cubit/auth_cubit.dart';
import 'package:lol/features/home/presentation/view/home.dart';
import 'package:lol/features/home/presentation/view/loading_screen.dart';
import 'package:lol/features/on_boarding/presentation/view/onboarding.dart';
import 'package:lol/features/otp_and_verification/data/repos/ticker_repo/ticker_repo.dart';
import 'package:lol/features/otp_and_verification/data/repos/verification_repo/verification_repo.dart';
import 'package:lol/features/otp_and_verification/presentation/cubits/email_verification_cubit.dart/cubit/email_verification_cubit.dart';
import 'package:lol/features/otp_and_verification/presentation/cubits/ticker_cubit.dart/cubit/ticker_cubit.dart';
import 'package:lol/features/otp_and_verification/presentation/cubits/verification_cubit/verification_cubit.dart';
import 'package:lol/features/otp_and_verification/presentation/view/email_verification_screen.dart';
import 'package:lol/features/pick_image/presentation/view/select_image.dart';
import 'package:lol/features/pick_image/presentation/view_model/pick_image_cubit/pick_image_cubit.dart';

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
          create: (context) => AuthCubit(getIt<AuthRepo>()),
          child: RegistrationLayout(),
        ),
      ),
      GoRoute(
        name: ScreensName.choosingYear,
        path: Routes.choosingYear,
        builder: (context, state) => ChoosingYear(),
      ),
      GoRoute(
        name: ScreensName.selectImage,
        path: Routes.selectImage,
        builder: (context, state) => BlocProvider(
          create: (context) => PickImageCubit(),
          child: SelectImage(),
        ),
      ),

      //Home
      GoRoute(
        name: ScreensName.home,
        path: Routes.home,
        builder: (context, state) => HomeScreen(),
      ),

      // Verification
      GoRoute(
        name: ScreensName.emailVerification,
        path: Routes.emailVerification,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
                  EmailVerificationCubit(getIt<VerificationRepo>()),
            ),
            BlocProvider(
              create: (context) => TickerCubit(getIt<TickerRepo>()),
            ),
          ],
          child: EmailVerificationScreen(
            recipientEmail: getIt<FirebaseAuth>().currentUser!.email!,
          ),
        ),
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
