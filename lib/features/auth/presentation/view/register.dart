import 'package:flutter/material.dart';
import 'package:lol/core/utils/resources/responsive/base_responsive.dart';
import 'package:lol/features/auth/presentation/view/registeration/register_desktop.dart';
import 'package:lol/features/auth/presentation/view/registeration/register_mobile.dart';
import 'package:lol/features/auth/presentation/view/registeration/register_tablet.dart';

class Registerscreen extends StatelessWidget {
  const Registerscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseResponsive(
        mobileLayout: RegisterMobile(),
        tabletLayout: RegisterTablet(),
        desktopLayout: RegisterDesktop());
  }
}
