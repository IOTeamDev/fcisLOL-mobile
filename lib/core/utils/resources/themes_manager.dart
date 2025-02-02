import 'package:flutter/material.dart';
import 'package:lol/core/utils/resources/colors_manager.dart';
import 'package:lol/core/utils/resources/styles_manager.dart';
import 'fonts_manager.dart';

ThemeData lightTheme(){
  return ThemeData(
    textTheme: TextTheme(
      displayLarge: getSemiBoldStyle(color: ColorsManager.black, fontSize: FontSize.size16),
      headlineLarge: getSemiBoldStyle(color: ColorsManager.black, fontSize: FontSize.size16),
      headlineMedium: getRegularStyle(color: ColorsManager.black),
      titleMedium: getMediumStyle(color: ColorsManager.black, fontSize: FontSize.size16),
      bodyLarge: getRegularStyle(color: ColorsManager.black),
      bodySmall: getRegularStyle(color: ColorsManager.black),
    ),
  );
}

ThemeData darkTheme(){
  return ThemeData(
    textTheme: TextTheme(
      displayLarge: getSemiBoldStyle(color: ColorsManager.white, fontSize: FontSize.size16),
      headlineLarge: getSemiBoldStyle(color: ColorsManager.white, fontSize: FontSize.size16),
      headlineMedium: getRegularStyle(color: ColorsManager.white),
      titleMedium: getMediumStyle(color: ColorsManager.white, fontSize: FontSize.size16),
      bodyLarge: getRegularStyle(color: ColorsManager.white),
      bodySmall: getRegularStyle(color: ColorsManager.white),
    ),
  );
}
