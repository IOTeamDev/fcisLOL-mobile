import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit.dart';
import 'package:lol/core/models/admin/announcement_model.dart';
import 'package:lol/core/utils/navigation.dart';
import 'package:lol/core/utils/resources/assets_manager.dart';
import 'package:lol/core/utils/resources/colors_manager.dart';
import 'package:lol/core/utils/resources/constants_manager.dart';
import 'package:lol/core/utils/resources/strings_manager.dart';
import 'package:lol/core/utils/resources/values_manager.dart';
import 'package:lol/features/admin/presentation/view/announcements/announcement_detail.dart';
import 'package:lol/features/admin/presentation/view/announcements/announcements_list.dart';
import 'package:lol/features/admin/presentation/view_model/admin_cubit/admin_cubit.dart';
import 'package:lol/features/admin/presentation/view_model/admin_cubit/admin_cubit_states.dart';
import 'package:lol/main.dart';

class BuildAnnouncementsRow extends StatelessWidget {
  const BuildAnnouncementsRow({
    super.key,
    required this.announcements,
  });

  final List<AnnouncementModel> announcements;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: announcements.isEmpty
          ? [
              GestureDetector(
                onDoubleTap: () {
                  if (MainCubit.get(context).profileModel?.role ==
                          KeysManager.admin &&
                      changeSemester!) {
                    MainCubit.get(context).updateSemester4all();
                    changeSemester = false;
                  }
                },
                onTap: () {
                  navigate(
                      context,
                      AnnouncementsList(
                          semester:
                              MainCubit.get(context).profileModel!.semester));
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSizesDouble.s15),
                  ),
                  child: Image.asset(
                      height: AppSizesDouble.s600,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      AssetsManager.noAnnouncements),
                ),
              )
            ]
          : announcements.map((announc) {
              return GestureDetector(
                onTap: () {
                  navigate(
                      context,
                      AnnouncementDetail(
                        title: announc.title,
                        date: announc.dueDate,
                        description: announc.content,
                        semester: AppConstants.TOKEN != null
                            ? MainCubit.get(context).profileModel!.semester
                            : AppConstants.SelectedSemester!,
                      ));
                },
                onDoubleTap: () {
                  if (MainCubit.get(context).profileModel?.role ==
                          KeysManager.admin &&
                      changeSemester!) {
                    MainCubit.get(context).updateSemester4all();
                    changeSemester = false;
                  }
                },
                child: Stack(alignment: Alignment.bottomCenter, children: [
                  Container(
                    margin: EdgeInsets.only(top: AppMargins.m5),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSizesDouble.s15),
                    ),
                    child: Image.network(
                      announc.image,
                      width: AppSizesDouble.s400,
                      height: AppSizesDouble.s250,
                      fit: BoxFit.cover,
                    ),
                  ), //image
                  Container(
                    width: double.infinity,
                    height: double.infinity, // Adjust height as needed
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.transparent,
                            Colors.transparent,
                            Colors.black.withValues(alpha: AppSizesDouble.s0_3),
                            Colors.black.withValues(alpha: AppSizesDouble.s0_6),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius:
                            BorderRadius.circular(AppSizesDouble.s15)),
                  ), //gradient
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: AppMargins.m20, horizontal: AppMargins.m15),
                      child: Stack(children: [
                        Text(
                          announc.title,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = AppSizesDouble.s1_8
                                    ..color = ColorsManager.black),
                          textAlign: TextAlign.center,
                          maxLines: AppSizes.s1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          announc.title,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                color: ColorsManager.white,
                              ),
                          textAlign: TextAlign.center,
                          maxLines: AppSizes.s1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ]),
                    ),
                  ), //title
                ]),
              );
            }).toList(),
      options: CarouselOptions(
        height: AppSizesDouble.s200,
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: AppSizes.s16 / AppSizes.s9,
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: announcements.length < AppSizes.s5 ? false : true,
        autoPlayInterval: const Duration(seconds: AppSizes.s5),
        autoPlayAnimationDuration: const Duration(milliseconds: AppSizes.s800),
        viewportFraction:
            announcements.isEmpty ? AppSizesDouble.s1 : AppSizesDouble.s0_8,
      ),
    );
  }
}
