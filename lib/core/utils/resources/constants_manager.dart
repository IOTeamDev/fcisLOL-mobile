import 'package:flutter/material.dart';

class AppConstants{
  static String? TOKEN;
  static String? SelectedSemester;
  static const String defaultImage = 'https://firebasestorage.googleapis.com/v0/b/fcis-da7f4.appspot.com/o/140.jpg?alt=media&token=3e5a4144-20ca-44ce-ba14-57432e49914f';
}

class AppQueries{
  static screenHeight(context) => MediaQuery.of(context).size.height;
  static screenWidth(context) => MediaQuery.of(context).size.width;
}
/* if the user doesn't have an account */

