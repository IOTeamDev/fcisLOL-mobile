import 'dart:ui';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lol/layout/home/semster_model.dart';
import 'package:lol/models/profile/profile_model.dart';
import 'package:lol/models/subjects/subject_model.dart';
import 'package:lol/modules/auth/bloc/login_cubit.dart';
import 'package:lol/modules/auth/screens/login.dart';
import 'package:lol/modules/subject/subject_details.dart';
import 'package:lol/shared/components/components.dart';
import 'package:lol/shared/components/snack.dart';
import 'package:lol/shared/components/constants.dart';
import 'package:lol/layout/home//bloc/main_cubit.dart';
import 'package:lol/layout/home/bloc/main_cubit_states.dart';
import 'package:lol/layout/profile/profile.dart';
import 'package:lol/main.dart';
import 'package:lol/shared/components/navigation.dart';
import 'package:lol/shared/network/local/shared_prefrence.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    var scaffoldKey = GlobalKey<ScaffoldState>();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginCubit(),
        ),
        BlocProvider(
          create: (context) => MainCubit()..getProfileInfo(),
        ),
      ],
      child:
          BlocConsumer<MainCubit, MainCubitStates>(listener: (context, state) {
        if (state is Logout)
          snack(
              context: context,
              enumColor: Messages.success,
              titleWidget: const Text("Logout Successfully"));
      }, builder: (context, state) {
        ProfileModel? profile;
        int? semesterIndex;
        if (TOKEN != null && MainCubit.get(context).profileModel != null) {
          profile = MainCubit.get(context).profileModel!;

          semesterIndex = semsesterIndex(
              TOKEN != null ? profile.semester : SelectedSemester!);
        }
        return Scaffold(
          key: scaffoldKey,
          backgroundColor: const Color(0xff1B262C),
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  MainCubit.get(context).openDrawerState();

                  scaffoldKey.currentState!
                      .openDrawer(); // Use key to open the drawer
                },
                icon: const Icon(
                  Icons.menu,
                  color: Colors.white,
                )),
            backgroundColor: const Color(0xff0F4C75),
            title: const InkWell(child: Row()),
            actions: [
              if (TOKEN == null)
                Container(
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xff4fd1c5),
                            Color(0xff38b2ac),
                          ]),
                      color: const Color(0xFF00ADB5),
                      borderRadius: BorderRadius.circular(10)),
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()));
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
          drawer: CustomDrawer(),
          body: MainCubit.get(context).profileModel == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : InkWell(
                  onTap: () {
                    MainCubit.get(context).closeDrawerState();
                  },
                  child: Stack(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF1c1c2e), // Dark indigo
                              Color(0xFF2c2b3f), // Deep purple
                            ],
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              CarouselSlider(
                                items: carsor.map((carsor) {
                                  return InkWell(
                                      child: Stack(
                                          alignment: Alignment.bottomCenter,
                                          children: [
                                        Container(
                                          clipBehavior: Clip.antiAlias,
                                          // margin: const EdgeInsets.all(6.0),
                                          // child: Image.asset("images/332573639_735780287983011_1562632886952931410_n.jpg",width: 400,height: 400,fit: BoxFit.cover,),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(3.0),
                                            // image: DecorationImage(
                                            //   image: AssetImage(
                                            //     carsor.image ?? "images/llogo.jfif",
                                            //   ),
                                            //   fit: BoxFit.cover,
                                            // ),
                                          ),
                                          child: Image.asset(
                                            carsor.image!,
                                            width: 400,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.black.withOpacity(0.2),
                                                Colors.transparent,
                                              ],
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.topCenter,
                                            ),
                                          ),
                                        ),
                                        Container(
                                            // padding: EdgeInsets.all(5),
                                            // width: 400,
                                            decoration: BoxDecoration(
                                                color: const Color.fromARGB(
                                                        51, 65, 180, 197)
                                                    .withOpacity(0.6)
                                                    .withAlpha(150),
                                                borderRadius:
                                                    BorderRadius.circular(3)),
                                            child: Text(
                                              carsor.text!,
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500),
                                              textAlign: TextAlign.center,
                                            ))
                                      ]));
                                }).toList(),
                                options: CarouselOptions(
                                  height: 200.0,
                                  autoPlay: true,
                                  enlargeCenterPage: true,
                                  aspectRatio: 16 / 9,
                                  autoPlayCurve: Curves.fastOutSlowIn,
                                  enableInfiniteScroll: true,
                                  autoPlayInterval: const Duration(seconds: 10),
                                  autoPlayAnimationDuration:
                                      const Duration(milliseconds: 800),
                                  viewportFraction: 0.8,
                                ),
                              ),
                              const SizedBox(height: 20),
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.all(16.0),
                                child: GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2, // Two items per row
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    childAspectRatio: 3 /
                                        2, // Control the height and width ratio
                                  ),
                                  itemCount:
                                      semesters[semesterIndex!].subjects.length,
                                  itemBuilder: (context, index) {
                                    return subjectItemBuild(
                                        semesters[semesterIndex!]
                                            .subjects[index],context);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // if (scaffoldKey.currentState?.isDrawerOpen == true)
                      //   BackdropFilter(
                      //     filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                      //     child: Container(
                      //       color: Colors.transparent,
                      //     ),
                      //   ),
                    ],
                  ),
                ),
        );
      }),
    );
  }
}

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // SelectedSemester = "One";

    var profileModel = MainCubit.get(context).profileModel;
    return Drawer(
      width: screenWidth(context) / 1.3,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TOKEN != null
                ? GestureDetector(
              onTap: () {
                print("sdfsd");
              },
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Color(0xff0F4C75)),
                accountName: Row(
                  children: [
                    Text(
                      profileModel!.name,
                      style: TextStyle(overflow: TextOverflow.clip),
                    ),
                    Spacer(),
                    Text(Level(profileModel.semester)),
                    SizedBox(
                      width: 10,
                    )
                  ],
                ),
                // accountEmail: Text("2nd year "),
                accountEmail: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () => navigate(context, Profile()),
                    child: Text(
                      "Profile info",
                      style: TextStyle(color: Colors.orange),
                    )),
                currentAccountPicture: ClipOval(
                  child: Image.network(
                    profileModel.photo,
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                  ),
                  // backgroundImage: NetworkImage(profileModel.photo),
                ),
                // otherAccountsPictures: [
                //   Icon(Icons.info, color: Colors.white),
                // ],
              ),
            )
                : GestureDetector(
              onTap: () {
                print("sdfsd");
              },
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Color(0xff0F4C75)),
                // accountName: Text(""),
                // accountEmail: Text("2nd year "),
                accountName: Text(""),
                accountEmail: Text(
                  Level(SelectedSemester!),
                  style: TextStyle(fontSize: 20),
                ),
                // accountEmail:InkWell(
                //   child: Ink(
                //     child: Text(
                //       // style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
                //       // onPressed: () {
                //       //   Navigator.push(
                //       //       context,
                //       //       MaterialPageRoute(
                //       //           builder: (context) => const LoginScreen()));
                //       // },
                //       // child: const Text(
                //         "Login",
                //         style: TextStyle(color: Colors.white),

                //     ),
                //   ),
                // ) ,
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg"),
                ),
                otherAccountsPictures: [
                  InkWell(
                    onTap: () => navigatReplace(context, LoginScreen()),
                    child: Ink(
                      child: Text(
                        // style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
                        // onPressed: () {
                        //   Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //           builder: (context) => const LoginScreen()));
                        // },
                        // child: const Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.announcement),
              title: Text("Announcements"),
              onTap: () {},
            ),
            ExpansionTile(
              leading: Icon(Icons.school),
              title: Text("Years"),
              children: [
                ExpansionTile(
                  title: Text("First Year"),
                  children: [
                    ListTile(title: Text("First Semester")),
                    ListTile(title: Text("Second Semester")),
                  ],
                ),
                ExpansionTile(
                  title: Text("Second Year"),
                  children: [
                    ListTile(title: Text("First Semester")),
                    ListTile(title: Text("Second Semester")),
                  ],
                ),
              ],
            ),
            ListTile(
              leading: Icon(Icons.link),
              title: Text("Links"),
              onTap: () {},
            ),
            ExpansionTile(
              leading: Icon(Icons.drive_file_move),
              title: Text("Drive"),
              children: [
                ListTile(
                  title: Text("2027"),
                  onTap: () async {
                    LinkableElement url = LinkableElement('drive','https://drive.google.com/drive/folders/1-1_Ef2qF0_rDzToD4OlqIl5xubgpMGU0');
                    await onOpen(context, url);
                  },
                ),
                ListTile(
                  title: Text("2026"),
                  onTap: () {
                    launchUrlC(
                        "https://drive.google.com/drive/folders/1CdZDa3z97RN_yRjFlC7IAcLfmw6D1yLy");
                  },
                ),
                ListTile(
                  title: Text("2025"),
                  onTap: () {
                    launchUrlC(
                        "https://drive.google.com/drive/folders/1BAXez9FJKF_ASx79usd_-Xi47TdUYK73?fbclid=IwAR3cRtEV1aJrcvKoGNBLCbqBu2LMLrsWYfQkOZUb6SQE2dtT3ZtqrcCjxno");
                  },
                ),
                ListTile(
                  title: Text("2024"),
                  onTap: () {
                    launchUrlC(
                        "https://drive.google.com/drive/u/0/folders/11egB46e3wtl1Q69wdCBBam87bwMF7Qo-");
                  },
                ),
              ],
            ),
            ListTile(
              leading: Icon(Icons.group),
              title: Text("About Us"),
              onTap: () {},
            ),
            if (profileModel!.role == "ADMIN")
              ListTile(
                leading: Icon(Icons.admin_panel_settings),
                title: Text("Admin"),
                onTap: () {},
              ),
            if (TOKEN != null)
              ListTile(
                leading: Icon(Icons.logout, color: Colors.red),
                title: Text(
                  "Log out",
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  MainCubit.get(context).logout(context);
                },
              ),
            SizedBox(
              height: screenHeight(context) / 5,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DarkLightModeToggle(context),
            ),
          ],
        ),
      ),
    );
  }
}
launchUrlC(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

String Level(String semester) {
  switch (semester) {
    case "One":
    case "Two":
      return "1st year";

    case "Three":
    case "Four":
      return "2nd year";

    case "Five":
    case "Six":
      return "3rd year";

    case "Seven":
    case "Eight":
      return "4th year";

    default:
      return null.toString();
  }
}

Widget DarkLightModeToggle(context) {
  var mainCubit = MainCubit.get(context);

  return GestureDetector(
    onTap: () {
      MainCubit.get(context).changeMode();
    },
    child: Container(
      padding: EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.blue.shade100, // Background color
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(
              color: mainCubit.isDarkMode ? Colors.transparent : Colors.black,
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.dark_mode,
                  color: mainCubit.isDarkMode ? Colors.black : Colors.white,
                ),
                SizedBox(width: 8),
                Text(
                  'Dark Mode',
                  style: TextStyle(
                    color: mainCubit.isDarkMode ? Colors.black : Colors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 4),
          Container(
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(
              color: mainCubit.isDarkMode ? Colors.black : Colors.transparent,
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.light_mode,
                  color: mainCubit.isDarkMode ? Colors.white : Colors.black,
                ),
                SizedBox(width: 8),
                Text(
                  'Light Mode',
                  style: TextStyle(
                    color: mainCubit.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget subjectItemBuild(SubjectModel subject, context) {
  return GestureDetector(
    onTap: () {
      navigate(context, SubjectDetails(subjectName: subject.subjectName,));
    },
    child: Card(
      elevation: 12.0, // More elevation for depth
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                colorFilter:
                    const ColorFilter.mode(Color(0xfff39c12), BlendMode.dstIn),
                image: NetworkImage(subject.subjectImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.6),
                  Colors.transparent,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              subject.subjectName,
              maxLines: 2,
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ),
  );
}

class CarsorModel {
  String? image;
  String? text;
  CarsorModel({this.image, this.text});
}

List<CarsorModel> carsor = [
  CarsorModel(
      image: "images/140.jpg", text: "Latest Of Academic Schedule \"9-17\" "),
  CarsorModel(
      image: "images/332573639_735780287983011_1562632886952931410_n.jpg",
      text:
          "RoboTech summers training application form opens today at 9:00 pm! Be ready "),
  CarsorModel(
      image: "images/338185486_3489006871419356_4868524435440167213_n.jpg",
      text:
          "Cyberus summers training application form opens today at 9:00 pm! Be ready "),
];
// List subjectNamesList = [
//   "Physics",
//   "Electronics",
//   "Calculus",
//   "Ethics",
//   "Business",
//   "Intro to Computer Sciences",
// ];

// List carsor = [
//   "images/clock.jpeg",
//   "images/clockworkorange_tall.jpg",
//   "images/images.jfif",
//   "images/shutterstock_5885876aa.webp",
//   "images/120604_r22256_g2048.webp",
// ];  on this
