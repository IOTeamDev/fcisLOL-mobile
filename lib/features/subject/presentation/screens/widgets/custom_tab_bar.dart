import 'package:flutter/material.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit.dart';
import 'package:lol/core/utils/resources/colors_manager.dart';
import 'package:lol/main.dart';
import 'package:lol/features/subject/presentation/screens/widgets/tab_for_custom_tab_bar.dart';

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
      indicatorColor: MainCubit.get(context).isDark
          ? ColorsManager.white
          : ColorsManager.lightPrimary,
      indicatorWeight: 1.0,
      labelColor: MainCubit.get(context).isDark
          ? ColorsManager.white
          : ColorsManager.lightPrimary,
      dividerColor: ColorsManager.darkPrimary,
      unselectedLabelColor: MainCubit.get(context).isDark
          ? ColorsManager.darkPrimary
          : ColorsManager.lightGrey,
      controller: tabController,
      tabs: [
        TabForCustomTabBar(
          title: title1,
        ),
        TabForCustomTabBar(title: title2)
      ],
    );
  }
}
