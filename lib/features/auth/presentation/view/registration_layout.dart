import 'package:flutter/material.dart';
import 'package:lol/core/utils/resources/colors_manager.dart';
import 'package:lol/core/utils/resources/constants_manager.dart';
import 'package:lol/features/auth/presentation/view/login.dart';
import 'package:lol/features/auth/presentation/view/register.dart';

class RegistrationLayout extends StatefulWidget {
  RegistrationLayout({super.key});

  @override
  State<RegistrationLayout> createState() => _RegistrationLayoutState();
}

class _RegistrationLayoutState extends State<RegistrationLayout> with SingleTickerProviderStateMixin{
  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorsManager.white,
        appBar: AppBar(
          backgroundColor: ColorsManager.white,

        ),
        body: Column(
          children: [
            TabBar(
                indicatorColor: ColorsManager.lightPrimary,
                dividerColor: ColorsManager.grey1,
                labelColor: ColorsManager.lightPrimary,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorAnimation: TabIndicatorAnimation.elastic,
                unselectedLabelColor: ColorsManager.grey1,
                controller: _tabController,
                tabs: [
                  Tab(
                    text: 'Login',
                  ),
                  Tab(
                    text: 'Register',
                  )
                ]
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  LoginScreen(),
                  Registerscreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
