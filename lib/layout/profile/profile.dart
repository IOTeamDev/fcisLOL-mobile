import 'dart:math';

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
            BlocProvider.of<MainCubit>(context)
                .getLeaderboard(MainCubit.get(context).profileModel!.semester);
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
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 60,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 25),
                            child: Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    icon: Icon(
                                      Icons.arrow_back,
                                      color:
                                          isDark ? Colors.white : Colors.black,
                                      size: 30,
                                    )),
                                Spacer(),
                                Text(
                                  'My Profile',
                                  style: TextStyle(
                                      color:
                                          isDark ? Colors.white : Colors.black,
                                      fontSize: screenWidth(context) / 12),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Spacer(),
                              ],
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: screenWidth(context) / 3,
                                child: Align(
                                  child: CircleAvatar(
                                    radius: 40,
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
                                ],
                              ),
                            ],
                          ),
                          Builder(
                            builder: (context) {
                              if (MainCubit.get(context).leaderboardModel !=
                                  null) {
                                return Builder(builder: (context) {
                                  MainCubit.get(context).getScore4User(
                                      MainCubit.get(context).profileModel!.id);
                                  var score4User =
                                      MainCubit.get(context).score4User;
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        children: [
                                          // Icon(),
                                          Text(
                                            "Score: ${score4User!.score}",
                                            style: TextStyle(
                                                color: isDark
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
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
                          TabBar(
                              dividerColor:
                                  isDark ? HexColor('3B3B3B') : Colors.black,
                              tabs: [
                                Tab(
                                  // icon: Icon(Icons.p),
                                  text: "Personal Info",
                                ),
                                Tab(
                                  // icon: Icon(Icons.nat),
                                  text: "Contributions",
                                )
                              ])
                          // i wanna make two navigations taps here
                          ,
                          Expanded(
                            child: MainCubit.get(context).profileModel == null
                                ? Center(
                                    child: CircularProgressIndicator(
                                      color:
                                          isDark ? Colors.white : Colors.black,
                                    ),
                                  )
                                : TabBarView(
                                    physics: const BouncingScrollPhysics(),
                                    children: [
                                        Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Column(
                                            children: [
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              defaultTextField(
                                                  enabled: false,
                                                  label: "Name",
                                                  controller: nameController,
                                                  dtaPrefIcon: Icons.person),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              defaultTextField(
                                                  enabled: false,
                                                  label: "Email",
                                                  controller: emailController,
                                                  dtaPrefIcon: Icons.email),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              defaultTextField(
                                                  enabled: false,
                                                  label: "Phone",
                                                  controller: phoneController,
                                                  dtaPrefIcon: Icons.phone),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            Expanded(
                                              child: ListView.separated(
                                                  itemBuilder:
                                                      (context, index) {
                                                    var materials =
                                                        MainCubit.get(context)
                                                            .profileModel!
                                                            .materials;
                                                    var mainCubit =
                                                        MainCubit.get(context);
                                                    return Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8),
                                                      decoration: BoxDecoration(
                                                        color: isDark
                                                            ? Color.fromRGBO(
                                                                59, 59, 59, 1)
                                                            : HexColor(
                                                                '#4764C5'),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      child: materialBuilder(
                                                        index,
                                                        context,
                                                        title: mainCubit
                                                            .profileModel!
                                                            .materials[index]
                                                            .title,
                                                        description: mainCubit
                                                            .profileModel!
                                                            .materials[index]
                                                            .description,
                                                        type: mainCubit
                                                            .profileModel!
                                                            .materials[index]
                                                            .type,
                                                        link: mainCubit
                                                            .profileModel!
                                                            .materials[index]
                                                            .link,
                                                        subjectName: mainCubit
                                                            .profileModel!
                                                            .materials[index]
                                                            .subject,
                                                      ),
                                                    );
                                                  },
                                                  separatorBuilder:
                                                      (context, index) =>
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                  itemCount: 5),
                                            ),
                                          ],
                                        ),
                                      ]),
                          )
                        ],
                      ),
                    ),
            ),
          );
        },
        listener: (context, state) {},
      ),
    );
  }
}

Widget demoItemBuilder(ProfileMaterilaModel material, context) {
  if (material.type == "VIDEO") {
    return InkWell(
      onTap: () async {
        // Action when the tile is tapped.
      },
      child: SizedBox(
        // width: 30,
        height: 200,
        child: GridTile(
          footer: Container(
            padding: const EdgeInsets.all(5),
            color:
                Colors.black54, // Slight transparency for better readability.
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    material.title ?? '',
                    style: TextStyle(
                      fontSize: screenWidth(context) / 20,
                      color: Colors
                          .white, // Ensure text contrast on dark background.
                    ),
                    maxLines: 1, // Limit to 1 line for footer text.
                    overflow: TextOverflow.ellipsis, // Handle long titles.
                  ),
                ),
              ],
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10), // Rounded corners.
            child: Image.network(
              // Provide a placeholder image in case the link fails to load.
              material.link != null && material.link!.isNotEmpty
                  ? material.link!
                  : 'https://example.com/placeholder.jpg',
              fit: BoxFit.cover, // Cover the entire tile.
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(), // Loading indicator.
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                );
              },
            ),
          ),
        ),
      ),
    );
  } else {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(217, 217, 217, 0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        material.subject ?? 'No subject',
        style: TextStyle(
          fontSize: screenWidth(context) / 22,
        ),
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
    margin: const EdgeInsetsDirectional.symmetric(horizontal: 10),
    padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
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
                width: screenWidth(context) / 3,
                child: Text(
                  '$title ',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: screenWidth(context) / 3,
                child: Text(
                  textAlign: TextAlign.end,
                  '$subjectName',
                  maxLines: 3,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 10.0),
            child: Text(
              type,
              style: TextStyle(fontSize: 13, color: Colors.grey[300]),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                children: [
                  Icon(Icons.link, color: HexColor('#B7B7B7')),
                  const SizedBox(width: 5),
                  ConstrainedBox(
                    constraints:
                        BoxConstraints(maxWidth: constraints.maxWidth - 80),
                    child: GestureDetector(
                      onTap: () async {
                        final linkElement = LinkableElement(link, link);
                        await onOpen(context, linkElement);
                      },
                      child: Text(
                        link,
                        style: TextStyle(
                          color: HexColor('#B7B7B7'),
                          decoration: TextDecoration.underline,
                          decorationColor: HexColor('#B7B7B7'),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
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
