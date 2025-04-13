import 'package:flutter/material.dart';

import '../constants_manager.dart';

class BaseResponsive extends StatelessWidget {
  BaseResponsive({super.key, required this.mobileLayout, required this.tabletLayout, required this.desktopLayout});

  Widget mobileLayout;
  Widget tabletLayout;
  Widget desktopLayout;

  @override
  Widget build(BuildContext context) {
    final _deviceType = getDeviceType(context);
    return LayoutBuilder(
        builder: (context, constraints) {
          switch (_deviceType){
            case DeviceType.MOBILE:
              return mobileLayout;
            case DeviceType.TABLET:
              return tabletLayout;
            default:
              return desktopLayout;
          }
        }
    );
  }
}
