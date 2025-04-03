import 'dart:developer';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lol/core/utils/resources/assets_manager.dart';
import 'package:lol/core/utils/resources/colors_manager.dart';
import 'package:lol/core/utils/resources/fonts_manager.dart';
import 'package:lol/core/utils/resources/icons_manager.dart';
import 'package:lol/core/utils/resources/routes_manager.dart';
import 'package:lol/core/utils/resources/strings_manager.dart';
import 'package:lol/core/utils/resources/theme_provider.dart';
import 'package:lol/core/utils/resources/values_manager.dart';
import 'package:lol/features/auth/presentation/view/registration_layout.dart';
import 'package:lol/features/home/presentation/view/semester_navigate.dart';
import 'package:lol/core/models/admin/announcement_model.dart';
import 'package:lol/features/home/data/models/semster_model.dart';
import 'package:lol/core/models/profile/profile_model.dart';
import 'package:lol/features/admin/presentation/view_model/admin_cubit/admin_cubit.dart';
import 'package:lol/features/admin/presentation/view_model/admin_cubit/admin_cubit_states.dart';
import 'package:lol/features/admin/presentation/view/announcements/announcement_detail.dart';
import 'package:lol/features/auth/presentation/view/login.dart';
import 'package:lol/features/home/presentation/view/widgets/build_announcements_row.dart';
import 'package:lol/features/home/presentation/view/widgets/custom_drawer.dart';
import 'package:lol/features/home/presentation/view/widgets/subject_item_build.dart';
import 'package:lol/features/leaderboard/presentation/view/leaderboard_view.dart';
import 'package:lol/features/previous_exams/presentation/view/previous_exams.dart';
import 'package:lol/features/subject/data/repos/subject_repo_imp.dart';
import 'package:lol/features/subject/presentation/cubit/get_material_cubit/get_material_cubit.dart';
import 'package:lol/features/subject/presentation/screens/subject_details.dart';
import 'package:lol/features/support_and_about_us/about_us.dart';
import 'package:lol/features/support_and_about_us/user_advices/presentation/view/feedback_screen.dart';
import 'package:lol/features/support_and_about_us/user_advices/presentation/view/report_bug.dart';
import 'package:lol/core/utils/components.dart';
import 'package:lol/core/utils/resources/constants_manager.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit_states.dart';
import 'package:lol/features/profile/view/profile.dart';
import 'package:lol/features/useful_links/useful_links.dart';
import 'package:lol/main.dart';
import 'package:lol/core/utils/navigation.dart';
import 'package:lol/core/utils/dependencies_helper.dart';
import 'package:lol/core/network/local/shared_preference.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../admin/presentation/view/announcements/announcements_list.dart';
import '../../../admin/presentation/view/admin_panal.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    log(AppConstants.TOKEN ?? 'token');
    log(AppConstants.SelectedSemester ?? 'semester');
    context.read<MainCubit>().getProfileInfo();
    scaffoldKey = GlobalKey<ScaffoldState>();
  }

  late GlobalKey<ScaffoldState> scaffoldKey;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainCubitStates>(listener: (context, state) {
      if (state is GetProfileSuccess) {
        AdminCubit.get(context).getAnnouncements(
            MainCubit.get(context).profileModel?.semester ??
                AppConstants.SelectedSemester!);
        MainCubit.get(context).updateUser(
            userID: MainCubit.get(context).profileModel!.id,
            fcmToken: fcmToken);
      }
      if (state is GetProfileFailure && AppConstants.SelectedSemester != null) {
        AdminCubit.get(context)
            .getAnnouncements(AppConstants.SelectedSemester!);
      }
      if (state is LogoutSuccess) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => RegistrationLayout(),
          ),
          (route) => false,
        );
        showToastMessage(
          message: StringsManager.logOutSuccessfully,
          states: ToastStates.SUCCESS,
        );
      }
      if (state is DeleteAccountFailed) {
        showToastMessage(
            message: 'Unable to delete your account now',
            states: ToastStates.ERROR);
      }
      if (state is DeleteAccountSuccessState) {
        showToastMessage(
            message: 'Your Account was deleted', states: ToastStates.SUCCESS);
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => RegistrationLayout(),
          ),
          (route) => false,
        );
      }
    }, builder: (context, state) {
      ProfileModel? profile;
      int? semesterIndex;
      if (MainCubit.get(context).profileModel != null) {
        profile = MainCubit.get(context).profileModel!;
      }
      if (profile != null) {
        semesterIndex = semsesterIndex(profile.semester);
      } else if (AppConstants.TOKEN == null) {
        semesterIndex = semsesterIndex(AppConstants.SelectedSemester!);
      }
      return profile == null && AppConstants.TOKEN != null
          ? const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            )
          : Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                leading: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      if ((AppConstants.TOKEN != null && profile != null) ||
                          AppConstants.TOKEN == null) {
                        scaffoldKey.currentState!
                            .openDrawer(); // Use key to open the drawer
                      }
                    },
                    icon: Icon(
                      IconsManager.filledGridIcon,
                    )), //drawer icon
                centerTitle: true,
                title: Text(
                  StringsManager.home,
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(fontWeight: FontWeightManager.semiBold),
                ),
                actions: [
                  if (profile != null &&
                      profile.role == KeysManager.developer &&
                      AppConstants.TOKEN != null)
                    IconButton(
                        onPressed: () {
                          AdminCubit.get(context)
                              .getAllSemestersAnnouncements();
                        },
                        icon: Icon(
                          IconsManager.devIcon,
                          color: Theme.of(context).iconTheme.color,
                        )),
                ],
              ),
              drawer: CustomDrawer(AppConstants.TOKEN == null
                  ? AppConstants.SelectedSemester ?? ''
                  : MainCubit.get(context).profileModel!.semester),
              drawerEdgeDragWidth:
                  AppQueries.screenWidth(context) * AppSizesDouble.s0_4,
              body: profile == null && AppConstants.TOKEN != null
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        AdminCubit.get(context).getAnnouncements(profile != null
                            ? profile.semester
                            : AppConstants.SelectedSemester!);
                        return Future.value();
                      },
                      child: SingleChildScrollView(
                        child: SafeArea(
                          child: Padding(
                            padding: EdgeInsets.all(AppPaddings.p8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: AppPaddings.p20,
                                      vertical: AppPaddings.p10),
                                  child: Text(StringsManager.announcements,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge),
                                ), //Announcements Text
                                BlocBuilder<AdminCubit, AdminCubitStates>(
                                    buildWhen: (previous, current) =>
                                        current is AdminGetAnnouncementLoadingState ||
                                        current
                                            is AdminGetAnnouncementSuccessState ||
                                        current
                                            is AdminGetAnnouncementsErrorState,
                                    builder: (context, state) {
                                      if (state
                                          is AdminGetAnnouncementSuccessState) {
                                        return BuildAnnouncementsRow(
                                            announcements:
                                                AdminCubit.get(context)
                                                    .announcements);
                                      } else if (state
                                          is AdminGetAnnouncementLoadingState) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else if (state
                                          is AdminGetAnnouncementsErrorState) {
                                        return Image.asset(
                                            AssetsManager.emptyAnnouncements);
                                      } else {
                                        return const SizedBox();
                                      }
                                    }), //Announcements Carousel Slider
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: AppPaddings.p20,
                                      vertical: AppPaddings.p20),
                                  child: divider(),
                                ), //divider
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: AppPaddings.p20),
                                  child: Text(StringsManager.subject,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge),
                                ), // Subjects Text
                                Padding(
                                  padding:
                                      const EdgeInsets.all(AppPaddings.p10),
                                  child: GridView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(), // Disable scrolling in the GridView
                                    shrinkWrap:
                                        true, // Shrink the GridView to fit its content
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount:
                                          AppSizes.s2, // Two items per row
                                      crossAxisSpacing: AppSizesDouble.s10,
                                      mainAxisSpacing: AppSizesDouble.s10,
                                    ),
                                    itemCount: semesters[semesterIndex!]
                                        .subjects
                                        .length,
                                    itemBuilder: (context, index) =>
                                        SubjectItemBuild(
                                      subject: semesters[semesterIndex!]
                                          .subjects[index],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
            );
    });
  }
}
