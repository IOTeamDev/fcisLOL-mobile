import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lol/main.dart';
import 'package:lol/modules/subject/screens/widgets/tab_for_custom_tab_bar.dart';

class CustomTabBar extends StatelessWidget {
  const CustomTabBar(
      {super.key,
      required this.tabController,
      required this.title1,
      required this.title2});
  final TabController tabController;
  final String title1;
  final String title2;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      indicatorColor: isDark ? Colors.white : HexColor('#4764C5'),
      indicatorWeight: 1.0,
      labelColor: isDark ? Colors.white : HexColor('#4764C5'),
      dividerColor: Color.fromRGBO(96, 96, 96, 1),
      unselectedLabelColor:
          isDark ? Color.fromRGBO(59, 59, 59, 1) : HexColor('#757575'),
      controller: tabController,
      tabs: [
        TabForCustomTabBar(
          title: title1,
        ),
        TabForCustomTabBar(title: title2)
      ],
    );
    ;
  }
}
