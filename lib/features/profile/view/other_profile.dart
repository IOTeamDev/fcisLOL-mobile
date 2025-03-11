import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:googleapis/games/v1.dart';
import 'package:googleapis/mybusinessaccountmanagement/v1.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:linkify/linkify.dart';
import 'package:lol/core/utils/resources/strings_manager.dart';
import 'package:lol/core/utils/resources/theme_provider.dart';
import 'package:lol/core/utils/resources/values_manager.dart';
import 'package:lol/features/admin/presentation/view_model/admin_cubit/admin_cubit.dart';
import 'package:lol/features/home/data/models/semster_model.dart';
import 'package:lol/main.dart';
import 'package:lol/core/models/profile/profile_materila_model.dart';
import 'package:lol/core/utils/components.dart';
import 'package:lol/core/widgets/default_button.dart';
import 'package:lol/core/widgets/default_text_field.dart';
import 'package:lol/core/utils/resources/constants_manager.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit_states.dart';
import 'package:lol/features/home/presentation/view/home.dart';
import 'package:lol/core/utils/navigation.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/resources/colors_manager.dart';

bool refreshing = false;

class OtherProfile extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final id;
  const OtherProfile({super.key, this.id});

  @override
  State<OtherProfile> createState() => _OtherProfileState();
}

class _OtherProfileState extends State<OtherProfile> {
 
 @override
  void initState() {
      MainCubit.get(context).getOtherProfile(widget.id);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainCubitStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var mainCubit = MainCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: mainCubit.otherProfile == null ? Text("") : Text(
              mainCubit.otherProfile!.name,
              style: Theme.of(context).textTheme.displayLarge!.copyWith(fontSize: AppQueries.screenWidth(context) / AppSizes.s15),
              maxLines: AppSizes.s2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
          body: mainCubit.otherProfile == null ?
          const Center(child: CircularProgressIndicator(),) :
          Padding(
            padding: EdgeInsets.symmetric(vertical: AppPaddings.p10),
            child: Column(
              children: [
                CircleAvatar(
                  radius: AppQueries.screenWidth(context) / AppSizesDouble.s7_5,
                  backgroundImage: NetworkImage(mainCubit.otherProfile!.photo!,),
                ),
                SizedBox(height: AppSizesDouble.s10,),
                Text(
                  mainCubit.otherProfile!.email,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: AppQueries.screenWidth(context) / AppSizes.s25),
                  maxLines: AppSizes.s2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppSizesDouble.s4,),
                Text(
                  '${StringsManager.level} ${((semsesterIndex(mainCubit.otherProfile!.semester)/AppSizes.s2) + AppSizes.s1).floor()}',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: AppQueries.screenWidth(context) / AppSizes.s25),
                  maxLines: AppSizes.s2,
                  overflow: TextOverflow.ellipsis,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizesDouble.s30)),
                        color: ColorsManager.darkPrimary.withValues(alpha: 0.4)
                    ),
                    padding: EdgeInsets.symmetric(vertical: AppPaddings.p20, horizontal: AppPaddings.p10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          StringsManager.uploads,
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: AppQueries.screenWidth(context) / AppSizes.s18)
                        ),
                        divider(height: AppSizesDouble.s20),
                        Expanded(
                          child: ConditionalBuilder(
                            condition: mainCubit.otherProfile!.materials.isNotEmpty && state is! GetRequestsLoadingState,
                            builder: (context) => ListView.separated(
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return materialBuilder(
                                  index,
                                  context,
                                  title: mainCubit
                                      .otherProfile!
                                      .materials[index]
                                      .title,
                                  description: mainCubit
                                      .otherProfile!
                                      .materials[index]
                                      .description,
                                  type: mainCubit
                                      .otherProfile!
                                      .materials[index]
                                      .type,
                                  link: mainCubit
                                      .otherProfile!
                                      .materials[index]
                                      .link,
                                  subjectName: mainCubit
                                      .otherProfile!
                                      .materials[index]
                                      .subject,
                                );
                              },
                              separatorBuilder: (context, index) => SizedBox(height: AppSizesDouble.s10,),
                              itemCount: mainCubit.otherProfile!.materials.length
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
    );
  }
}

