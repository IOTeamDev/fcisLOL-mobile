import 'dart:math';
import 'dart:developer' as dev;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:googleapis/playintegrity/v1.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:linkify/linkify.dart';
import 'package:lol/core/presentation/cubits/main_cubit/main_cubit.dart';
import 'package:lol/core/presentation/cubits/main_cubit/main_cubit_states.dart';
import 'package:lol/core/presentation/screen_size.dart';
import 'package:lol/core/resources/theme/colors_manager.dart';
import 'package:lol/core/presentation/app_icons.dart';
import 'package:lol/core/resources/theme/values/app_strings.dart';
import 'package:lol/core/resources/theme/theme_provider.dart';
import 'package:lol/main.dart';
import 'package:lol/features/admin/presentation/view_model/admin_cubit/admin_cubit.dart';
import 'package:lol/features/admin/presentation/view_model/admin_cubit/admin_cubit_states.dart';
import 'package:lol/features/admin/presentation/view/announcements/announcement_detail.dart';
import 'package:lol/features/admin/presentation/view/requests/requests_details.dart';
import 'package:lol/core/utils/components.dart';
import 'package:lol/core/utils/navigation.dart';
import 'package:provider/provider.dart';
import '../../../../../core/resources/constants/constants_manager.dart';
import '../../../../../core/resources/theme/values/values_manager.dart';
import '../../../../subject/data/models/material_model.dart';

class Requests extends StatefulWidget {
  const Requests({super.key});
  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var cubit = MainCubit.get(context);
    if (cubit.profileModel!.role == KeysManager.developer &&
        cubit.allRequests.isEmpty) {
      cubit.getAllSemestersRequests();
    } else if (cubit.requests == null) {
      cubit.getRequests(semester: cubit.profileModel!.semester);
    }

    return BlocConsumer<MainCubit, MainState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Text(
              AppStrings.requests,
              style: Theme.of(context).textTheme.displayMedium,
            ),
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: () {
                    if (cubit.profileModel!.role == KeysManager.developer) {
                      cubit.getAllSemestersRequests();
                    } else {
                      dev.log(cubit.profileModel!.semester);
                      cubit.getRequests(semester: cubit.profileModel!.semester);
                    }
                  },
                  icon: Icon(AppIcons.refreshIcon))
            ],
          ),
          body: Padding(
            padding: EdgeInsets.only(top: AppPaddings.p20),
            child: Column(
              children: [
                ConditionalBuilder(
                  condition: cubit.profileModel!.role == KeysManager.developer
                      ? (cubit.allRequests.isNotEmpty &&
                          state is! GetRequestsLoadingState)
                      : (cubit.requests!.isNotEmpty &&
                          state is! GetRequestsLoadingState),
                  fallback: (context) {
                    if (state is GetRequestsLoadingState) {
                      return Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    return Expanded(
                      child: Center(
                          child: Text(
                        AppStrings.noRequests,
                        style: Theme.of(context).textTheme.headlineMedium,
                      )),
                    );
                  },
                  builder: (context) {
                    List<MaterialModel> requests = cubit.allRequests.isEmpty
                        ? cubit.requests!
                        : cubit.allRequests;
                    dev.log(requests[0].id.toString());
                    return Expanded(
                      child: ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return _requestedMaterialBuilder(
                              index, context, requests[index],
                              semester: cubit.profileModel!.semester);
                        },
                        separatorBuilder: (context, index) => const Padding(
                          padding: EdgeInsetsDirectional.all(AppPaddings.p5),
                        ),
                        itemCount: requests.length,
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _requestedMaterialBuilder(index, context, MaterialModel request,
      {semester}) {
    dev.log(request.id.toString());
    return InkWell(
      onTap: () async {
        String? refresh = await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => RequestsDetails(
                  authorName: request.author!.authorName!,
                  type: request.type!,
                  description: request.description!,
                  link: request.link!,
                  subjectName: request.subject!,
                  id: index,
                  title: request.title!,
                  pfp: request.author!.authorPhoto!,
                  semester: semester,
                )));
        if (refresh == AppStrings.refresh) onRefresh(context);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(AppSizesDouble.s20),
        ),
        margin:
            const EdgeInsetsDirectional.symmetric(horizontal: AppMargins.m10),
        padding:
            const EdgeInsetsDirectional.symmetric(horizontal: AppPaddings.p10),
        height: AppSizesDouble.s170,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.only(
                  bottom: AppPaddings.p5,
                  top: AppPaddings.p10,
                  start: AppPaddings.p10,
                  end: AppPaddings.p10),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage:
                        NetworkImage(request.author!.authorPhoto.toString()),
                    radius: AppSizesDouble.s17,
                  ),
                  const SizedBox(width: AppSizesDouble.s10),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth:
                            ScreenSize.width(context) / AppSizesDouble.s3),
                    child: Text(
                      request.author!.authorName!,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: ColorsManager.grey3),
                      maxLines: AppSizes.s1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Spacer(),
                  ConstrainedBox(
                    constraints:
                        const BoxConstraints(maxWidth: AppSizesDouble.s130),
                    child: Text(
                      request.subject
                          .toString()
                          .replaceAll(AppStrings.underScore, AppStrings.space),
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(color: ColorsManager.grey3),
                      maxLines: AppSizes.s1,
                      overflow: TextOverflow.ellipsis,
                      textWidthBasis: TextWidthBasis.longestLine,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(
                  start: AppPaddings.p10,
                  end: AppPaddings.p10,
                  top: AppPaddings.p0,
                  bottom: AppPaddings.p5),
              child: Text(
                request.title!,
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      color: Colors.white,
                    ),
                maxLines: AppSizes.s1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding:
                  EdgeInsetsDirectional.symmetric(horizontal: AppPaddings.p10),
              child: Text(
                request.type!,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: ColorsManager.grey3),
                maxLines: AppSizes.s1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                return Row(
                  children: [
                    Icon(AppIcons.linkIcon,
                        color: Provider.of<ThemeProvider>(context).isDark
                            ? ColorsManager.dodgerBlue
                            : ColorsManager.lightGrey1),
                    const SizedBox(width: AppSizesDouble.s5),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                          maxWidth: constraints.maxWidth - AppSizes.s140),
                      child: GestureDetector(
                        onTap: () async {
                          final linkElement =
                              LinkableElement(request.link, request.link!);
                          await onOpen(context, linkElement);
                        },
                        child: Text(
                          request.link!,
                          style: TextStyle(
                            color: Provider.of<ThemeProvider>(context).isDark
                                ? ColorsManager.dodgerBlue
                                : ColorsManager.lightGrey1,
                            decoration: TextDecoration.underline,
                            decorationColor:
                                Provider.of<ThemeProvider>(context).isDark
                                    ? ColorsManager.dodgerBlue
                                    : ColorsManager.lightGrey1,
                          ),
                          maxLines: AppSizes.s1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const Spacer(),
                    MaterialButton(
                      onPressed: () {
                        MainCubit.get(context).acceptRequest(
                            request.id!,
                            semester,
                            MainCubit.get(context).profileModel!.role);
                      },
                      color: ColorsManager.green,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppSizesDouble.s10)),
                      minWidth: AppSizesDouble.s0,
                      padding: const EdgeInsets.all(AppPaddings.p8),
                      child: const Icon(AppIcons.checkIcon,
                          color: ColorsManager.white),
                    ),
                    MaterialButton(
                      onPressed: () {
                        AwesomeDialog(
                          context: context,
                          title: AppStrings.delete,
                          dialogType: DialogType.warning,
                          body: Text(
                            AppStrings.deleteRequestMessage,
                            style: Theme.of(context).textTheme.titleLarge!,
                            textAlign: TextAlign.center,
                          ),
                          barrierColor: ColorsManager.black
                              .withValues(alpha: AppSizesDouble.s0_6),
                          dismissOnTouchOutside: true,
                          animType: AnimType.scale,
                          btnOk: ElevatedButton(
                              onPressed: () {
                                MainCubit.get(context).deleteMaterial(
                                  request.id!,
                                  role:
                                      MainCubit.get(context).profileModel!.role,
                                  semester,
                                );
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    ColorsManager.imperialRed, // Red background
                              ),
                              child: Text(
                                AppStrings.delete,
                                style: TextStyle(color: ColorsManager.white),
                              )),
                          btnCancel: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  ColorsManager.grey4, // Grey background
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              AppStrings.cancel, // Use cancel text if defined
                              style: const TextStyle(
                                  color: Colors.black), // Black text
                            ),
                          ),
                        ).show();
                      },
                      color: ColorsManager.imperialRed,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppSizesDouble.s10)),
                      minWidth: AppSizesDouble.s0,
                      padding: EdgeInsets.all(AppPaddings.p8),
                      child: const Icon(AppIcons.closeIcon,
                          color: ColorsManager.white),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
