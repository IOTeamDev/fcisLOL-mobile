import 'package:flutter/material.dart';

abstract class ScreenSize {
  static height(context) => MediaQuery.of(context).size.height;
  static width(context) => MediaQuery.of(context).size.width;
}
