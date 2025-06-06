import 'package:flutter/material.dart';
import 'package:lol/core/network/local/shared_preference.dart';
import 'package:lol/core/utils/resources/strings_manager.dart';
import 'package:lol/core/utils/resources/themes_manager.dart';

class ThemeProvider extends ChangeNotifier {
  bool isDark =  true;//Cache.sharedpref.getBool(KeysManager.isDarkMode) ?? true;
  ThemeData _appTheme = darkTheme;
      // Cache.sharedpref.getBool(KeysManager.isDarkMode) ?? true
      //     ? darkTheme
      //     : lightTheme;

  ThemeData get themeData {
    if (Cache.sharedpref.getBool(KeysManager.isDarkMode) == true) {
      isDark = true;
      return darkTheme;
    } else {
      isDark = false;
      return lightTheme;
    }
  }

  void toggleDarkMode() {
    if (_appTheme == darkTheme) {
      _appTheme = lightTheme;
      isDark = false;
    } else {
      _appTheme = darkTheme;
      isDark = true;
    }

    Cache.sharedpref.setBool(KeysManager.isDarkMode, _appTheme == darkTheme);
    notifyListeners();
  }
}
