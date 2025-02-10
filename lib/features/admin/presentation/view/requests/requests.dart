import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:googleapis/playintegrity/v1.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:linkify/linkify.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit_states.dart';
import 'package:lol/core/utils/resources/colors_manager.dart';
import 'package:lol/core/utils/resources/icons_manager.dart';
import 'package:lol/core/utils/resources/strings_manager.dart';
import 'package:lol/main.dart';
import 'package:lol/features/admin/presentation/view_model/admin_cubit/admin_cubit.dart';
import 'package:lol/features/admin/presentation/view_model/admin_cubit/admin_cubit_states.dart';
import 'package:lol/features/admin/presentation/view/announcements/announcement_detail.dart';
import 'package:lol/features/admin/presentation/view/requests/requests_details.dart';
import 'package:lol/core/utils/components.dart';
import 'package:lol/core/utils/navigation.dart';
import '../../../../../core/utils/resources/constants_manager.dart';
import '../../../../../core/utils/resources/values_manager.dart';

class Requests extends StatefulWidget {
  const Requests({super.key});
  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainCubitStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = MainCubit.get(context);
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Text(
              StringsManager.requests,
              style: Theme.of(context).textTheme.displayMedium,
            ),
            centerTitle: true,
            actions: [
              IconButton(onPressed: () => onRefresh(context), icon: Icon(IconsManager.refreshIcon))
            ],
          ),
          body: Padding(
            padding: EdgeInsets.only(top: AppPaddings.p20),
            child: Column(
              children: [
                ConditionalBuilder(
                  condition: cubit.requests != null && cubit.requests!.isNotEmpty && state is !GetRequestsLoadingState,
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
                          StringsManager.noRequests,
                          style: Theme.of(context).textTheme.headlineMedium,
                        )
                      ),
                    );
                  },
                  builder: (context) => Expanded(
                    child: RefreshIndicator(
                      onRefresh: () => onRefresh(context),
                      child: ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index) => _requestedMaterialBuilder(
                          index,
                          context,
                          title: cubit.requests![index].title,
                          type: cubit.requests![index].type,
                          authorName: cubit.requests![index].author?.authorName,
                          pfp: cubit.requests![index].author?.authorPhoto,
                          link: cubit.requests![index].link,
                          subjectName: cubit.requests![index].subject,
                          description: cubit.requests![index].description,
                          semester: cubit.profileModel!.semester
                        ),
                        separatorBuilder: (context, index) => const Padding(
                          padding: EdgeInsetsDirectional.all(AppPaddings.p5),
                        ),
                        itemCount: cubit.requests!.length,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _requestedMaterialBuilder(index, context,
    {title,
    link,
    type,
    authorName,
    pfp,
    subjectName,
    description,
    semester}) {
    return InkWell(
      onTap: () async {
        String? refresh = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => RequestsDetails(
              authorName: authorName,
              type: type,
              description: description,
              link: link,
              subjectName: subjectName,
              id: index,
              title: title,
              pfp: pfp,
              semester: semester,
            )
          )
        );
        if (refresh == StringsManager.refresh) onRefresh(context);
      },
      child: Container(
        decoration: BoxDecoration(
          color: MainCubit.get(context).isDark
            ? ColorsManager.darkPrimary
            : ColorsManager.lightPrimary,
          borderRadius: BorderRadius.circular(AppSizesDouble.s20),
        ),
        margin: const EdgeInsetsDirectional.symmetric(horizontal: AppMargins.m10),
        padding: const EdgeInsetsDirectional.symmetric(horizontal: AppPaddings.p10),
        height: AppSizesDouble.s170,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.only(bottom: AppPaddings.p5, top: AppPaddings.p10, start: AppPaddings.p10, end: AppPaddings.p10),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(pfp.toString()),
                    radius: AppSizesDouble.s17,
                  ),
                  const SizedBox(width: AppSizesDouble.s10),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: AppQueries.screenWidth(context) / AppSizesDouble.s3),
                    child: Text(
                      authorName,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(color: ColorsManager.grey3),
                      maxLines: AppSizes.s1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Spacer(),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: AppSizesDouble.s130),
                    child: Text(
                      subjectName.toString().replaceAll(StringsManager.underScore, StringsManager.space),
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(color: ColorsManager.grey3),
                      maxLines: AppSizes.s1,
                      overflow: TextOverflow.ellipsis,
                      textWidthBasis: TextWidthBasis.longestLine,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(start: AppPaddings.p10, end: AppPaddings.p10, top: AppPaddings.p0, bottom: AppPaddings.p5),
              child: Text(
                title,
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(color: Colors.white,),
                maxLines: AppSizes.s1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding:  EdgeInsetsDirectional.symmetric(horizontal: AppPaddings.p10),
              child: Text(
                type,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: ColorsManager.grey3),
                maxLines: AppSizes.s1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                return Row(
                  children: [
                    Icon(IconsManager.linkIcon, color: MainCubit.get(context).isDark? ColorsManager.dodgerBlue : ColorsManager.lightGrey1),
                    const SizedBox(width: AppSizesDouble.s5),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: constraints.maxWidth - AppSizes.s140),
                      child: GestureDetector(
                        onTap: () async {
                          final linkElement = LinkableElement(link, link);
                          await onOpen(context, linkElement);
                        },
                        child: Text(
                          link,
                          style: TextStyle(
                            color: MainCubit.get(context).isDark? ColorsManager.dodgerBlue : ColorsManager.lightGrey1,
                            decoration: TextDecoration.underline,
                            decorationColor: MainCubit.get(context).isDark? ColorsManager.dodgerBlue : ColorsManager.lightGrey1,
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
                          MainCubit.get(context).requests![index].id!,
                          MainCubit.get(context).profileModel!.semester
                        );
                      },
                      color: ColorsManager.green,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizesDouble.s10)),
                      minWidth: AppSizesDouble.s0,
                      padding: const EdgeInsets.all(AppPaddings.p8),
                      child: const Icon(IconsManager.checkIcon, color: ColorsManager.white),
                    ),
                    MaterialButton(
                      onPressed: () {
                        AwesomeDialog(
                          context: context,
                          title: StringsManager.delete,
                          dialogType: DialogType.warning,
                          body: Text(
                            StringsManager.deleteRequestMessage,
                            style: Theme.of(context).textTheme.titleLarge!.copyWith(color: ColorsManager.black),
                            textAlign: TextAlign.center,
                          ),
                          animType: AnimType.scale,
                          btnOkColor: ColorsManager.imperialRed,
                          btnCancelOnPress: () {},
                          btnOkText: StringsManager.delete,
                          btnCancelColor: ColorsManager.grey4,

                          btnOkOnPress: () {
                            MainCubit.get(context).deleteMaterial(
                              MainCubit.get(context).requests![index].id!,
                              MainCubit.get(context).profileModel!.semester,
                            );
                          },
                        ).show();
                      },
                      color: ColorsManager.imperialRed,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizesDouble.s10)),
                      minWidth: AppSizesDouble.s0,
                      padding: EdgeInsets.all(AppPaddings.p8),
                      child: const Icon(IconsManager.closeIcon, color: ColorsManager.white),
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
