import 'package:flutter/material.dart';

class AppConstants{
  static String? TOKEN;
  static String? SelectedSemester;
}

class AppQueries{
  static screenHeight(context) => MediaQuery.of(context).size.height;
  static screenWidth(context) => MediaQuery.of(context).size.width;
}
/* if the user doesn't have an account */

