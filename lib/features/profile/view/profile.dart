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
        return Scaffold(
          appBar: AppBar(
            actions: [
              // ElevatedButton(
              //   onPressed: (){},
              //   child: Row(
              //     children: [
              //       Icon(
              //         IconsManager.editIcon,
              //         color: Theme.of(context).iconTheme.color!.withValues(
              //           red: Theme.of(context).iconTheme.color!.r * -1,
              //           blue: Theme.of(context).iconTheme.color!.b * -1,
              //           green: Theme.of(context).iconTheme.color!.g * -1
              //         ),
              //       ),
              //       Text('Edit', style: Theme.of(context).textTheme.titleSmall,)
              //     ],
              //   ),
              // )
              //
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
                          padding: EdgeInsets.symmetric(horizontal: AppPaddings.p10),
                          height: AppSizesDouble.s25,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: ColorsManager.lightPrimary,
                            borderRadius: BorderRadius.circular(AppSizesDouble.s20),
                          ),
                          child: Text(
                            mainCubit.profileModel!.score.toString(),
                            style: Theme.of(context).textTheme.titleLarge!.copyWith(color: ColorsManager.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSizesDouble.s20,),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: AppQueries.screenWidth(context) / AppSizesDouble.s1_2),
                  child: Text(
                    mainCubit.profileModel!.name,
                    style: Theme.of(context).textTheme.displayLarge!.copyWith( fontSize: AppQueries.screenWidth(context) / AppSizes.s13),
                    maxLines: AppSizes.s2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: AppSizesDouble.s4,),
                Text(
                  mainCubit.profileModel!.email,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: AppQueries.screenWidth(context) / AppSizes.s22),
                  maxLines: AppSizes.s2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppSizesDouble.s4,),
                Text(
                  "Phone: ${mainCubit.profileModel!.phone.isNotEmpty? mainCubit.profileModel!.phone:'No Phone Provided'}",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: AppQueries.screenWidth(context) / AppSizes.s22),
                  maxLines: AppSizes.s2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppSizesDouble.s25,),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizesDouble.s40)),
                      color: Provider.of<ThemeProvider>(context).isDark? ColorsManager.grey5: ColorsManager.lightGrey1
                    ),
                    padding: EdgeInsets.symmetric(vertical: AppPaddings.p20, horizontal: AppPaddings.p25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(StringsManager.myUploads, style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: AppQueries.screenWidth(context) / AppSizes.s18,)),
                        divider(
                          height: AppSizesDouble.s20,
                          color: Provider.of<ThemeProvider>(context).isDark? ColorsManager.white: ColorsManager.black
                        ),
                        Expanded(
                          child: ConditionalBuilder(
                            condition: mainCubit.profileModel!.materials.isNotEmpty && state is! GetRequestsLoadingState,
                            builder: (context) => ListView.separated(
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

