import 'package:flutter/material.dart';
import 'package:lol/core/utils/resources/responsive/base_responsive.dart';
import 'package:lol/features/auth/presentation/view/choosing_year/choosing_year_mobile.dart';
import 'package:lol/features/auth/presentation/view/choosing_year/choosing_year_tablet.dart';

class ChoosingYear extends StatefulWidget {
  ChoosingYear({
    super.key,
  });

  @override
  State<ChoosingYear> createState() => _ChoosingYearState();
}

class _ChoosingYearState extends State<ChoosingYear> {
  @override
  Widget build(BuildContext context) {
    return BaseResponsive(
      mobileLayout: ChoosingYearMobile(),
      tabletLayout: ChoosingYearTablet(),
    );
  }
}
