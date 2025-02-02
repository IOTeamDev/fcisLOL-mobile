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
import 'package:lol/core/models/profile/profile_materila_model.dart';
import 'package:lol/features/subject/presentation/cubit/subject_cubit.dart';
import 'package:lol/core/utils/components.dart';
import 'package:lol/core/widgets/default_button.dart';
import 'package:lol/core/widgets/default_text_field.dart';
import 'package:lol/core/utils/colors.dart';
import 'package:lol/core/utils/resources/constants_manager.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit_states.dart';
import 'package:lol/features/home/presentation/view/home.dart';
import 'package:lol/core/utils/navigation.dart';

bool refreshing = false;

class OtherProfile extends StatelessWidget {
  final id;
  const OtherProfile({super.key, this.id});

  @override
  Widget build(BuildContext context) {
    var nameController = TextEditingController();
    var emailController = TextEditingController();
    return BlocProvider(
      create: (context) => MainCubit()..getotherProfile(id),
      child: BlocConsumer<MainCubit, MainCubitStates>(
        builder: (context, state) {
          if (state is GetProfileSuccess) {
            BlocProvider.of<MainCubit>(context)
                .getLeaderboard(MainCubit.get(context).otherProfile!.semester);
          }
          var mainCubit = MainCubit.get(context);
          if (mainCubit.otherProfile != null) {
            nameController.text = mainCubit.otherProfile!.name;
            emailController.text = mainCubit.otherProfile!.email;
          }
          return Scaffold(
            appBar: AppBar(
              backgroundColor: isDark ? HexColor('#23252A') : Colors.white,
              centerTitle: true,
              title: mainCubit.otherProfile == null
                  ? Text("")
                  : Text(
                      mainCubit.otherProfile!.name,
                      style: GoogleFonts.playfairDisplay(
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: AppQueries.screenWidth(context) / 15,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
            ),
            backgroundColor: isDark ? HexColor('#23252A') : Colors.white,
            body: mainCubit.otherProfile == null
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                            SizedBox(
                              width: AppQueries.screenWidth(context) / 3.2,
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  CircleAvatar(
                                    radius: AppQueries.screenWidth(context) / 7.5,
                                    backgroundImage: NetworkImage(
                                      mainCubit.otherProfile!.photo!,
                                    ),
                                  ),
                                  FutureBuilder(
                                    future: MainCubit.get(context)
                                        .getScore4User(id),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator(); // Add a loading indicator
                                      }
                                      if (snapshot.hasError) {
                                        return Text(""); // Handle any errors
                                      }
                                      if (mainCubit.score4User != null &&
                                          mainCubit.score4User!.score != 0 &&
                                          mainCubit.otherProfile != null &&
                                          mainCubit.otherProfile!.role !=
                                              "ADMIN" &&
                                          mainCubit.score4User!.userRank! <=
                                              3) {
                                        // Define rank-specific properties
                                        final color =
                                            mainCubit.score4User!.userRank == 1
                                                ? Color(0xffFFD700)
                                                : mainCubit.score4User!
                                                            .userRank ==
                                                        2
                                                    ? Color(0xffC0C0C0)
                                                    : Color(0xffCD7F32);

                                        final rankText =
                                            mainCubit.score4User!.userRank == 1
                                                ? "Top Contributor"
                                                : mainCubit.score4User!
                                                            .userRank ==
                                                        2
                                                    ? "2nd Contributor"
                                                    : "3rd Contributor";

                                        return Container(
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: color,
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          child: Text(
                                            rankText,
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        );
                                      } else {
                                        return Text(
                                            ""); // Show nothing if conditions aren't met
                                      }
                                    },
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Builder(
                              builder: (context) {
                                if (MainCubit.get(context).leaderboardModel !=
                                    null) {
                                  return Builder(builder: (context) {
                                    MainCubit.get(context).getScore4User(
                                        MainCubit.get(context)
                                            .otherProfile!
                                            .id);
                                    var score4User =
                                        MainCubit.get(context).score4User;
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: "Score: ",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              TextSpan(
                                                text: "${score4User!.score}",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (MainCubit.get(context)
                                                    .otherProfile!
                                                    .role !=
                                                "ADMIN" &&
                                            score4User.score != 0)
                                          Row(
                                            children: [
                                              Text.rich(
                                                TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: "Rank: ",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          "${score4User.userRank}",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              if (score4User.userRank! <= 10 &&
                                                  score4User.score! > 0)
                                                Container(
                                                    margin: EdgeInsets.only(
                                                        left: 5),
                                                    child: Image.asset(
                                                      "images/top10.png",
                                                      width: 30,
                                                      height: 30,
                                                    ))
                                            ],
                                          ),
                                      ],
                                    );
                                  });
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      color:
                                          isDark ? Colors.white : Colors.black,
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Center(
                            child: Text(
                          "Uploads",
                          style: TextStyle(fontSize: AppQueries.screenWidth(context) / 18),
                        )),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(
                          color: isDark ? Colors.white : Colors.black,
                          height: 20,
                        ),
                        Expanded(
                          child: ConditionalBuilder(
                              condition: MainCubit.get(context)
                                      .otherProfile!
                                      .materials
                                      .isNotEmpty &&
                                  state is! GetRequestsLoadingState,
                              builder: (context) => Padding(
                                    padding:
                                        const EdgeInsetsDirectional.symmetric(
                                            horizontal: 10.0),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: ListView.separated(
                                              physics: BouncingScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                var materials =
                                                    MainCubit.get(context)
                                                        .otherProfile!
                                                        .materials;
                                                var mainCubit =
                                                    MainCubit.get(context);
                                                return Container(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .symmetric(
                                                          horizontal: 3,
                                                          vertical: 5),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  child: materialBuilder(
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
                                                  ),
                                                );
                                              },
                                              separatorBuilder:
                                                  (context, index) => SizedBox(
                                                        height: 0,
                                                      ),
                                              itemCount: mainCubit.otherProfile!
                                                  .materials.length),
                                        ),
                                      ],
                                    ),
                                  ),
                              fallback: (context) {
                                if (state is GetRequestsLoadingState) {
                                  return SizedBox(
                                      height: AppQueries.screenHeight(context) / 1.3,
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ));
                                }
                                return SizedBox(
                                    height: AppQueries.screenHeight(context) / 1.3,
                                    child: Center(
                                      child: Text(
                                        'You Have No Contributions Yet!!!',
                                        style: TextStyle(fontSize: AppQueries.screenWidth(context) / 12),
                                        textAlign: TextAlign.center,
                                      ),
                                    ));
                              }),
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
      ),
    );
  }
}

Widget materialBuilder(index, context,
    {title, link, type, subjectName, description}) {
  return Container(
    padding: EdgeInsets.all(5),
    decoration: BoxDecoration(
      color: isDark ? HexColor('#3B3B3B') : Color.fromARGB(255, 20, 130, 220),
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
              if (MainCubit.get(context).otherProfile!.role == 'ADMIN')
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
                            .otherProfile!
                            .materials[index]
                            .id!);
                        print(MainCubit.get(context).otherProfile!.semester);
                        MainCubit.get(context).deleteMaterial(
                          MainCubit.get(context)
                              .otherProfile!
                              .materials[index]
                              .id!,
                          MainCubit.get(context).otherProfile!.semester,
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
                  fontSize: AppQueries.screenWidth(context) / 17, color: Colors.white),
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
                    child: GestureDetector(
                      onTap: () async {
                        final linkElement = LinkableElement(link, link);
                        await onOpen(context, linkElement);
                      },
                      child: SelectableText(
                        link,
                        style: TextStyle(
                          color: Colors.lightBlueAccent,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.lightBlueAccent,
                        ),
                        maxLines: 1,
                        // overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  // Spacer(),
                  Text(
                    MainCubit.get(context)
                            .otherProfile!
                            .materials[index]
                            .accepted!
                        ? 'Accepted'
                        : 'Pending',
                    style: TextStyle(
                        color: MainCubit.get(context)
                                .otherProfile!
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
