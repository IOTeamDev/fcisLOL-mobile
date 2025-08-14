import 'package:flutter/material.dart';
import 'package:lol/core/utils/responsive/device_type.dart';

import '../../resources/constants/constants_manager.dart';

class ResponsiveLayout extends StatelessWidget {
  ResponsiveLayout(
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
