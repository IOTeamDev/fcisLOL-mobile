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
                icon: Icon(CupertinoIcons.square_pencil)
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
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: AppQueries.screenWidth(context) / 3.2,
                          child: CircleAvatar(
                            radius: AppQueries.screenWidth(context) / 8.5,
                            backgroundImage: MainCubit.get(context).userImageFile != null ?
                            NetworkImage(AppConstants.defaultProfileImage) :
                            NetworkImage(mainCubit.profileModel!.photo!,),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: AppQueries.screenWidth(context) / 1.7),
                              child: Text(
                                mainCubit.profileModel!.name,
                                style: Theme.of(context).textTheme.displayLarge!.copyWith( fontSize: AppQueries.screenWidth(context) / 15),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 4,),
                            SizedBox(
                              width: AppQueries.screenWidth(context) / 2.5,
                              child: Text(
                                mainCubit.profileModel!.email,
                                style: TextStyle(
                                  color: Provider.of<ThemeProvider>(context).isDark ? Colors.white : Colors.black,
                                  fontSize: AppQueries.screenWidth(context) / 25),
                                maxLines: 2,
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
                              condition: MainCubit.get(context).leaderboardModel != null && MainCubit.get(context).score4User != null && state is !GetLeaderboardLoadingState,
                              builder: (context) {
                                MainCubit.get(context).getScore4User(MainCubit.get(context).profileModel!.id);
                                return Row(
                                children: [
                                  Text('Score: ', style: Theme.of(context).textTheme.titleSmall,),
                                  Text(MainCubit.get(context).score4User!.score.toString(), style: Theme.of(context).textTheme.titleLarge,),
                                ],
                              );
                              },
                              fallback: (context) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: Provider.of<ThemeProvider>(context).isDark ? ColorsManager.white : ColorsManager.black,
                                  ),
                                );
                              }
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 15,),
                    Center(child: Text("My Uploads", style: TextStyle(fontSize: AppQueries.screenWidth(context) / 18),)),
                    SizedBox(height: 10,),
                    Divider(
                      color: Provider.of<ThemeProvider>(context).isDark ? ColorsManager.white : ColorsManager.black,
                      height: 0,
                    ),
                  ],
                ),
                Expanded(
                  child: ConditionalBuilder(
                    condition: MainCubit.get(context).profileModel!.materials.isNotEmpty && state is! GetRequestsLoadingState,
                    builder: (context) => Padding(
                      padding: EdgeInsets.symmetric(vertical: AppPaddings.p15, horizontal: AppPaddings.p10),
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.separated(
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                var mainCubit = MainCubit.get(context);
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
                              separatorBuilder: (context, index) => SizedBox(height: 10,),
                              itemCount: mainCubit.profileModel!.materials.length
                            ),
                          ),
                        ],
                      ),
                    ),
                    fallback: (context) {
                      if (state is GetRequestsLoadingState) {
                        return SizedBox(
                          height: AppQueries.screenHeight(context) / 1.3,
                          child: Center(child: CircularProgressIndicator(),)
                        );
                      }
                      return SizedBox(
                        height: AppQueries.screenHeight(context) / 1.3,
                        child: Center(
                          child: Text(
                            'You Have No Contributions Yet!!!',
                            style: TextStyle(fontSize: AppQueries.screenWidth(context) / 12),
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

Widget materialBuilder(index, context, {title, link, type, subjectName, description}) {
  return Container(
    padding: EdgeInsets.all(5),
    decoration: BoxDecoration(
      color: Provider.of<ThemeProvider>(context).isDark ?
      HexColor('#3B3B3B') :
      Color.fromARGB(255, 20, 130, 220),
      borderRadius: BorderRadius.circular(20),
    ),
    height: 170,
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '$title ',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              // const Spacer(),
              if (MainCubit.get(context).profileModel!.role == 'ADMIN'||MainCubit.get(context).profileModel!.role =="DEV")
                MaterialButton(
                  onPressed: () {
                    AwesomeDialog(
                      context: context,
                      title: "Delete",
                      dialogType: DialogType.warning,
                      body: Text(
                        "Are you sure you want to Delete the Material?",
                        style: TextStyle(fontSize: 17),
                      ),
                      animType: AnimType.rightSlide,
                      btnOkColor: Colors.red,
                      btnCancelOnPress: () {},
                      btnOkText: "Delete",
                      btnCancelColor: Colors.grey,

                      // titleTextStyle: TextStyle(fontSize: 22),
                      btnOkOnPress: () {
                        print(MainCubit.get(context)
                            .profileModel!
                            .materials[index]
                            .id!);
                        print(MainCubit.get(context).profileModel!.semester);
                        MainCubit.get(context).deleteMaterial(
                          MainCubit.get(context)
                              .profileModel!
                              .materials[index]
                              .id!,
                          MainCubit.get(context).profileModel!.semester,
                          isMaterial: true,
                        );
                      },
                    ).show();
                  },
                  shape: RoundedRectangleBorder(),
                  minWidth: 0,
                  padding: EdgeInsets.zero,
                  child: const Icon(Icons.close, color: Colors.red),
                ),
            ],
          ),
          Flexible(
            child: Text(
              textAlign: TextAlign.start,
              subjectName
                  .toString()
                  .replaceAll('_', ' ')
                  .replaceAll('And', '&'),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: AppQueries.screenWidth(context) / 17,
                  color: ColorsManager.white),
            ),
          ),
          // SizedBox(height: 5,),
          Text(
            type,
            style: TextStyle(fontSize: 13, color: Colors.grey[300]),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                children: [
                  Icon(Icons.link, color: HexColor('#B7B7B7')),
                  const SizedBox(width: 5),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final linkElement = LinkableElement(link, link);
                        await onOpen(context, linkElement);
                      },
                      child: Text(
                        link,
                        style: TextStyle(
                          color: Colors.lightBlueAccent,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.lightBlueAccent,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  // Spacer(),
                  Text(
                    MainCubit.get(context)
                            .profileModel!
                            .materials[index]
                            .accepted!
                        ? 'Accepted'
                        : 'Pending',
                    style: TextStyle(
                        color: MainCubit.get(context)
                                .profileModel!
                                .materials[index]
                                .accepted!
                            ? Colors.greenAccent
                            : Colors.amber),
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
