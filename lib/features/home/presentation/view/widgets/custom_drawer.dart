import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:linkify/linkify.dart';
import 'package:lol/config/navigation/routes.dart';
import 'package:lol/core/data/local_data_provider.dart';
import 'package:lol/core/presentation/cubits/main_cubit/main_cubit.dart';
import 'package:lol/core/presentation/cubits/main_cubit/main_cubit_states.dart';
import 'package:lol/core/models/profile/profile_model.dart';
import 'package:lol/core/network/local/shared_preference.dart';
import 'package:lol/core/presentation/screen_size.dart';
import 'package:lol/core/utils/components.dart';
import 'package:lol/core/utils/navigation.dart';
import 'package:lol/core/resources/assets/assets_manager.dart';
import 'package:lol/core/resources/theme/colors_manager.dart';
import 'package:lol/core/resources/constants/constants_manager.dart';
import 'package:lol/core/resources/assets/fonts_manager.dart';
import 'package:lol/core/presentation/app_icons.dart';
import 'package:lol/core/resources/theme/values/app_strings.dart';
import 'package:lol/core/resources/theme/theme_provider.dart';
import 'package:lol/core/resources/theme/values/values_manager.dart';
import 'package:lol/features/admin/presentation/view/admin_panal.dart';
import 'package:lol/features/admin/presentation/view/announcements/announcements_list.dart';
import 'package:lol/features/auth/presentation/view/login/login.dart';
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
                    height: ScreenSize.height(context) / AppSizesDouble.s3_2,
                    child: UserAccountsDrawerHeader(
                      decoration: BoxDecoration(
                          color: Theme.of(context).drawerTheme.backgroundColor),
                      accountName: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(
                                maxWidth: ScreenSize.width(context) /
                                    AppSizesDouble.s1_5),
                            child: Text(
                              profileModel!.name,
                              style: Theme.of(context).textTheme.titleLarge,
                              maxLines: AppSizes.s1,
                            ),
                          ),
                          const Spacer(),
                          Text(LocalDataProvider.Level(profileModel!.semester),
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
                              AppStrings.profileInfo,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            icon: Icon(AppIcons.personIcon),
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
                      AppStrings.guest,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    accountEmail: Text(
                      LocalDataProvider.Level(
                          AppConstants.SelectedSemester ?? ''),
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
                        title: AppStrings.admin,
                        icon: AppIcons.adminIcon), //*Admin Panel
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
                      title: AppStrings.announcements,
                      icon: AppIcons.announcementsIcon), //*Announcements List
                  CustomTile(
                      onTap: () {
                        navigate(
                            context,
                            LeaderboardScreen(
                              semester: widget.semester,
                            ));
                      },
                      title: AppStrings.leaderboard,
                      icon: AppIcons.leaderboardIcon), //*Leaderboard
                  CustomExpansionTile(
                      title: AppStrings.years,
                      icon: AppIcons.schoolIcon,
                      children: [
                        CustomExpansionTile(
                            title: AppStrings.firstYear,
                            childrenPadding: AppPaddings.p15,
                            children: [
                              CustomTile(
                                onTap: () {
                                  AppConstants.navigatedSemester =
                                      AppStrings.one;
                                  navigate(
                                      context,
                                      SemesterNavigate(
                                          semester: AppStrings.one));
                                },
                                title: AppStrings.firstSemester,
                              ),
                              CustomTile(
                                onTap: () {
                                  AppConstants.navigatedSemester =
                                      AppStrings.two;
                                  navigate(
                                      context,
                                      SemesterNavigate(
                                          semester: AppStrings.two));
                                },
                                title: AppStrings.secondSemester,
                              ),
                            ]),
                        CustomExpansionTile(
                            childrenPadding: AppPaddings.p15,
                            title: AppStrings.secondYear,
                            children: [
                              CustomTile(
                                onTap: () {
                                  AppConstants.navigatedSemester =
                                      AppStrings.three;
                                  navigate(
                                      context,
                                      SemesterNavigate(
                                          semester: AppStrings.three));
                                },
                                title: AppStrings.firstSemester,
                              ),
                              CustomTile(
                                onTap: () {
                                  AppConstants.navigatedSemester =
                                      AppStrings.four;
                                  navigate(
                                      context,
                                      SemesterNavigate(
                                          semester: AppStrings.four));
                                },
                                title: AppStrings.secondSemester,
                              ),
                            ]),
                        CustomExpansionTile(
                            childrenPadding: AppPaddings.p15,
                            title: AppStrings.thirdYear,
                            children: [
                              CustomTile(
                                onTap: () {
                                  AppConstants.navigatedSemester =
                                      AppStrings.five;
                                  navigate(
                                      context,
                                      SemesterNavigate(
                                          semester: AppStrings.five));
                                },
                                title: AppStrings.firstSemester,
                              ),
                              CustomTile(
                                onTap: () {
                                  AppConstants.navigatedSemester =
                                      AppStrings.six;
                                  navigate(
                                      context,
                                      SemesterNavigate(
                                          semester: AppStrings.six));
                                },
                                title: AppStrings.secondSemester,
                              ),
                            ]),
                        CustomExpansionTile(
                            childrenPadding: AppPaddings.p15,
                            title: AppStrings.seniors,
                            children: [
                              CustomTile(
                                onTap: () {
                                  AppConstants.navigatedSemester =
                                      AppStrings.seven;
                                  navigate(
                                      context,
                                      SemesterNavigate(
                                          semester: AppStrings.seven));
                                },
                                title: AppStrings.firstSemester,
                              ),
                              CustomTile(
                                onTap: () {
                                  AppConstants.navigatedSemester =
                                      AppStrings.eight;
                                  navigate(
                                      context,
                                      SemesterNavigate(
                                          semester: AppStrings.eight));
                                },
                                title: AppStrings.secondSemester,
                              ),
                            ]),
                      ]), //*Years Navigation
                  CustomExpansionTile(
                      title: AppStrings.drive,
                      isImage: true,
                      imageIcon: AssetsManager.drive,
                      children: [
                        CustomTile(
                            onTap: () async {
                              LinkableElement url = LinkableElement(
                                  AppStrings.drive.toLowerCase(),
                                  AppConstants.year28Drive);
                              await onOpen(context, url);
                            },
                            title: AppStrings.year28),
                        CustomTile(
                            onTap: () async {
                              LinkableElement url = LinkableElement(
                                  AppStrings.drive.toLowerCase(),
                                  AppConstants.year27Drive);
                              await onOpen(context, url);
                            },
                            title: AppStrings.year27),
                        CustomTile(
                            onTap: () async {
                              LinkableElement url = LinkableElement(
                                  AppStrings.drive.toLowerCase(),
                                  AppConstants.year26Drive);
                              await onOpen(context, url);
                            },
                            title: AppStrings.year26),
                        CustomTile(
                            onTap: () async {
                              LinkableElement url = LinkableElement(
                                  AppStrings.drive.toLowerCase(),
                                  AppConstants.year25Drive);
                              await onOpen(context, url);
                            },
                            title: AppStrings.year25),
                        CustomTile(
                            onTap: () async {
                              LinkableElement url = LinkableElement(
                                  AppStrings.drive.toLowerCase(),
                                  AppConstants.year24Drive);
                              await onOpen(context, url);
                            },
                            title: AppStrings.year24),
                      ]), //*Drive
                  CustomTile(
                      onTap: () => navigate(context, UsefulLinks()),
                      icon: AppIcons.linkIcon,
                      title: AppStrings.links), //*Useful Links
                  CustomTile(
                      onTap: () => navigate(context, PreviousExams()),
                      icon: AppIcons.paperIcon,
                      title: AppStrings.exams), //*Previous Exams
                  CustomExpansionTile(
                      title: AppStrings.support,
                      icon: AppIcons.supportAgentIcon,
                      children: [
                        CustomTile(
                            onTap: () => navigate(context, ReportBug()),
                            title: AppStrings.reportBug),
                        CustomTile(
                            onTap: () => navigate(context, FeedbackScreen()),
                            title: AppStrings.feedback),
                        CustomTile(
                            onTap: () =>
                                navigate(context, ReleaseNotesScreen()),
                            title: AppStrings.releaseNotes),
                      ]), //*Support
                  CustomTile(
                    onTap: () => navigate(context, AboutUs()),
                    title: AppStrings.aboutUs,
                    icon: AppIcons.groupIcon,
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
                      maxWidth: ScreenSize.width(context) / AppSizes.s2,
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
                            title: AppStrings.logOut,
                            dialogType: DialogType.warning,
                            dismissOnTouchOutside: true,
                            barrierColor: ColorsManager.black
                                .withValues(alpha: AppSizesDouble.s0_7),
                            body: Text(
                              AppStrings.logOutWarningMessage,
                              style: Theme.of(context).textTheme.displayLarge,
                              textAlign: TextAlign.center,
                            ),
                            animType: AnimType.scale,
                            btnOkColor: ColorsManager.imperialRed,
                            btnCancelOnPress: () {},
                            btnOkText: AppStrings.logOut,
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
                          context.goNamed(ScreensName.registrationLayout);
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                              AppConstants.TOKEN != null
                                  ? AppIcons.logOutIcon
                                  : AppIcons.logInIcon,
                              color: ColorsManager.white),
                          SizedBox(
                            width: AppSizesDouble.s10,
                          ),
                          Text(
                            AppConstants.TOKEN != null
                                ? AppStrings.logOut
                                : AppStrings.login,
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
