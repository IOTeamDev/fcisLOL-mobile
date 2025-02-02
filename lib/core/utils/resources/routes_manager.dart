import 'package:flutter/material.dart';
import 'package:lol/core/error/error_screen.dart';
import 'package:lol/features/admin/presentation/view/admin_panal.dart';
import 'package:lol/features/auth/presentation/view/login.dart';
import 'package:lol/features/auth/presentation/view/onboarding.dart';
import 'package:lol/features/auth/presentation/view/register.dart';
import 'package:lol/features/home/presentation/view/home.dart';

class Routes{
  static const String splashRoute = '/';
  static const String onBoardingRoute = '/onBoarding';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String mainRoute = '/register';
  static const String errorRoute = '/error';
  static const String adminPanelRoute = '/adminPanel';
  static const String adminRequestsRoute = '/adminPanel';
}

class RouteGenerator{
  static Route<dynamic> getRoute(RouteSettings settings)
  {
    switch(settings.name){
      case Routes.onBoardingRoute:
        return MaterialPageRoute(builder: (_) => const OnBoarding());
      case Routes.loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case Routes.registerRoute:
        return MaterialPageRoute(builder: (_) => const Registerscreen());
      case Routes.mainRoute:
        return MaterialPageRoute(builder: (_) => const Home());
      case Routes.adminPanelRoute:
        return MaterialPageRoute(builder: (_) => const AdminPanel());
      default:
        return MaterialPageRoute(builder: (_) => const ErrorScreen());
    }
  }
}