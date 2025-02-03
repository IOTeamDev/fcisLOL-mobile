// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class AppConstants {
  static String? TOKEN;
  static String? SelectedSemester;
  static const String defaultImage =
      'https://firebasestorage.googleapis.com/v0/b/fcis-da7f4.appspot.com/o/140.jpg?alt=media&token=3e5a4144-20ca-44ce-ba14-57432e49914f';
  static const String defaultProfileImage =
      'https://firebasestorage.googleapis.com/v0/b/fcis-da7f4.appspot.com/o/images%2Fdefault-avatar-icon-of-social-media-user-vector.jpg?alt=media&token=5fc138d2-3919-4854-888e-2d8fec45d555';
  static const String year28Drive =
      'https://drive.google.com/drive/folders/1TOj0c-vFblz4guLuRa4VQ56rq4kIuvDQ?fbclid=IwZXh0bgNhZW0CMTAAAR1l30on7Dhr4yV7aM4wyoAsCKsXqHWlJlhG1220oij8ae5SIy3vYLdogPY_aem_gjZq7IZHltbC53_jmnI7KQ';
  static const String year27Drive =
      'https://drive.google.com/drive/folders/1-1_Ef2qF0_rDzToD4OlqIl5xubgpMGU0';
  static const String year26Drive =
      'https://drive.google.com/drive/folders/1CdZDa3z97RN_yRjFlC7IAcLfmw6D1yLy';
  static const String year25Drive =
      'https://drive.google.com/drive/folders/1BAXez9FJKF_ASx79usd_-Xi47TdUYK73?fbclid=IwAR3cRtEV1aJrcvKoGNBLCbqBu2LMLrsWYfQkOZUb6SQE2dtT3ZtqrcCjxno';
  static const String year24Drive =
      'https://drive.google.com/drive/u/0/folders/11egB46e3wtl1Q69wdCBBam87bwMF7Qo-';

  static String Level(String semester) {
    switch (semester) {
      case "One":
      case "Two":
        return "First Level";

      case "Three":
      case "Four":
        return "Second Level";

      case "Five":
      case "Six":
        return "Third Level";

      case "Seven":
      case "Eight":
        return "Fourth Level";

      default:
        return null.toString();
    }
  }
}

class AppQueries {
  static screenHeight(context) => MediaQuery.of(context).size.height;
  static screenWidth(context) => MediaQuery.of(context).size.width;
}
/* if the user doesn't have an account */
