import 'package:flutter/material.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit.dart';
import 'package:lol/core/utils/navigation.dart';
import 'package:lol/core/utils/resources/colors_manager.dart';
import 'package:lol/core/utils/resources/constants_manager.dart';
import 'package:lol/core/utils/resources/icons_manager.dart';
import 'package:lol/core/utils/resources/theme_provider.dart';
import 'package:lol/core/utils/resources/values_manager.dart';
import 'package:lol/features/pick_image/presentation/view/select_image.dart';
import 'package:lol/features/profile/view/widgets/basic_info_edit.dart';
import 'package:lol/features/profile/view/widgets/delete_account_section.dart';
import 'package:lol/features/profile/view/widgets/login_info_edit.dart';
import 'package:lol/features/subject/presentation/screens/widgets/custom_tab_bar_view.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 3, vsync: this, animationDuration: Duration.zero);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        centerTitle: true,
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          SizedBox(
            height: AppQueries.screenWidth(context) / 3,
            width: AppQueries.screenWidth(context) / 3,
            child: InkWell(
              splashColor: ColorsManager.transparent,
              onTap: () {},
              child: Stack(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: AppQueries.screenWidth(context) / 5,
                    backgroundImage: NetworkImage(
                        MainCubit.get(context).profileModel?.photo ??
                            AppConstants.defaultProfileImage),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: ColorsManager.black.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(100)),
                    width: AppQueries.screenWidth(context) / 2.5,
                    height: AppQueries.screenWidth(context) / 2.5,
                    child: Icon(
                      IconsManager.editIcon,
                      size: AppQueries.screenWidth(context) / 4,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(AppSizesDouble.s40)),
                  color: Provider.of<ThemeProvider>(context).isDark
                      ? ColorsManager.grey5
                      : ColorsManager.grey7),
              height: AppQueries.screenHeight(context) / 1.5,
              child: Column(
                children: [
                  TabBar(
                      indicatorColor: ColorsManager.lightPrimary,
                      indicatorWeight: 1.0,
                      indicatorAnimation: TabIndicatorAnimation.elastic,
                      labelColor: ColorsManager.lightPrimary,
                      dividerColor: ColorsManager.darkPrimary,
                      unselectedLabelColor: ColorsManager.lightGrey,
                      controller: _tabController,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelStyle: TextStyle(),
                      tabs: [
                        Tab(
                          text: 'Personal Info',
                          height: 40,
                        ),
                        Tab(
                          height: 40,
                          text: 'Change Password',
                        ),
                        Tab(
                          height: 40,
                          child: FittedBox(
                            child: AnimatedBuilder(
                              animation: _tabController,
                              builder: (context, _) {
                                final isLastTabSelected =
                                    _tabController.index == 2;
                                return AnimatedDefaultTextStyle(
                                  child: Text(
                                    'Delete Account',
                                  ),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: isLastTabSelected
                                        ? ColorsManager.imperialRed
                                        : ColorsManager.darkRed,
                                  ),
                                  duration: Duration(milliseconds: 70),
                                );
                              },
                            ),
                          ),
                        ),
                      ]),
                  Expanded(
                      child: TabBarView(children: [
                    BasicInfoEdit(
                        semester: MainCubit.get(context).profileModel!.semester,
                        phone: MainCubit.get(context).profileModel!.phone,
                        userName: MainCubit.get(context).profileModel!.name,
                        email: MainCubit.get(context).profileModel!.email),
                    LoginInfoEdit(),
                    DeleteAccountSection(),
                  ], controller: _tabController))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
