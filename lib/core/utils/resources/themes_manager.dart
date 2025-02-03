import 'package:flutter/material.dart';
import 'package:lol/core/utils/resources/colors_manager.dart';
import 'package:lol/core/utils/resources/styles_manager.dart';
import 'fonts_manager.dart';

ThemeData lightTheme = ThemeData(
  primaryColor: ColorsManager.lightPrimary,
  scaffoldBackgroundColor: ColorsManager.white,
  appBarTheme: AppBarTheme(
      color: ColorsManager.white,
      iconTheme: IconThemeData(color: ColorsManager.lightPrimary)),
  drawerTheme: DrawerThemeData(backgroundColor: ColorsManager.white),
  iconTheme: IconThemeData(color: ColorsManager.lightPrimary),
  textTheme: TextTheme(
    displayLarge:
        getSemiBoldStyle(color: ColorsManager.black, fontSize: FontSize.size30),
    displayMedium:
        getSemiBoldStyle(color: ColorsManager.black, fontSize: FontSize.size28),
    headlineLarge:
        getSemiBoldStyle(color: ColorsManager.black, fontSize: FontSize.size24),
    headlineMedium:
        getSemiBoldStyle(color: ColorsManager.black, fontSize: FontSize.size20),
    titleLarge:
        getMediumStyle(color: ColorsManager.black, fontSize: FontSize.size18),
    titleMedium:
        getMediumStyle(color: ColorsManager.black, fontSize: FontSize.size16),
    bodyLarge: getRegularStyle(
      color: ColorsManager.black,
    ),
    bodySmall:
        getRegularStyle(color: ColorsManager.black, fontSize: FontSize.size10),
  ),
);

ThemeData darkTheme = ThemeData(
  scaffoldBackgroundColor: ColorsManager.darkGrey,
  primaryColor: ColorsManager.darkPrimary,
  appBarTheme: AppBarTheme(
      color: ColorsManager.darkGrey,
      iconTheme: IconThemeData(color: ColorsManager.white)),
  drawerTheme: DrawerThemeData(backgroundColor: ColorsManager.darkGrey),
  iconTheme: IconThemeData(color: ColorsManager.white),
  textTheme: TextTheme(
    displayLarge:
        getBoldStyle(color: ColorsManager.white, fontSize: FontSize.size30),
    displayMedium:
        getBoldStyle(color: ColorsManager.white, fontSize: FontSize.size28),
    headlineLarge:
        getSemiBoldStyle(color: ColorsManager.white, fontSize: FontSize.size24),
    headlineMedium:
        getRegularStyle(color: ColorsManager.white, fontSize: FontSize.size20),
    titleLarge:
        getMediumStyle(color: ColorsManager.white, fontSize: FontSize.size18),
    titleMedium:
        getMediumStyle(color: ColorsManager.white, fontSize: FontSize.size16),
    bodyLarge: getRegularStyle(color: ColorsManager.white),
    bodySmall:
        getRegularStyle(color: ColorsManager.white, fontSize: FontSize.size10),
  ),
);
