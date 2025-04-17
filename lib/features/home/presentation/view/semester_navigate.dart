import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit.dart';
import 'package:lol/core/utils/resources/theme_provider.dart';
import 'package:lol/core/utils/resources/values_manager.dart';
import 'package:lol/features/home/presentation/view/home.dart';
import 'package:lol/features/home/presentation/view/widgets/build_announcements_row.dart';
import 'package:lol/features/home/presentation/view/widgets/subject_item_build.dart';
import 'package:lol/main.dart';
import 'package:lol/features/home/data/models/semster_model.dart';
import 'package:lol/core/utils/components.dart';
import 'package:lol/core/utils/resources/constants_manager.dart';
import 'package:lol/core/utils/navigation.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/resources/assets_manager.dart';
import '../../../../core/utils/resources/colors_manager.dart';
import '../../../../core/utils/resources/strings_manager.dart';
import '../../../admin/presentation/view_model/admin_cubit/admin_cubit.dart';
import '../../../admin/presentation/view_model/admin_cubit/admin_cubit_states.dart';

class SemesterNavigate extends StatelessWidget {
  final String semester;
  const SemesterNavigate({super.key, required this.semester});

  @override
  Widget build(BuildContext context) {
    int semesterIndex = getSemesterIndex(semester);
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result){
        if(!didPop){
          return;
        }
        AppConstants.navigatedSemester = MainCubit.get(context).profileModel!= null? MainCubit.get(context).profileModel!.semester:AppConstants.SelectedSemester;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            StringsManager.semester+ StringsManager.space + semester,
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(AppPaddings.p8),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if(MainCubit.get(context).profileModel != null && MainCubit.get(context).profileModel!.role == KeysManager.developer && AdminCubit.get(context).allSemestersAnnouncements[semester] != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppPaddings.p20,
                      vertical: AppPaddings.p10
                    ),
                    child: Text(
                      StringsManager.announcements,
                      style: Theme.of(context).textTheme.headlineLarge
                    ),
                  ),
                  if(MainCubit.get(context).profileModel != null && MainCubit.get(context).profileModel!.role == KeysManager.developer && AdminCubit.get(context).allSemestersAnnouncements[semester] != null)
                  BlocBuilder<AdminCubit, AdminCubitStates>(
                    buildWhen: (previous, current) =>
                    current is AdminGetAnnouncementLoadingState ||
                        current is AdminGetAnnouncementSuccessState ||
                        current is AdminGetAnnouncementsErrorState,
                    builder: (context, state) {
                      if (state is AdminGetAnnouncementSuccessState) {
                        return BuildAnnouncementsRow(announcements: AdminCubit.get(context).allSemestersAnnouncements[semester]!);
                      } else if (state is AdminGetAnnouncementLoadingState) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state is AdminGetAnnouncementsErrorState) {
                        return Image.asset(AssetsManager.emptyAnnouncements);
                      } else {
                        return const SizedBox();
                      }
                    }
                  ),
                  if(MainCubit.get(context).profileModel != null && MainCubit.get(context).profileModel!.role == KeysManager.developer && AdminCubit.get(context).allSemestersAnnouncements[semester] != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppPaddings.p20,
                      vertical: AppPaddings.p20
                    ),
                    child: divider(),
                  ),
                  if(MainCubit.get(context).profileModel != null && MainCubit.get(context).profileModel!.role == KeysManager.developer && AdminCubit.get(context).allSemestersAnnouncements[semester] != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppPaddings.p20),
                    child: Text(StringsManager.subject,
                      style: Theme.of(context)
                        .textTheme
                        .headlineLarge
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(AppPaddings.p10),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: AppSizes.s2, // Two items per row
                        crossAxisSpacing: AppSizesDouble.s10,
                        mainAxisSpacing: AppSizesDouble.s10,
                      ),
                      itemCount: semesters[semesterIndex].subjects.length,
                      itemBuilder: (context, index) {
                        return SubjectItemBuild(
                          subject: semesters[semesterIndex].subjects[index],
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
