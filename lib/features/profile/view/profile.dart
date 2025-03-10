import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
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
import 'package:lol/main.dart';
import 'package:lol/core/utils/components.dart';
import 'package:lol/core/widgets/default_button.dart';
import 'package:lol/core/widgets/default_text_field.dart';
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
        if(mainCubit.leaderboardModel == null) {
          mainCubit.getLeaderboard(mainCubit.profileModel!.semester);
        }
        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                onPressed: (){},
                icon: Icon(IconsManager.editPenIcon)
              )
              // TextButton(
              //   style: TextButton.styleFrom(
              //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              //     padding: EdgeInsets.zero,
              //     foregroundColor: Colors.blue
              //   ),
              //   onPressed: () async {
              //     await MainCubit.get(context).uploadPImage(
              //       image: MainCubit.get(context).userImageFile,
              //     );
              //
              //     MainCubit.get(context).updateUser(
              //         userID: MainCubit.get(context).profileModel!.id,
              //         photo: MainCubit.get(context).userImagePath);
              //   },
              //   child: Container(
              //     margin: EdgeInsets.only(right: 10),
              //     child: Text(
              //       "Submit",
              //       style: TextStyle(fontSize: 17),
              //     ),
              //   )
              // ),
            ],
            title: Text(StringsManager.profile, style: Theme.of(context).textTheme.displayMedium,),
            centerTitle: true,
          ),
          body: Padding(
            padding: EdgeInsets.only(bottom: AppPaddings.p10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: AppQueries.screenWidth(context) / AppSizesDouble.s3_2,
                          child: CircleAvatar(
                            radius: AppQueries.screenWidth(context) / AppSizesDouble.s8_5,
                            backgroundImage: mainCubit.userImageFile != null ?
                            NetworkImage(AppConstants.defaultProfileImage) :
                            NetworkImage(mainCubit.profileModel!.photo!,),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: AppQueries.screenWidth(context) / AppSizesDouble.s1_7),
                              child: Text(
                                mainCubit.profileModel!.name,
                                style: Theme.of(context).textTheme.displayLarge!.copyWith( fontSize: AppQueries.screenWidth(context) / AppSizes.s15),
                                maxLines: AppSizes.s2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: AppSizesDouble.s4,),
                            SizedBox(
                              width: AppQueries.screenWidth(context) / AppSizesDouble.s2_5,
                              child: Text(
                                mainCubit.profileModel!.email,
                                style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: AppQueries.screenWidth(context) / AppSizes.s25),
                                maxLines: AppSizes.s2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // if (mainCubit.profileModel?.phone != null &&
                            //     mainCubit
                            //         .profileModel!.phone!.isNotEmpty)
                            //   SizedBox(
                            //     width: AppQueries.screenWidth(context) / 2.5,
                            //     child: Text(
                            //       mainCubit.profileModel!.phone.toString(),
                            //       style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontSize: AppQueries.screenWidth(context) / 25),
                            //       maxLines: 2,
                            //     ),
                            //   ),
                            ConditionalBuilder(
                              condition: mainCubit.leaderboardModel != null && mainCubit.score4User != null && state is !GetLeaderboardLoadingState,
                              builder: (context) {
                                mainCubit.getScore4User(mainCubit.profileModel!.id);
                                return Row(
                                children: [
                                  Text('Score: ', style: Theme.of(context).textTheme.titleSmall,),
                                  Text(mainCubit.score4User!.score.toString(), style: Theme.of(context).textTheme.titleLarge,),
                                ],
                              );
                              },
                              fallback: (context) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: AppSizesDouble.s50,
                      child: Center(child: Text(StringsManager.myUploads, style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: AppQueries.screenWidth(context) / AppSizes.s18)),),
                    ),
                    divider(),
                  ],
                ),
                Expanded(
                  child: ConditionalBuilder(
                    condition: mainCubit.profileModel!.materials.isNotEmpty && state is! GetRequestsLoadingState,
                    builder: (context) => Padding(
                      padding: EdgeInsets.symmetric(vertical: AppPaddings.p15, horizontal: AppPaddings.p10),
                      child: ListView.separated(
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return materialBuilder(
                            index,
                            context,
                            title: mainCubit.profileModel!.materials[index].title,
                            description: mainCubit.profileModel!.materials[index].description,
                            type: mainCubit.profileModel!.materials[index].type,
                            link: mainCubit.profileModel!.materials[index].link,
                            subjectName: mainCubit.profileModel!.materials[index].subject,
                          );
                        },
                        separatorBuilder: (context, index) => SizedBox(height: AppSizesDouble.s10,),
                        itemCount: mainCubit.profileModel!.materials.length
                      ),
                    ),
                    fallback: (context) {
                      if (state is GetRequestsLoadingState) {
                        return SizedBox(
                          height: AppQueries.screenHeight(context) / AppSizesDouble.s1_3,
                          child: Center(child: CircularProgressIndicator(),)
                        );
                      }
                      return SizedBox(
                        height: AppQueries.screenHeight(context) / AppSizesDouble.s1_3,
                        child: Center(
                          child: Text(
                            StringsManager.noContributionsYet,
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontSize: AppQueries.screenWidth(context) / AppSizes.s12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      );
                    }
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

