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
import 'package:lol/main.dart';
import 'package:lol/models/profile/profile_materila_model.dart';
import 'package:lol/modules/subject/cubit/subject_cubit.dart';
import 'package:lol/shared/components/components.dart';
import 'package:lol/shared/components/default_button.dart';
import 'package:lol/shared/components/default_text_field.dart';
import 'package:lol/shared/styles/colors.dart';
import 'package:lol/shared/components/constants.dart';
import 'package:lol/layout/home/bloc/main_cubit.dart';
import 'package:lol/layout/home/bloc/main_cubit_states.dart';
import 'package:lol/layout/home/home.dart';
import 'package:lol/shared/components/navigation.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    var phoneController = TextEditingController();
    var nameController = TextEditingController();
    var emailController = TextEditingController();
    double height = screenHeight(context);
    double width = screenWidth(context);
    return BlocProvider(
      create: (context) => MainCubit()..getProfileInfo(),
      child: BlocConsumer<MainCubit, MainCubitStates>(
        builder: (context, state) {
          if (state is GetProfileSuccess) {
            BlocProvider.of<MainCubit>(context).getLeaderboard(MainCubit.get(context).profileModel!.semester);
          }
          var mainCubit = MainCubit.get(context);
          if (mainCubit.profileModel != null) {
            if (mainCubit.profileModel!.phone != null) {
              phoneController.text = mainCubit.profileModel!.phone!;
            }
            nameController.text = mainCubit.profileModel!.name;
            emailController.text = mainCubit.profileModel!.email;
          }
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              backgroundColor: isDark ? HexColor('#23252A') : Colors.white,
              body: mainCubit.profileModel == null
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 60,
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(bottom: 15.0),
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                child: backButton(context,),
                              ),
                              Center(
                                  child: Text(
                                    'Profile',
                                    style: TextStyle(
                                        fontSize: width / 11,),
                                    textAlign: TextAlign.center,
                                  )),
                            ],
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: screenWidth(context) / 3.2,
                              child: Align(
                                child: CircleAvatar(
                                  radius: width/7.5,
                                  backgroundImage: NetworkImage(
                                    mainCubit.profileModel!.photo,
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: screenWidth(context) / 1.8,
                                  child: Text(
                                    mainCubit.profileModel!.name,
                                    style: TextStyle(
                                        color: isDark
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: screenWidth(context) / 20),
                                    maxLines: 2,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Email: ',
                                      style: TextStyle(
                                          color: isDark
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize:
                                              screenWidth(context) / 20),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(
                                      width: screenWidth(context) / 2.5,
                                      child: Text(
                                        mainCubit.profileModel!.email,
                                        style: TextStyle(
                                            color: isDark
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize:
                                                screenWidth(context) / 25),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Phone: ',
                                      style: TextStyle(
                                          color: isDark
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize:
                                              screenWidth(context) / 20),
                                      maxLines: 2,
                                    ),
                                    SizedBox(
                                      width: screenWidth(context) / 2.5,
                                      child: Text(
                                        '${mainCubit.profileModel!.phone}',
                                        style: TextStyle(
                                            color: isDark
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize:
                                                screenWidth(context) / 25),
                                        maxLines: 2,
                                      ),
                                    )
                                  ],
                                ),
                                Builder(
                                  builder: (context) {
                                    if (MainCubit.get(context).leaderboardModel != null) {
                                      return Builder(builder: (context) {
                                        MainCubit.get(context).getScore4User(
                                            MainCubit.get(context).profileModel!.id);
                                        var score4User =
                                            MainCubit.get(context).score4User;
                                        return Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              "Score: ${score4User!.score}",
                                              style: TextStyle(
                                                  color: isDark
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            if (MainCubit.get(context)
                                                .profileModel!
                                                .role !=
                                                "ADMIN" &&
                                                score4User.score != 0)
                                              Column(
                                                children: [
                                                  Icon(Icons.looks_one),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(score4User.userRank.toString())
                                                ],
                                              )
                                          ],
                                        );
                                      });
                                    } else {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          color: isDark ? Colors.white : Colors.black,
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 15,),
                        Center(child: Text("Contributions", style: TextStyle(fontSize: screenWidth(context)/18),)),
                        divider(),
                        Expanded(
                          child: ConditionalBuilder(
                              condition:  MainCubit.get(context).profileModel!.materials.isNotEmpty && state is! GetRequestsLoadingState,
                              builder: (context) => Padding(
                                padding: const EdgeInsetsDirectional.symmetric(horizontal: 10.0),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: ListView.separated(
                                        physics: BouncingScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          var materials = MainCubit.get(context).profileModel!.materials;
                                          var mainCubit = MainCubit.get(context);
                                          return Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: isDark ? Color.fromRGBO(59, 59, 59, 1) : HexColor('#4764C5'),
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            child: materialBuilder(
                                              index,
                                              context,
                                              title: mainCubit.profileModel!.materials[index].title,
                                              description: mainCubit.profileModel!.materials[index].description,
                                              type: mainCubit.profileModel!.materials[index].type,
                                              link: mainCubit.profileModel!.materials[index].link,
                                              subjectName: mainCubit.profileModel!.materials[index].subject,
                                            ),
                                          );
                                        },
                                        separatorBuilder: (context, index) => SizedBox(height: 15,),
                                        itemCount: mainCubit.profileModel!.materials.length
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              fallback: (context) => Center(
                                child: CircularProgressIndicator(
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                              )),
                        )
                      ],
                    ),
                  ),
            ),
          );
        },
        listener: (context, state) {
          if(state is DeleteMaterialSuccessState)
            {
              MainCubit.get(context).getProfileInfo();
            }
        },
      ),
    );
  }
}

Widget materialBuilder(index, context,
    {title, link, type, subjectName, description}) {
  return Container(
    decoration: BoxDecoration(
      color: isDark ? Color.fromRGBO(59, 59, 59, 1) : HexColor('#4764C5'),
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
              SizedBox(
                width: screenWidth(context) / 1.5,
                child: Text(
                  '$title ',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: screenWidth(context)/16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const Spacer(),
              if(MainCubit.get(context).profileModel!.role == 'ADMIN')
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
                      print(MainCubit.get(context).profileModel!.materials[index].id!);
                      print(MainCubit.get(context).profileModel!.semester);
                      MainCubit.get(context).deleteMaterial(
                        MainCubit.get(context).profileModel!.materials[index].id!,
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
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: screenWidth(context)/1.2),
            child: Text(
              textAlign: TextAlign.end,
              subjectName.toString().replaceAll('_', ' ').replaceAll('And', '&'),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: screenWidth(context)/17, color: Colors.white),
            ),
          ),
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
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: constraints.maxWidth - 120),
                    child: GestureDetector(
                      onTap: () async {
                        final linkElement = LinkableElement(link, link);
                        await onOpen(context, linkElement);
                      },
                      child: Text(
                        link,
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                          decorationColor: HexColor('#B7B7B7'),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Spacer(),
                  Text(MainCubit.get(context).profileModel!.materials[index].accepted!? 'Accepted':'Pending', style: TextStyle(color: MainCubit.get(context).profileModel!.materials[index].accepted!? Colors.green:Colors.amber),),
                ],
              );
            },
          ),
        ],
      ),
    ),
  );
}
