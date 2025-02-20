import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:linkify/linkify.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit.dart';
import 'package:lol/core/models/profile/profile_model.dart';
import 'package:lol/core/network/local/shared_preference.dart';
import 'package:lol/core/utils/components.dart';
import 'package:lol/core/utils/navigation.dart';
import 'package:lol/core/utils/resources/assets_manager.dart';
import 'package:lol/core/utils/resources/colors_manager.dart';
import 'package:lol/core/utils/resources/constants_manager.dart';
import 'package:lol/core/utils/resources/fonts_manager.dart';
import 'package:lol/core/utils/resources/icons_manager.dart';
import 'package:lol/core/utils/resources/strings_manager.dart';
import 'package:lol/core/utils/resources/theme_provider.dart';
import 'package:lol/core/utils/resources/values_manager.dart';
import 'package:lol/features/admin/presentation/view/admin_panal.dart';
import 'package:lol/features/admin/presentation/view/announcements/announcements_list.dart';
import 'package:lol/features/auth/presentation/view/login.dart';
import 'package:lol/features/auth/presentation/view/registration_layout.dart';
import 'package:lol/features/home/presentation/view/semester_navigate.dart';
import 'package:lol/features/leaderboard/presentation/view/leaderboard_view.dart';
import 'package:lol/features/previous_exams/previous_exams.dart';
import 'package:lol/features/profile/view/profile.dart';
import 'package:lol/features/support_and_about_us/about_us.dart';
import 'package:lol/features/support_and_about_us/user_advices/feedback_screen.dart';
import 'package:lol/features/support_and_about_us/user_advices/report_bug.dart';
import 'package:lol/features/useful_links/useful_links.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer(this.semester, {super.key});
  final String semester;

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  ProfileModel? profileModel;
  @override
  Widget build(BuildContext context) {
    if (AppConstants.TOKEN != null) {
      profileModel = MainCubit.get(context).profileModel;
    }
    return Drawer(
      width: AppQueries.screenWidth(context) < AppSizes.s600
          ? AppQueries.screenWidth(context) / AppSizesDouble.s1_5
          : AppQueries.screenWidth(context) / AppSizesDouble.s2_5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //header
          AppConstants.TOKEN != null
              ? SizedBox(
                  height:
                      AppQueries.screenHeight(context) / AppSizesDouble.s3_2,
                  child: UserAccountsDrawerHeader(
                    otherAccountsPictures: [
                      IconButton(
                          onPressed: () {
                            Provider.of<ThemeProvider>(context, listen: false)
                                .toggleDarkMode();
                          },
                          icon: Icon(
                            Provider.of<ThemeProvider>(context).isDark
                                ? IconsManager.lightModeIcon
                                : IconsManager.darkModeIcon,
                            color: Theme.of(context).iconTheme.color,
                          ))
                    ],
                    decoration: BoxDecoration(
                        color: Theme.of(context).drawerTheme.backgroundColor),
                    accountName: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                              maxWidth: AppQueries.screenWidth(context) /
                                  AppSizesDouble.s1_5),
                          child: Text(
                            profileModel!.name,
                            style: Theme.of(context).textTheme.titleLarge,
                            maxLines: AppSizes.s1,
                          ),
                        ),
                        const Spacer(),
                        Text(AppConstants.Level(profileModel!.semester),
                            style: Theme.of(context).textTheme.bodyLarge),
                      ],
                    ),
                    // accountEmail: Text("2nd year "),
                    accountEmail: Container(
                      margin: EdgeInsets.zero, // Remove any margin
                      padding: EdgeInsets.zero, // Remove any padding
                      child: Padding(
                        padding: const EdgeInsets.only(top: AppPaddings.p5),
                        child: GestureDetector(
                          onTap: () => navigate(context, const Profile()),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(IconsManager.personIcon),
                              SizedBox(width: AppSizesDouble.s10),
                              Text(
                                StringsManager.profileInfo,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    currentAccountPicture: ClipOval(
                      child: Image.network(
                        profileModel!.photo ?? AppConstants.defaultProfileImage,
                        width: AppSizesDouble.s10,
                        height: AppSizesDouble.s10,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
              : UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor),
                  accountName: const Text(StringsManager.guest),
                  accountEmail: Text(
                    AppConstants.Level(AppConstants.SelectedSemester ?? ''),
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  currentAccountPicture: const CircleAvatar(
                    backgroundImage:
                        NetworkImage(AppConstants.defaultProfileImage),
                  ),
                  otherAccountsPictures: [
                    IconButton(
                        onPressed: () {
                          Provider.of<ThemeProvider>(context, listen: false)
                              .toggleDarkMode();
                        },
                        icon: Icon(
                          Provider.of<ThemeProvider>(context).isDark
                              ? IconsManager.lightModeIcon
                              : IconsManager.darkModeIcon,
                          color: Theme.of(context).iconTheme.color,
                        ))
                  ],
                ),
          //body
          Expanded(
            child: SingleChildScrollView(
                child: Column(
              //mainAxisSize: MainAxisSize.max,
              children: [
                if (profileModel?.role == KeysManager.admin)
                  ListTile(
                    leading: Icon(
                      IconsManager.adminIcon,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    title: Text(
                      StringsManager.admin,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.zero), // Removes divider when expanded
                    onTap: () => navigate(context, AdminPanel()),
                  ), //admin panel
                ListTile(
                  leading: Icon(
                    IconsManager.announcementsIcon,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  title: Text(
                    StringsManager.announcements,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.zero), // Removes divider when expanded
                  onTap: () {
                    if (AppConstants.TOKEN == null) {
                      navigate(
                          context,
                          AnnouncementsList(
                              semester: AppConstants.SelectedSemester!));
                    } else {
                      navigate(
                          context,
                          AnnouncementsList(
                              semester: MainCubit.get(context)
                                  .profileModel!
                                  .semester));
                    }
                  },
                ), //announcements list
                ListTile(
                  leading: Icon(
                    IconsManager.leaderboardIcon,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  title: Text(
                    StringsManager.leaderboard,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.zero), // Removes divider when expanded
                  onTap: () {
                    navigate(
                        context,
                        LeaderboardScreen(
                          semester: widget.semester,
                        ));
                  },
                ), //leaderboard
                ExpansionTile(
                  leading: Icon(
                    IconsManager.schoolIcon,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  title: Text(
                    StringsManager.years,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  childrenPadding:
                      EdgeInsets.symmetric(horizontal: AppPaddings.p10),
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.zero), // Removes divider when expanded
                  collapsedShape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.zero), // Removes divider when collapsed
                  children: [
                    ExpansionTile(
                      title: Text(
                        StringsManager.firstYear,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius
                              .zero), // Removes divider when expanded
                      collapsedShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius
                              .zero), // Removes divider when collapsed
                      childrenPadding:
                          EdgeInsets.symmetric(horizontal: AppPaddings.p20),
                      children: [
                        ListTile(
                          title: Text(
                            StringsManager.firstSemester,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius
                                  .zero), // Removes divider when expanded
                          onTap: () {
                            navigate(context,
                                SemesterNavigate(semester: StringsManager.one));
                          },
                        ),
                        ListTile(
                          title: Text(
                            StringsManager.secondSemester,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius
                                  .zero), // Removes divider when expanded
                          onTap: () {
                            navigate(context,
                                SemesterNavigate(semester: StringsManager.two));
                          },
                        ),
                      ],
                    ), //1st year materials
                    ExpansionTile(
                      title: Text(
                        StringsManager.secondYear,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      childrenPadding:
                          EdgeInsets.symmetric(horizontal: AppPaddings.p10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius
                              .zero), // Removes divider when expanded
                      collapsedShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius
                              .zero), // Removes divider when collapsed
                      children: [
                        ListTile(
                          title: Text(
                            StringsManager.firstSemester,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius
                                  .zero), // Removes divider when expanded
                          onTap: () {
                            navigate(
                                context,
                                SemesterNavigate(
                                    semester: StringsManager.three));
                          },
                        ),
                        ListTile(
                          title: Text(
                            StringsManager.secondSemester,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius
                                  .zero), // Removes divider when expanded
                          onTap: () {
                            navigate(
                                context,
                                SemesterNavigate(
                                    semester: StringsManager.four));
                          },
                        ),
                      ],
                    ), //2nd year materials
                    ExpansionTile(
                      title: Text(
                        StringsManager.thirdYear,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius
                              .zero), // Removes divider when expanded
                      collapsedShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius
                              .zero), // Removes divider when collapsed
                      childrenPadding:
                          EdgeInsets.symmetric(horizontal: AppPaddings.p10),
                      children: [
                        ListTile(
                          title: Text(
                            StringsManager.firstSemester,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius
                                  .zero), // Removes divider when expanded
                          onTap: () {
                            navigate(
                                context,
                                SemesterNavigate(
                                    semester: StringsManager.five));
                          },
                        ),
                        ListTile(
                          title: Text(
                            StringsManager.secondSemester,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius
                                  .zero), // Removes divider when expanded
                          onTap: () {
                            navigate(context,
                                SemesterNavigate(semester: StringsManager.six));
                          },
                        ),
                      ],
                    ), //3rd year materials
                    InkWell(
                      onTap: () => showToastMessage(
                          message: StringsManager.currentlyUpdating,
                          states: ToastStates.INFO),
                      child: ExpansionTile(
                        enabled: false,
                        title: Text(
                          StringsManager.seniors,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        //currently Not Used
                        // children: [
                        //   ListTile(
                        //     title: const Text("First Semester"),
                        //     onTap: () {
                        //       // MainCubit.get(context).profileModel = null;
                        //       // TOKEN = null;
                        //       navigate(context,
                        //           const SemesterNavigate(semester: "One"));
                        //     },
                        //   ),
                        //   ListTile(
                        //     title: const Text("Second Semester"),
                        //     onTap: () {
                        //       // MainCubit.get(context).profileModel = null;
                        //       // TOKEN = null;
                        //       navigate(context,
                        //           const SemesterNavigate(semester: "Two"));
                        //     },
                        //   ),
                        // ],
                      ),
                    ),
                  ],
                ), //years materials
                ExpansionTile(
                  leading: Image.asset(
                    AssetsManager.drive,
                    width: AppSizesDouble.s25,
                    height: AppSizesDouble.s25,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  title: Text(
                    StringsManager.drive,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.zero), // Removes divider when expanded
                  collapsedShape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.zero), // Removes divider when collapsed
                  childrenPadding:
                      EdgeInsets.symmetric(horizontal: AppPaddings.p20),
                  children: [
                    ListTile(
                      title: Text(
                        StringsManager.year28,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      onTap: () async {
                        LinkableElement url = LinkableElement(
                            StringsManager.drive.toLowerCase(),
                            AppConstants.year28Drive);
                        await onOpen(context, url);
                      },
                    ),
                    ListTile(
                      title: Text(
                        StringsManager.year27,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      onTap: () async {
                        LinkableElement url = LinkableElement(
                            StringsManager.drive.toLowerCase(),
                            AppConstants.year27Drive);
                        await onOpen(context, url);
                      },
                    ),
                    ListTile(
                      title: Text(
                        StringsManager.year26,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      onTap: () async {
                        LinkableElement url = LinkableElement(
                            StringsManager.drive.toLowerCase(),
                            AppConstants.year26Drive);
                        await onOpen(context, url);
                      },
                    ),
                    ListTile(
                      title: Text(
                        StringsManager.year25,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      onTap: () async {
                        LinkableElement url = LinkableElement(
                            StringsManager.drive.toLowerCase(),
                            AppConstants.year25Drive);
                        await onOpen(context, url);
                      },
                    ),
                    ListTile(
                      title: Text(
                        StringsManager.year24,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      onTap: () async {
                        LinkableElement url = LinkableElement(
                            StringsManager.drive.toLowerCase(),
                            AppConstants.year24Drive);
                        await onOpen(context, url);
                      },
                    ),
                  ],
                ), //Drive
                ListTile(
                  leading: Icon(
                    IconsManager.linkIcon,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  title: Text(
                    StringsManager.links,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  onTap: () => navigate(context, UsefulLinks()),
                ), //important links
                ListTile(
                  leading: Icon(
                    IconsManager.paperIcon,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  title: Text(
                    StringsManager.exams,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  onTap: () => navigate(context, PreviousExams()),
                ), //Exams
                ExpansionTile(
                  leading: Icon(
                    IconsManager.supportAgentIcon,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  title: Text(
                    StringsManager.support,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.zero), // Removes divider when expanded
                  collapsedShape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.zero), // Removes divider when collapsed
                  childrenPadding:
                      EdgeInsets.symmetric(horizontal: AppPaddings.p20),
                  children: [
                    ListTile(
                      title: Text(
                        StringsManager.reportBug,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      onTap: () {
                        navigate(context, ReportBug());
                      },
                    ),
                    ListTile(
                      title: Text(
                        StringsManager.feedback,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      onTap: () {
                        navigate(context, FeedbackScreen());
                      },
                    ),
                  ],
                ), //support
                ListTile(
                  leading: Icon(
                    IconsManager.groupIcon,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  title: Text(
                    StringsManager.aboutUs,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  onTap: () {
                    navigate(context, AboutUs());
                  },
                ), //about us
              ],
            )),
          ),
          // login/logout button
          Padding(
            padding: EdgeInsets.symmetric(vertical: AppPaddings.p20),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: AppQueries.screenWidth(context) / AppSizes.s2,
                    minWidth: AppSizesDouble.s150),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.TOKEN != null
                            ? ColorsManager.imperialRed
                            : ColorsManager.green,
                        padding:
                            EdgeInsets.symmetric(vertical: AppPaddings.p15)),
                    onPressed: () {
                      if (AppConstants.TOKEN != null) {
                        AwesomeDialog(
                          context: context,
                          title: StringsManager.logOut,
                          dialogType: DialogType.warning,
                          dismissOnTouchOutside: true,
                          barrierColor: ColorsManager.black
                              .withValues(alpha: AppSizesDouble.s0_7),
                          body: Text(
                            StringsManager.logOutWarningMessage,
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(color: ColorsManager.black),
                            textAlign: TextAlign.center,
                          ),
                          animType: AnimType.scale,
                          btnOkColor: ColorsManager.imperialRed,
                          btnCancelOnPress: () {},
                          btnOkText: StringsManager.logOut,
                          btnCancelColor: ColorsManager.grey,
                          btnOkOnPress: () {
                            MainCubit.get(context).logout(context);
                          },
                        ).show();
                      } else {
                        Cache.writeData(key: KeysManager.isDark, value: false);
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => RegistrationLayout(),
                          ),
                          (route) => false,
                        );
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                            AppConstants.TOKEN != null
                                ? IconsManager.logOutIcon
                                : IconsManager.logInIcon,
                            color: ColorsManager.white),
                        SizedBox(
                          width: AppSizesDouble.s10,
                        ),
                        Text(
                          AppConstants.TOKEN != null
                              ? StringsManager.logOut
                              : StringsManager.login,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontWeight: FontWeightManager.semiBold),
                        ),
                      ],
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
