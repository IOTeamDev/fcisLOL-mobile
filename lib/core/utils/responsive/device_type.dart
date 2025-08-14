import 'package:flutter/material.dart';
import 'package:lol/core/utils/responsive/break_points.dart';

enum DeviceType { MOBILE, TABLET }

DeviceType getDeviceType(context) {
  final width = MediaQuery.of(context).size.width;

  if (width >= Breakpoints.mobile) {
    return DeviceType.TABLET;
  }
  return DeviceType.MOBILE;
}
