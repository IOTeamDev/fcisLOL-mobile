import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:googleapis/admin/directory_v1.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lol/layout/home/semester_navigate.dart';
import 'package:lol/models/admin/announcement_model.dart';
import 'package:lol/models/subjects/semster_model.dart';
import 'package:lol/models/profile/profile_model.dart';
import 'package:lol/models/subjects/subject_model.dart';
import 'package:lol/modules/admin/bloc/admin_cubit.dart';
import 'package:lol/modules/admin/bloc/admin_cubit_states.dart';
import 'package:lol/modules/auth/bloc/login_cubit.dart';
import 'package:lol/modules/auth/screens/login.dart';
import 'package:lol/modules/leaderboard/leaderboard_screen.dart';
import 'package:lol/modules/subject/cubit/subject_cubit.dart';
import 'package:lol/modules/subject/screens/subject_details.dart';
import 'package:lol/modules/support_and_about_us/about_us.dart';
import 'package:lol/modules/support_and_about_us/user_advices/feedback_screen.dart';
import 'package:lol/modules/support_and_about_us/user_advices/report_bug.dart';
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
        //   BlocProvider(
        //   create: (context) => SubjectCubit()..getMaterials(),
        // ),
        BlocProvider(
          create: (context) => AdminCubit(),
        ),
      ],
      child:
          BlocConsumer<MainCubit, MainCubitStates>(listener: (context, state) {
        if (state is Logout) {
          showToastMessage(
            message: "Logout Successfully",
            // context: context,
            states: ToastStates.SUCCESS,
            // titleWidget: const
          );
        }
      }, builder: (context, state) {
        bool wannaAnnouncements = true;
        print('$wannaAnnouncements wanna announcement ');

        List<AnnouncementModel>? announcements =
            AdminCubit.get(context).announcements;

        if (announcements != null && announcements.isNotEmpty) {
          print("${announcements[0].title} dfggdfghghfdfgh");
        } else {
          print("Announcements are null or empty");
        }
        if ((state is GetProfileSuccess || TOKEN == null) &&
            wannaAnnouncements) {
          if (TOKEN == null) {
            BlocProvider.of<AdminCubit>(context)
                .getAnnouncements(SelectedSemester!);
          } else {
            BlocProvider.of<AdminCubit>(context).getAnnouncements(
                MainCubit.get(context).profileModel!.semester);
          }
          wannaAnnouncements = false;

          if (announcements != null && announcements.isNotEmpty) {
            print(announcements[0].title);
          } else {
            print("Announcements are null");
          }
        }
        print('$wannaAnnouncements wanna announcement ');

        ProfileModel? profile;
        int? semesterIndex;

        // SelectedSemester = "Two";
        if (MainCubit.get(context).profileModel != null) {
          profile = MainCubit.get(context).profileModel!;
          print(profile.name);
        }

        if (profile != null) {
          semesterIndex = semsesterIndex(profile.semester);
        } else if (TOKEN == null) {
          semesterIndex = semsesterIndex(SelectedSemester!);
        }

        // print("$semesterIndex index");
        return profile == null && TOKEN != null
            ? const Scaffold(
                //backgroundColor: Color(0xff1B262C),
                body: Center(child: CircularProgressIndicator()),
              )
            : Scaffold(
                key: scaffoldKey,
                // backgroundColor: Color(0xffE1E1E1),
                drawer: CustomDrawer(
                    context,
                    TOKEN == null
                        ? SelectedSemester
                        : MainCubit.get(context).profileModel!.semester),
                body: profile == null && TOKEN != null
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : SingleChildScrollView(
                        child: SafeArea(
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Row(
                                    children: [
                                      MaterialButton(
                                          padding: EdgeInsets.zero,
                                          minWidth: 0,
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          onPressed: () {
                                            // MainCubit.get(context).openDrawerState();
                                            if ((TOKEN != null &&
                                                    profile != null) ||
                                                TOKEN == null) {
                                              scaffoldKey.currentState!
                                                  .openDrawer(); // Use key to open the drawer
                                            }
                                          },
                                          child: Image.asset(
                                            !isDark
                                                ? "images/mage_dashboard-fill-1.png"
                                                : "images/mage_dashboard-fill.png",
                                            width: 25,
                                            height: 25,
                                          )),
                                      Expanded(
                                          child: GestureDetector(
                                              onTap: () => navigatReplace(
                                                  context, const Home()),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const SizedBox(width: 15),
                                                  Image.asset(
                                                    "images/l.png",
                                                    width: 45,
                                                    height: 45,
                                                    color: isDark?Colors.white:null,
                                                  ),
                                                  Text(
                                                    "UniNotes",
                                                    style: GoogleFonts.abel(
                                                        fontSize: 28,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ],
                                              ))),
                                      SizedBox(
                                        width: 25,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                    margin:
                                        EdgeInsets.only(left: 40, bottom: 20),
                                    child: Text(
                                      "Announcements",
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600),
                                    )),
                                BlocBuilder<AdminCubit, AdminCubitStates>(
                                    builder: (context, state) {
                                  if (AdminCubit.get(context).announcements ==
                                      null) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  } else {
                                    var anonuncmentsss = AdminCubit.get(context).announcements;

                                    return CarouselSlider(
                                      items: anonuncmentsss!.isEmpty
                                          ? [
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                ),
                                                child: Image.asset(
                                                    height: 600,
                                                    width: double.infinity,
                                                    fit: BoxFit.cover,
                                                    "images/th.png"),
                                              )
                                            ]
                                          : anonuncmentsss.map((anonuncments) {
                                              return Stack(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top: 5),
                                                      clipBehavior:
                                                          Clip.antiAlias,
                                                      // margin: const EdgeInsets.all(6.0),
                                                      // child: Image.asset("images/332573639_735780287983011_1562632886952931410_n.jpg",width: 400,height: 400,fit: BoxFit.cover,),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15.0),
                                                        // image: DecorationImage(
                                                        //   image: AssetImage(
                                                        //     carsor.image ?? "images/llogo.jfif",
                                                        //   ),
                                                        //   fit: BoxFit.cover,
                                                        // ),
                                                      ),
                                                      child: Image.network(
                                                        anonuncments.image,
                                                        width: 400,
                                                        height: 250,
                                                        fit: BoxFit.fitWidth,
                                                      ),
                                                    ),
                                                    Container(
                                                      width: double.infinity,
                                                      height: double
                                                          .infinity, // Adjust height as needed
                                                      decoration: BoxDecoration(
                                                        gradient:
                                                            LinearGradient(
                                                          colors: [
                                                            Colors.transparent,
                                                            Colors.transparent,
                                                            Colors.transparent,
                                                            Colors.black.withOpacity(0.3),
                                                            Colors.black.withOpacity(0.6),
                                                          ],
                                                          begin: Alignment
                                                              .topCenter,
                                                          end: Alignment
                                                              .bottomCenter,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 30,
                                                              vertical: 10),
                                                      child: Align(
                                                        alignment: Alignment
                                                            .bottomLeft,
                                                        child: Text(
                                                          anonuncments.title,
                                                          style: TextStyle(
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ),
                                                    ),
                                                  ]);
                                            }).toList(),
                                      options: CarouselOptions(
                                        height: 200.0,
                                        autoPlay: true,
                                        enlargeCenterPage: true,
                                        aspectRatio: 16 / 9,
                                        autoPlayCurve: Curves.fastOutSlowIn,
                                        enableInfiniteScroll:
                                            anonuncmentsss.length < 5
                                                ? false
                                                : true,
                                        autoPlayInterval:
                                            const Duration(seconds: 4),
                                        autoPlayAnimationDuration:
                                            const Duration(milliseconds: 800),
                                        viewportFraction:
                                            anonuncmentsss.isEmpty ? 1 : 0.8,
                                      ),
                                    );
                                  }
                                }),
                                const SizedBox(height: 20),
                                Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: divider()),
                                const SizedBox(height: 20),
                                Container(
                                    margin: EdgeInsets.only(left: 40),
                                    child: Text(
                                      "Subjects",
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600),
                                    )),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: GridView.builder(
                                    physics: const NeverScrollableScrollPhysics(), // Disable scrolling in the GridView
                                    shrinkWrap: true, // Shrink the GridView to fit its content
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2, // Two items per row
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                    ),
                                    itemCount: semesters[semesterIndex!]
                                        .subjects
                                        .length,
                                    itemBuilder: (context, index) {
                                      return subjectItemBuild(
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
                      ),
              );
      }),
    );
  }
}

Widget CustomDrawer(context, semester) {
  // final SelectedSemester = "Three";
  // print(SelectedSemester.toString() + "Drawer ");
  ProfileModel? profileModel;
  double width = screenWidth(context);
  if (TOKEN != null) profileModel = MainCubit.get(context).profileModel;

  return Drawer(
    backgroundColor: isDark ? Colors.black : Colors.white,
    width: width < 600 ? width / 1.5 : width / 2.5,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TOKEN != null
            ? UserAccountsDrawerHeader(
                otherAccountsPictures: [
                  IconButton(
                      onPressed: () {
                        print(isDark);
                        // Navigator.pop(context);
                        navigatReplace(context, Home());
                        Provider.of<ThemeProvide>(context, listen: false)
                            .changeMode();
                      },
                      icon: Icon(
                        isDark ? Icons.light_mode : Icons.dark_mode,
                        color: !isDark ? Colors.black : Colors.white,
                      ))
                ],
                decoration: BoxDecoration(color: const Color.fromARGB(255, 20, 130, 220)),
                accountName: Row(
                  children: [
                    Text(
                      profileModel!.name,
                      style: const TextStyle(overflow: TextOverflow.ellipsis),
                    ),
                    const Spacer(),
                    Text(Level(profileModel.semester)),
                    const SizedBox(
                      width: 10,
                    )
                  ],
                ),
                // accountEmail: Text("2nd year "),
                accountEmail: Container(
                  margin: EdgeInsets.zero, // Remove any margin
                  padding: EdgeInsets.zero, // Remove any padding
                  child: Container(
                    margin: EdgeInsets.only(top: 5),
                    child: GestureDetector(
                      onTap: () => navigate(context, const Profile()),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            "images/profile.png",
                            width: 20,
                            height: 20,
                          ),
                          SizedBox(width: 10),
                          Text("Profile info"),
                        ],
                      ),
                    ),
                  ),
                ),
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
              )
            : UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: HexColor('#4764C5')),
                // accountName: Text(""),
                // accountEmail: Text("2nd year "),
                accountName: const Text("Guest"),
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
                  IconButton(
                      onPressed: () {
                        print(isDark);
                        Navigator.pop(context);
                        Provider.of<ThemeProvide>(context, listen: false).changeMode();
                      },
                      icon: Icon(
                        isDark ? Icons.light_mode : Icons.dark_mode,
                        color: !isDark ? Colors.black : Colors.white,
                      ))
                ],
              ),
        Expanded(
          child: SingleChildScrollView(
              child: Container(
            child: Column(
              children: [
                if (profileModel?.role == "ADMIN")
                  ListTile(
                    leading: const Icon(Icons.admin_panel_settings),
                    title: const Text("Admin"),
                    onTap: () {
                      navigatReplace(context, AdminPanel());
                    },
                  ),
                ListTile(
                  leading: Icon(Icons.announcement),
                  title: Text("Announcements"),
                  onTap: () {
                    if (TOKEN == null) {
                      navigate(context,
                          AnnouncementsList(semester: SelectedSemester!));
                    } else {
                      navigate(
                          context,
                          AnnouncementsList(
                              semester: MainCubit.get(context)
                                  .profileModel!
                                  .semester));
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.leaderboard),
                  title: const Text('Leaderboard'),
                  onTap: () {
                    navigate(
                        context,
                        LeaderboardScreen(
                          semester: semester,
                        ));
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
                            navigate(context,
                                const SemesterNavigate(semester: "One"));
                          },
                        ),
                        ListTile(
                          title: const Text("Second Semester"),
                          onTap: () {
                            // MainCubit.get(context).profileModel = null;
                            // TOKEN = null;
                            navigate(context,
                                const SemesterNavigate(semester: "Two"));
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
                            navigate(context,
                                const SemesterNavigate(semester: "Three"));
                          },
                        ),
                        ListTile(
                          title: const Text("Second Semester"),
                          onTap: () {
                            // MainCubit.get(context).profileModel = null;
                            // TOKEN = null;
                            navigate(context,
                                const SemesterNavigate(semester: "Four"));
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
                            navigate(context,
                                const SemesterNavigate(semester: "Five"));
                          },
                        ),
                        ListTile(
                          title: const Text("Second Semester"),
                          onTap: () {
                            // MainCubit.get(context).profileModel = null;
                            // TOKEN = null;
                            navigate(context,
                                const SemesterNavigate(semester: "Six"));
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
                              navigate(context,
                                  const SemesterNavigate(semester: "One"));
                            },
                          ),
                          ListTile(
                            title: const Text("Second Semester"),
                            onTap: () {
                              // MainCubit.get(context).profileModel = null;
                              // TOKEN = null;
                              navigate(context,
                                  const SemesterNavigate(semester: "Two"));
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                ExpansionTile(
                  leading: Image.asset(
                    "images/mingcute_drive-fill.png",
                    width: 25,
                    height: 25,
                    color: !isDark ? Colors.black : Colors.white70,
                  ),
                  title: const Text("Drive"),
                  children: [
                    ListTile(
                      title: const Text("2028"),
                      onTap: () async {
                        LinkableElement url = LinkableElement('drive',
                            'https://drive.google.com/drive/folders/1TOj0c-vFblz4guLuRa4VQ56rq4kIuvDQ?fbclid=IwZXh0bgNhZW0CMTAAAR1l30on7Dhr4yV7aM4wyoAsCKsXqHWlJlhG1220oij8ae5SIy3vYLdogPY_aem_gjZq7IZHltbC53_jmnI7KQ');
                        await onOpen(context, url);
                      },
                    ),
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
                ExpansionTile(
                  leading: Icon(Icons.support_agent),
                  title: Text('Support'),
                  children: [
                    ListTile(
                      title: const Text('Report Bug'),
                      onTap: () {
                        navigate(context, ReportBug());
                      },
                    ),
                    ListTile(
                      title: const Text('Feedback'),
                      onTap: () {
                        navigate(context, FeedbackScreen());
                      },
                    ),
                  ],
                ),
                ListTile(
                  leading: const Icon(Icons.group),
                  title: const Text("About Us"),
                  onTap: () {
                    navigate(context, AboutUs());
                  },
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  // padding: EdgeInsets.all(5),
                  width: 150,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: TOKEN != null ? Colors.red : Colors.green),
                  child: TOKEN != null
                      ? InkWell(
                          onTap: () {
                            AwesomeDialog(
                              context: context,
                              title: "Log Out",
                              dialogType: DialogType.warning,
                              body: Text(
                                "Are you sure you want to log out?",
                                style: TextStyle(fontSize: 17),
                              ),
                              animType: AnimType.rightSlide,
                              btnOkColor: Colors.red,
                              btnCancelOnPress: () {},
                              btnOkText: "Log Out",
                              btnCancelColor: Colors.grey,

                              // titleTextStyle: TextStyle(fontSize: 22),
                              btnOkOnPress: () {
                                MainCubit.get(context).logout(context);
                                Provider.of<ThemeProvide>(context,
                                        listen: false)
                                    .changeMode(dontWannaDark: true);
                                Provider.of<ThemeProvide>(context,
                                        listen: false)
                                    .notifyListeners();
                              },
                            ).show();
                          },
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.logout,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                const Text(
                                  "Log out",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 17),
                                ),
                              ]),
                        )
                      : GestureDetector(
                          onTap: () => navigate(context, LoginScreen()),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.login,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                const Text(
                                  "Log in",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 17),
                                ),
                              ]),
                        ),
                ),
              ],
            ),
          )),
        ),
      ],
    ),
  );
}

String Level(String semester) {
  switch (semester) {
    case "One":
    case "Two":
      return "First Level";

    case "Three":
    case "Four":
      return "Second Level";

    case "Five":
    case "Six":
      return "Third Level";

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
              color: isDark
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
              color: !isDark
                  ? const Color.fromARGB(188, 92, 38, 38)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.light_mode,
                  color: !isDark ? Colors.white : Colors.black,
                ),
                const SizedBox(width: 8),
                Text(
                  'Light',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
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
  return BlocProvider(
    create: (context) => SubjectCubit(),
    child: GestureDetector(
      onTap: () {
        navigate(
            context,
            SubjectDetails(subjectName: subject.subjectName,));
      },
      child: Card(
        
        elevation: 12.0, // More elevation for depth
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        clipBehavior: Clip.antiAlias,
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: isDark ? Color(0xff5A5B5F) :  Color.fromARGB(255, 20, 130, 220)
              // image: DecorationImage(
              //   colorFilter: const ColorFilter.mode(
              //       Color(0xfff39c12), BlendMode.dstIn),
              //   image: subject.subjectName == "Data Mining"
              //       ? AssetImage("images/data-mining_cleanup.webp")
              //       : NetworkImage(subject.subjectImage),
              //   fit: BoxFit.cover,
              // ),
              ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(subject.subjectImage, height: 70, color: Colors.white),
              SizedBox(
                height: 10,
              ),
              Text(
                textAlign: TextAlign.center,
                subject.subjectName.replaceAll('_', " ").replaceAll("and", "&"),
                maxLines: 2,
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

// class CarsorModel {
//   String? image;
//   String? text;
//   CarsorModel({this.image, this.text});
// }

// List<CarsorModel> carsor = [
//   CarsorModel(
//       image: "images/140.jpg", text: "Latest Of Academic Schedule \"9-17\" "),
//   CarsorModel(
//       image: "images/332573639_735780287983011_1562632886952931410_n.jpg",
//       text:
//           "RoboTech summers training application form opens today at 9:00 pm! Be ready "),
//   CarsorModel(
//       image: "images/338185486_3489006871419356_4868524435440167213_n.jpg",
//       text:
//           "Cyberus summers training application form opens today at 9:00 pm! Be ready "),
// ];
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