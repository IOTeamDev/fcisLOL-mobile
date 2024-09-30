import 'dart:ui';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lol/layout/home/semester_navigate.dart';
import 'package:lol/models/subjects/semster_model.dart';
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
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../modules/admin/screens/announcements/announcements_list.dart';
import '../admin_panel/admin_panal.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    print(width.toString());
    // print("${SelectedSemester!}Home semester");
    // SelectedSemester = "One";
    var scaffoldKey = GlobalKey<ScaffoldState>();
    return MultiBlocProvider(
      providers: [
        // BlocProvider(
        //   create: (context) => LoginCubit(),
        // ),
        BlocProvider(
          create: (context) => MainCubit()..getProfileInfo(),
        ),
      ],
      child:
          BlocConsumer<MainCubit, MainCubitStates>(listener: (context, state) {
        if (state is Logout)
          showToastMessage(
            message: "Logout Successfully",
            // context: context,
            states: ToastStates.SUCCESS,
            // titleWidget: const
          );
      }, builder: (context, state) {
        ProfileModel? profile;
         int ?semesterIndex;

        // SelectedSemester = "Two";
        if (TOKEN != null && MainCubit.get(context).profileModel != null) {
          profile = MainCubit.get(context).profileModel!;
          print(profile.name);
        }
        if (profile != null && TOKEN != null) {
          semesterIndex = semsesterIndex(profile.semester);
          print("2");
        }
        if (TOKEN == null) {
          semesterIndex = semsesterIndex(SelectedSemester!);
          print("3");
        }

        print("$semesterIndex index");
        return Scaffold(
          key: scaffoldKey,
          backgroundColor: const Color(0xff1B262C),
          appBar: AppBar(
            leadingWidth: 50,

            leading: IconButton(
                style: IconButton.styleFrom(
                    padding: EdgeInsets.all(0), minimumSize: Size(0, 0)),
                onPressed: () {
                  // MainCubit.get(context).openDrawerState();
                  if ((TOKEN != null && profile != null) || TOKEN == null)
                    scaffoldKey.currentState!
                        .openDrawer(); // Use key to open the drawer
                },
                icon: const Icon(
                  Icons.menu,
                  size: 25,
                  color: Colors.white,
                )),
            backgroundColor: const Color(0xff0F4C75),
            // centerTitle: true,
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
            actions: [
              if (TOKEN == null)
                if (scaffoldKey.currentState?.isDrawerOpen == true)
                  Container(
                    margin: const EdgeInsets.only(right: 10),
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
          body: MainCubit.get(context).profileModel == null && TOKEN != null
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Stack(
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
                                    // semesters[semesterIndex!].subjects.length,
                                    semesters[semesterIndex!].subjects.length,
                                itemBuilder: (context, index) {
                                  return

                                      // subjectItemBuild(
                                      //     semesters[semesterIndex!]
                                      //         .subjects[index],context);
                                      subjectItemBuild(
                                          semesters[semesterIndex!]
                                              .subjects[index],
                                          context);
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
        );
      }),
    );
  }
}

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // SelectedSemester = "Three";
    // print(SelectedSemester);
double width=screenWidth(context);
    var profileModel = MainCubit.get(context).profileModel;
    return Drawer(
      width: width<600 ?width/1.5:width/2.5,
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
                      decoration: const BoxDecoration(color: Color(0xff0F4C75)),
                      accountName: Row(
                        children: [
                          Text(
                            profileModel!.name,
                            style: const TextStyle(overflow: TextOverflow.clip),
                          ),
                          const Spacer(),
                          Text(Level(profileModel.semester)),
                          const SizedBox(
                            width: 10,
                          )
                        ],
                      ),
                      // accountEmail: Text("2nd year "),
                      accountEmail: TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () => navigate(context, const Profile()),
                          child: const Text(
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
                      decoration: const BoxDecoration(color: Color(0xff0F4C75)),
                      // accountName: Text(""),
                      // accountEmail: Text("2nd year "),
                      accountName: const Text(""),
                      accountEmail: Text(
                        Level(SelectedSemester!),
                        style: const TextStyle(fontSize: 20),
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
                      currentAccountPicture: const CircleAvatar(
                        backgroundImage: NetworkImage(
                            "https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg"),
                      ),
                      otherAccountsPictures: [
                        InkWell(
                          onTap: () =>
                              navigatReplace(context, const LoginScreen()),
                          child: Ink(
                            child: const Text(
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
              leading: const Icon(Icons.announcement),
              title: const Text("Announcements"),
              onTap: () {
                navigate(context, const AnnouncementsList());
              },
            ),
            ExpansionTile(
              leading: const Icon(Icons.school),
              title: const Text("Years"),
              children: [
                ExpansionTile(
                  title: const Text("First Year"),
                  children: [
                    ListTile(
                      title: const Text("First Semester"),
                      onTap: () {
                        // MainCubit.get(context).profileModel = null;
                        // TOKEN = null;
                        navigate(
                            context, const SemesterNavigate(semester: "One"));
                      },
                    ),
                    ListTile(
                      title: const Text("Second Semester"),
                      onTap: () {
                        // MainCubit.get(context).profileModel = null;
                        // TOKEN = null;
                        navigate(
                            context, const SemesterNavigate(semester: "Two"));
                      },
                    ),
                  ],
                ),
                ExpansionTile(
                  title: const Text("Second Year"),
                  children: [
                    ListTile(
                      title: const Text("First Semester"),
                      onTap: () {
                        // MainCubit.get(context).profileModel = null;
                        // TOKEN = null;
                        navigate(
                            context, const SemesterNavigate(semester: "Three"));
                      },
                    ),
                    ListTile(
                      title: const Text("Second Semester"),
                      onTap: () {
                        // MainCubit.get(context).profileModel = null;
                        // TOKEN = null;
                        navigate(
                            context, const SemesterNavigate(semester: "Four"));
                      },
                    ),
                  ],
                ),
                ExpansionTile(
                  title: const Text("Third Year"),
                  children: [
                    ListTile(
                      title: const Text("First Semester"),
                      onTap: () {
                        // MainCubit.get(context).profileModel = null;
                        // TOKEN = null;
                        navigate(
                            context, const SemesterNavigate(semester: "Five"));
                      },
                    ),
                    ListTile(
                      title: const Text("Second Semester"),
                      onTap: () {
                        // MainCubit.get(context).profileModel = null;
                        // TOKEN = null;
                        navigate(
                            context, const SemesterNavigate(semester: "Six"));
                      },
                    ),
                  ],
                ),
                InkWell(
                  onTap: () => showToastMessage(
                      message: "Currently Updating ...",
                      states: ToastStates.INFO),
                  child: ExpansionTile(
                    enabled: false,
                    title: const Text("Seniors"),
                    children: [
                      ListTile(
                        title: const Text("First Semester"),
                        onTap: () {
                          // MainCubit.get(context).profileModel = null;
                          // TOKEN = null;
                          navigate(
                              context, const SemesterNavigate(semester: "One"));
                        },
                      ),
                      ListTile(
                        title: const Text("Second Semester"),
                        onTap: () {
                          // MainCubit.get(context).profileModel = null;
                          // TOKEN = null;
                          navigate(
                              context, const SemesterNavigate(semester: "Two"));
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ExpansionTile(
              leading: const Icon(Icons.drive_file_move),
              title: const Text("Drive"),
              children: [
                ListTile(
                  title: const Text("2027"),
                  onTap: () async {
                    LinkableElement url = LinkableElement('drive',
                        'https://drive.google.com/drive/folders/1-1_Ef2qF0_rDzToD4OlqIl5xubgpMGU0');
                    await onOpen(context, url);
                  },
                ),
                ListTile(
                  title: const Text("2026"),
                  onTap: () async {
                    LinkableElement url = LinkableElement('drive',
                        'https://drive.google.com/drive/folders/1CdZDa3z97RN_yRjFlC7IAcLfmw6D1yLy');
                    await onOpen(context, url);
                  },
                ),
                ListTile(
                  title: const Text("2025"),
                  onTap: () async {
                    LinkableElement url = LinkableElement('drive',
                        'https://drive.google.com/drive/folders/1BAXez9FJKF_ASx79usd_-Xi47TdUYK73?fbclid=IwAR3cRtEV1aJrcvKoGNBLCbqBu2LMLrsWYfQkOZUb6SQE2dtT3ZtqrcCjxno');
                    await onOpen(context, url);
                  },
                ),
                ListTile(
                  title: const Text("2024"),
                  onTap: () async {
                    LinkableElement url = LinkableElement('drive',
                        'https://drive.google.com/drive/u/0/folders/11egB46e3wtl1Q69wdCBBam87bwMF7Qo-');
                    await onOpen(context, url);
                  },
                ),
              ],
            ),
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text("About Us"),
              onTap: () {},
            ),
            if (profileModel?.role == "ADMIN")
              ListTile(
                leading: const Icon(Icons.admin_panel_settings),
                title: const Text("Admin"),
                onTap: () {
                  navigate(context, AdminPanal());
                },
              ),
            if (TOKEN != null)
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  "Log out",
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  MainCubit.get(context).logout(context);
                  Provider.of<ThemeProvide>(context, listen: false).isDark =
                      false;
                  Provider.of<ThemeProvide>(context, listen: false)
                      .notifyListeners();
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
  // var mainCubit = MainCubit.get(context);

  return GestureDetector(
    onTap: () {
      Provider.of<ThemeProvide>(context, listen: false).changeMode();
    },
    child: Container(
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.blue.shade100, // Background color
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(
              color: Provider.of<ThemeProvide>(context).isDark
                  ? const Color.fromARGB(188, 92, 38, 38)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: const Row(
              children: [
                Icon(Icons.dark_mode, color: Colors.black),
                SizedBox(width: 8),
                Text(
                  'Dark',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(
              color: !Provider.of<ThemeProvide>(context).isDark
                  ? const Color.fromARGB(188, 92, 38, 38)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.light_mode,
                  color: !Provider.of<ThemeProvide>(context).isDark
                      ? Colors.white
                      : Colors.black,
                ),
                const SizedBox(width: 8),
                Text(
                  'Light',
                  style: TextStyle(
                    color: !Provider.of<ThemeProvide>(context).isDark
                        ? Colors.white
                        : Colors.black,
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
      navigate(
          context,
          SubjectDetails(
            subjectName: subject.subjectName,
          ));
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
                image: subject.subjectName=="Data Mining"? AssetImage("images/data-mining_cleanup.webp"):NetworkImage(subject.subjectImage),
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
