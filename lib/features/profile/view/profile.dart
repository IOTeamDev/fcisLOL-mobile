import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:googleapis/games/v1.dart';
import 'package:googleapis/mybusinessaccountmanagement/v1.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:linkify/linkify.dart';
import 'package:lol/core/utils/resources/icons_manager.dart';
import 'package:lol/core/utils/resources/strings_manager.dart';
import 'package:lol/core/utils/resources/theme_provider.dart';
import 'package:lol/core/utils/resources/values_manager.dart';
import 'package:lol/features/profile/view/edit_profile_screen.dart';
import 'package:lol/main.dart';
import 'package:lol/core/utils/components.dart';
import 'package:lol/core/utils/resources/constants_manager.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit_states.dart';
import 'package:lol/features/home/presentation/view/home.dart';
import 'package:lol/core/utils/navigation.dart';
import 'package:lol/core/utils/resources/colors_manager.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainCubitStates>(
      builder: (context, state) {
        var mainCubit = MainCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            actions: [
              // ElevatedButton.icon(
              //   label: Text(
              //     'Delete',
              //     style: Theme.of(context)
              //         .textTheme
              //         .titleSmall!
              //         .copyWith(color: ColorsManager.black),
              //   ),
              //   icon: Icon(IconsManager.deleteIcon),
              //   style: ButtonStyle(
              //     backgroundColor: WidgetStateProperty.resolveWith(
              //       (states) {
              //         return ColorsManager.white;
              //       },
              //     ),
              //     iconColor: WidgetStateProperty.resolveWith(
              //       (states) {
              //         return ColorsManager.black;
              //       },
              //     ),
              //   ),
              //   onPressed: () {
              //     AwesomeDialog(
              //       context: context,
              //       title: StringsManager.delete,
              //       dialogType: DialogType.warning,
              //       body: Text(
              //         textAlign: TextAlign.center,
              //         'If you press "Delete", your Uninotes account will be deleted forever',
              //         style: Theme.of(context).textTheme.titleLarge,
              //       ),
              //       animType: AnimType.scale,
              //       btnOk: ElevatedButton(
              //         onPressed: () {
              //           context.read<MainCubit>().deleteAccount(
              //               id: context.read<MainCubit>().profileModel!.id);
              //         },
              //         style: ElevatedButton.styleFrom(
              //             backgroundColor: ColorsManager.imperialRed),
              //         child: Text(
              //           StringsManager.delete,
              //           style: Theme.of(context)
              //               .textTheme
              //               .bodyMedium!
              //               .copyWith(color: ColorsManager.white),
              //         ),
              //       ),
              //       btnCancel: ElevatedButton(
              //           onPressed: () => Navigator.of(context).pop(),
              //           style: ElevatedButton.styleFrom(
              //               backgroundColor: ColorsManager.grey4),
              //           child: Text(
              //             StringsManager.cancel,
              //             style: Theme.of(context)
              //                 .textTheme
              //                 .bodyMedium!
              //                 .copyWith(color: ColorsManager.black),
              //           )),
              //     ).show();
              //   },
              // )
              ElevatedButton.icon(
                label: Text('Edit', style: Theme.of(context).textTheme.titleSmall!.copyWith(color: ColorsManager.black),),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditProfileScreen())),
                icon: Icon(IconsManager.editIcon, color: ColorsManager.black,),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsManager.white
                ),
              )
            ],
            title: Text(
              StringsManager.profile,
              style: Theme.of(context).textTheme.displayMedium,
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: EdgeInsets.only(bottom: AppPaddings.p10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.bottomCenter,
                  children: [
                    CircleAvatar(
                      radius: AppSizesDouble.s50,
                      backgroundImage: mainCubit.userImageFile != null
                          ? NetworkImage(AppConstants.defaultProfileImage)
                          : NetworkImage(mainCubit.profileModel!.photo),
                    ),
                    Positioned(
                      bottom: AppSizesDouble.s10N, // Adjust position
                      child: IntrinsicWidth(
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: AppPaddings.p10),
                          height: AppSizesDouble.s25,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: ColorsManager.lightPrimary,
                            borderRadius:
                                BorderRadius.circular(AppSizesDouble.s20),
                          ),
                          child: Text(
                            mainCubit.profileModel!.score.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(color: ColorsManager.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: AppSizesDouble.s20,
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: AppQueries.screenWidth(context) /
                          AppSizesDouble.s1_2),
                  child: Text(
                    mainCubit.profileModel!.name,
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        fontSize:
                            AppQueries.screenWidth(context) / AppSizes.s13),
                    maxLines: AppSizes.s2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: AppSizesDouble.s4,
                ),
                Text(
                  mainCubit.profileModel!.email,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: AppQueries.screenWidth(context) / AppSizes.s22),
                  maxLines: AppSizes.s2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: AppSizesDouble.s4,
                ),
                Text(
                  "Phone: ${mainCubit.profileModel!.phone.isNotEmpty ? mainCubit.profileModel!.phone : 'No Phone Provided'}",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: AppQueries.screenWidth(context) / AppSizes.s22),
                  maxLines: AppSizes.s2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: AppSizesDouble.s25,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(AppSizesDouble.s40)),
                        color: Provider.of<ThemeProvider>(context).isDark
                            ? ColorsManager.grey5
                            : ColorsManager.grey7),
                    padding: EdgeInsets.symmetric(
                        vertical: AppPaddings.p20, horizontal: AppPaddings.p25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(StringsManager.myUploads,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  fontSize: AppQueries.screenWidth(context) /
                                      AppSizes.s18,
                                )),
                        divider(
                            height: AppSizesDouble.s20,
                            color: Provider.of<ThemeProvider>(context).isDark
                                ? ColorsManager.white
                                : ColorsManager.black),
                        Expanded(
                          child: ConditionalBuilder(
                              condition: mainCubit.profileModel!.materials.isNotEmpty &&
                                  state is! GetRequestsLoadingState,
                              builder: (context) => ListView.separated(
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return materialBuilder(
                                      index,
                                      context,
                                      profileModel: mainCubit.profileModel,
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                        height: AppSizesDouble.s10,
                                      ),
                                  itemCount:
                                      mainCubit.profileModel!.materials.length),
                              fallback: (context) {
                                if (state is GetRequestsLoadingState) {
                                  return SizedBox(
                                      height: AppQueries.screenHeight(context) /
                                          AppSizesDouble.s1_3,
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ));
                                }
                                return SizedBox(
                                    height: AppQueries.screenHeight(context) /
                                        AppSizesDouble.s1_3,
                                    child: Center(
                                      child: Text(
                                        StringsManager.noContributionsYet,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                              fontSize: AppQueries.screenWidth(
                                                      context) /
                                                  AppSizes.s12,
                                            ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ));
                              }),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
      listener: (context, state) {
        if (state is DeleteMaterialSuccessState) {
          MainCubit.get(context).getProfileInfo();
        }
      },
    );
  }
}
