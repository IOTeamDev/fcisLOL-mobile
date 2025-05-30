import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/core/models/profile/profile_model.dart';

import '../../../../../core/cubits/main_cubit/main_cubit.dart';
import '../../../../../core/utils/components.dart';
import '../../../../../core/utils/resources/assets_manager.dart';
import '../../../../../core/utils/resources/constants_manager.dart';
import '../../../../../core/utils/resources/fonts_manager.dart';
import '../../../../../core/utils/resources/icons_manager.dart';
import '../../../../../core/utils/resources/strings_manager.dart';
import '../../../../../core/utils/resources/values_manager.dart';
import '../../../../admin/presentation/view_model/admin_cubit/admin_cubit.dart';
import '../../../../admin/presentation/view_model/admin_cubit/admin_cubit_states.dart';
import '../../../data/models/semster_model.dart';
import '../widgets/build_announcements_row.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/subject_item_build.dart';

class HomeMobile extends StatelessWidget {
  HomeMobile(
      {super.key,
      required this.scaffoldKey,
      this.profile,
      required this.semesterIndex});
  final GlobalKey<ScaffoldState> scaffoldKey;
  final ProfileModel? profile;
  final int? semesterIndex;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              profile!.role == KeysManager.developer &&
              AppConstants.TOKEN != null)
            IconButton(
                onPressed: () {
                  AdminCubit.get(context).getAllSemestersAnnouncements();
                },
                icon: Icon(
                  IconsManager.devIcon,
                  color: Theme.of(context).iconTheme.color,
                )),
        ],
      ),
      drawer: Drawer(
        width: AppQueries.screenWidth(context)/AppSizesDouble.s1_5,
        child: CustomDrawer(AppConstants.TOKEN == null
            ? AppConstants.SelectedSemester ?? ''
            : MainCubit.get(context).profileModel!.semester),
      ),
      drawerEdgeDragWidth:
          AppQueries.screenWidth(context) * AppSizesDouble.s0_25,
      body: profile == null && AppConstants.TOKEN != null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () async {
                AdminCubit.get(context).getAnnouncements(profile != null
                    ? profile!.semester
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
                              style: Theme.of(context).textTheme.headlineLarge),
                        ), //Announcements Text
                        BlocBuilder<AdminCubit, AdminCubitStates>(
                            buildWhen: (previous, current) =>
                                current is AdminGetAnnouncementLoadingState ||
                                current is AdminGetAnnouncementSuccessState ||
                                current is AdminGetAnnouncementsErrorState,
                            builder: (context, state) {
                              if (state is AdminGetAnnouncementSuccessState) {
                                return BuildAnnouncementsRow(
                                    announcements:
                                        AdminCubit.get(context).announcements);
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
                          padding: const EdgeInsets.all(AppPaddings.p20),
                          child: divider(),
                        ), //divider
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppPaddings.p20),
                          child: Text(StringsManager.subject,
                              style: Theme.of(context).textTheme.headlineLarge),
                        ), // Subjects Text
                        if (semesterIndex != null)
                          Padding(
                            padding: const EdgeInsets.all(AppPaddings.p10),
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
                              itemCount:
                                  semesters[semesterIndex!].subjects.length,
                              itemBuilder: (context, index) {
                                return SubjectItemBuild(
                                  subject:
                                      semesters[semesterIndex!].subjects[index],
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
