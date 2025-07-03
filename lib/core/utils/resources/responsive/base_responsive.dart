import 'package:flutter/material.dart';

import '../constants_manager.dart';

class BaseResponsive extends StatelessWidget {
  BaseResponsive(
      {super.key, required this.mobileLayout, required this.tabletLayout});

  final Widget mobileLayout;
  final Widget tabletLayout;

  @override
  Widget build(BuildContext context) {
    final _deviceType = getDeviceType(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        switch (_deviceType) {
          case DeviceType.TABLET:
            return tabletLayout;
          default:
            return mobileLayout;
        }
      },
    );
  }
}
