import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:googleapis/games/v1.dart';
import 'package:googleapis/mybusinessaccountmanagement/v1.dart';
import 'package:linkify/linkify.dart';
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
              appBar: AppBar(
                leadingWidth: 50,
                title: GestureDetector(
                  onTap: () => navigatReplace(context, const Home()),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Icon(Icons.apple),
                      const SizedBox(width: 10),
                      Text(
                        "name",
                        style: GoogleFonts.montserrat(),
                      ),
                      SizedBox(width: 50)
                    ],
                  ),
                ),
              ),
              body: mainCubit.profileModel == null
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            // Container(height: height,),
                            SizedBox(
                                height: height * 0.3,
                                // width: width,
                                child: Align(
                                    alignment: Alignment.topCenter,
                                    child: Container(
                                      height: height * 0.2,
                                      color: const Color(0xff0F4C75),
                                      width: width,
                                    ))),
                            Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                SizedBox(
                                  height: 150,
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: CircleAvatar(
                                      radius: 50,
                                      backgroundImage: NetworkImage(
                                        mainCubit.profileModel!.photo,
                                      ),
                                      // child: Image.network(

                                      //   width: 110,
                                      //   height: 110,
                                      //   fit: BoxFit.cover,
                                      // ),
                                    ),
                                  ),
                                ),
                                Text(
                                  mainCubit.profileModel!.name,
                                  style: const TextStyle(fontSize: 20),
                                )
                              ],
                            )
                            // ,Column()
                          ],
                        ),
                        // Text("44"),
                        const SizedBox(
                          height: 20,
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
                                          "My Score",
                                          style: TextStyle(
                                              color: Colors.redAccent,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(score4User!.score.toString())
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
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        ),

                        const SizedBox(
                          height: 10,
                        ),
                        const TabBar(tabs: [
                          Tab(
                            // icon: Icon(Icons.p),
                            text: "Personal Info",
                          ),
                          Tab(
                            // icon: Icon(Icons.nat),
                            text: "My Uploads",
                          )
                        ])
                        // i wanna make two navigations taps here
                        ,
                        Expanded(
                          child: MainCubit.get(context).profileModel == null
                              ? Center(
                                  child: CircularProgressIndicator(),
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
                                                itemBuilder: (context, index) {
                                                  var materials =
                                                      MainCubit.get(context)
                                                          .profileModel!
                                                          .materials;

                                                  return Container(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          const Color.fromRGBO(
                                                              217,
                                                              217,
                                                              217,
                                                              0.1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                    child: demoItemBuilder(
                                                        materials[index],
                                                        context),
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
