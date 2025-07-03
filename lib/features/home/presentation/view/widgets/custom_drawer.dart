import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:linkify/linkify.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit_states.dart';
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
import 'package:lol/features/previous_exams/presentation/view/previous_exams.dart';
import 'package:lol/features/profile/view/profile.dart';
import 'package:lol/features/support_and_about_us/about_us.dart';
import 'package:lol/features/support_and_about_us/user_advices/presentation/view/feedback_screen.dart';
import 'package:lol/features/support_and_about_us/user_advices/presentation/view/release_notes_screen.dart';
import 'package:lol/features/support_and_about_us/user_advices/presentation/view/report_bug.dart';
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
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //header
            AppConstants.TOKEN != null
                ? SizedBox(
                    height:
                        AppQueries.screenHeight(context) / AppSizesDouble.s3_2,
                    child: UserAccountsDrawerHeader(
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
                      accountEmail: Container(
                        margin: EdgeInsets.zero, // Remove any margin
                        padding: EdgeInsets.zero, // Remove any padding
                        child: Padding(
                          padding: const EdgeInsets.only(top: AppPaddings.p5),
                          child: ElevatedButton.icon(
                            onPressed: () => navigate(context, const Profile()),
                            label: Text(
                              StringsManager.profileInfo,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            icon: Icon(IconsManager.personIcon),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent),
                          ),
                        ),
                      ),
                      currentAccountPicture: CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                          profileModel!.photo!,
                        ),
                        radius: 30,
                      ),
                    ),
                  )
                : UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor),
                    accountName: Text(
                      StringsManager.guest,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    accountEmail: Text(
                      AppConstants.Level(AppConstants.SelectedSemester ?? ''),
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    currentAccountPicture: const CircleAvatar(
                      backgroundImage:
                          NetworkImage(AppConstants.defaultProfileImage),
                    ),
                  ),
            //body
            Expanded(
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  if (profileModel?.role == KeysManager.admin ||
                      profileModel?.role == KeysManager.developer)
                    CustomTile(
                        onTap: () => navigate(context, AdminPanel()),
                        title: StringsManager.admin,
                        icon: IconsManager.adminIcon), //*Admin Panel
                  CustomTile(
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
                      title: StringsManager.announcements,
                      icon:
                          IconsManager.announcementsIcon), //*Announcements List
                  CustomTile(
                      onTap: () {
                        navigate(
                            context,
                            LeaderboardScreen(
                              semester: widget.semester,
                            ));
                      },
                      title: StringsManager.leaderboard,
                      icon: IconsManager.leaderboardIcon), //*Leaderboard
                  CustomExpansionTile(
                      title: StringsManager.years,
                      icon: IconsManager.schoolIcon,
                      children: [
                        CustomExpansionTile(
                            title: StringsManager.firstYear,
                            childrenPadding: AppPaddings.p15,
                            children: [
                              CustomTile(
                                onTap: () {
                                  AppConstants.navigatedSemester =
                                      StringsManager.one;
                                  navigate(
                                      context,
                                      SemesterNavigate(
                                          semester: StringsManager.one));
                                },
                                title: StringsManager.firstSemester,
                              ),
                              CustomTile(
                                onTap: () {
                                  AppConstants.navigatedSemester =
                                      StringsManager.two;
                                  navigate(
                                      context,
                                      SemesterNavigate(
                                          semester: StringsManager.two));
                                },
                                title: StringsManager.secondSemester,
                              ),
                            ]),
                        CustomExpansionTile(
                            childrenPadding: AppPaddings.p15,
                            title: StringsManager.secondYear,
                            children: [
                              CustomTile(
                                onTap: () {
                                  AppConstants.navigatedSemester =
                                      StringsManager.three;
                                  navigate(
                                      context,
                                      SemesterNavigate(
                                          semester: StringsManager.three));
                                },
                                title: StringsManager.firstSemester,
                              ),
                              CustomTile(
                                onTap: () {
                                  AppConstants.navigatedSemester =
                                      StringsManager.four;
                                  navigate(
                                      context,
                                      SemesterNavigate(
                                          semester: StringsManager.four));
                                },
                                title: StringsManager.secondSemester,
                              ),
                            ]),
                        CustomExpansionTile(
                            childrenPadding: AppPaddings.p15,
                            title: StringsManager.thirdYear,
                            children: [
                              CustomTile(
                                onTap: () {
                                  AppConstants.navigatedSemester =
                                      StringsManager.five;
                                  navigate(
                                      context,
                                      SemesterNavigate(
                                          semester: StringsManager.five));
                                },
                                title: StringsManager.firstSemester,
                              ),
                              CustomTile(
                                onTap: () {
                                  AppConstants.navigatedSemester =
                                      StringsManager.six;
                                  navigate(
                                      context,
                                      SemesterNavigate(
                                          semester: StringsManager.six));
                                },
                                title: StringsManager.secondSemester,
                              ),
                            ]),
                        CustomExpansionTile(
                            childrenPadding: AppPaddings.p15,
                            title: StringsManager.seniors,
                            children: [
                              CustomTile(
                                onTap: () {
                                  AppConstants.navigatedSemester =
                                      StringsManager.seven;
                                  navigate(
                                      context,
                                      SemesterNavigate(
                                          semester: StringsManager.seven));
                                },
                                title: StringsManager.firstSemester,
                              ),
                              CustomTile(
                                onTap: () {
                                  AppConstants.navigatedSemester =
                                      StringsManager.eight;
                                  navigate(
                                      context,
                                      SemesterNavigate(
                                          semester: StringsManager.eight));
                                },
                                title: StringsManager.secondSemester,
                              ),
                            ]),
                      ]), //*Years Navigation
                  CustomExpansionTile(
                      title: StringsManager.drive,
                      isImage: true,
                      imageIcon: AssetsManager.drive,
                      children: [
                        CustomTile(
                            onTap: () async {
                              LinkableElement url = LinkableElement(
                                  StringsManager.drive.toLowerCase(),
                                  AppConstants.year28Drive);
                              await onOpen(context, url);
                            },
                            title: StringsManager.year28),
                        CustomTile(
                            onTap: () async {
                              LinkableElement url = LinkableElement(
                                  StringsManager.drive.toLowerCase(),
                                  AppConstants.year27Drive);
                              await onOpen(context, url);
                            },
                            title: StringsManager.year27),
                        CustomTile(
                            onTap: () async {
                              LinkableElement url = LinkableElement(
                                  StringsManager.drive.toLowerCase(),
                                  AppConstants.year26Drive);
                              await onOpen(context, url);
                            },
                            title: StringsManager.year26),
                        CustomTile(
                            onTap: () async {
                              LinkableElement url = LinkableElement(
                                  StringsManager.drive.toLowerCase(),
                                  AppConstants.year25Drive);
                              await onOpen(context, url);
                            },
                            title: StringsManager.year25),
                        CustomTile(
                            onTap: () async {
                              LinkableElement url = LinkableElement(
                                  StringsManager.drive.toLowerCase(),
                                  AppConstants.year24Drive);
                              await onOpen(context, url);
                            },
                            title: StringsManager.year24),
                      ]), //*Drive
                  CustomTile(
                      onTap: () => navigate(context, UsefulLinks()),
                      icon: IconsManager.linkIcon,
                      title: StringsManager.links), //*Useful Links
                  CustomTile(
                      onTap: () => navigate(context, PreviousExams()),
                      icon: IconsManager.paperIcon,
                      title: StringsManager.exams), //*Previous Exams
                  CustomExpansionTile(
                      title: StringsManager.support,
                      icon: IconsManager.supportAgentIcon,
                      children: [
                        CustomTile(
                            onTap: () => navigate(context, ReportBug()),
                            title: StringsManager.reportBug),
                        CustomTile(
                            onTap: () => navigate(context, FeedbackScreen()),
                            title: StringsManager.feedback),
                        CustomTile(
                            onTap: () =>
                                navigate(context, ReleaseNotesScreen()),
                            title: StringsManager.releaseNotes),
                      ]), //*Support
                  CustomTile(
                    onTap: () => navigate(context, AboutUs()),
                    title: StringsManager.aboutUs,
                    icon: IconsManager.groupIcon,
                  ) //*About Us
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
                              style: Theme.of(context).textTheme.displayLarge,
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
                          Cache.removeValue(key: KeysManager.isDark);
                          Cache.removeValue(key: KeysManager.token);
                          AppConstants.SelectedSemester = null;
                          AppConstants.TOKEN = null;
                          AppConstants.navigatedSemester = null;
                          AppConstants.previousExamsSelectedSubject = null;
                          AppConstants.previousExamsSelectedSemester = null;
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
                                .copyWith(
                                    fontWeight: FontWeightManager.semiBold,
                                    color: ColorsManager.white),
                          ),
                        ],
                      )),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
