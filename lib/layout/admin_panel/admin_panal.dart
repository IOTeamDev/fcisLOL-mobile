import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkify/linkify.dart';
import 'package:lol/layout/home/bloc/main_cubit.dart';
import 'package:lol/layout/home/bloc/main_cubit_states.dart';
import 'package:lol/modules/admin/bloc/admin_cubit.dart';
import 'package:lol/modules/admin/bloc/admin_cubit_states.dart';
import 'package:lol/modules/admin/screens/Announcements/add_announcement.dart';
import 'package:lol/modules/admin/screens/requests/requests.dart';
import 'package:lol/shared/components/constants.dart';
import 'package:lol/shared/components/components.dart';
import 'package:lol/shared/components/navigation.dart';

import '../../modules/admin/screens/announcements/announcements_list.dart';
import '../../modules/auth/screens/login.dart';
import '../home/home.dart';
import '../profile/profile.dart';

class AdminPanal extends StatelessWidget {

  AdminPanal({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainCubitStates>(
      listener: (context, state) {},
      builder:(context, state) {
        return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
          backgroundEffects(),
          Container(
            margin: const EdgeInsetsDirectional.only(top: 50),
            width: double.infinity,
            child: Column(
              children: [
                // Back Button
                backButton(context),
                // Text With Drawer Button
                adminTopTitleWithDrawerButton(
                    title: 'Admin',
                    hasDrawer: false,
                    bottomPadding: 50),
                // Buttons
                Container(
                  width: double.infinity,
                  margin: const EdgeInsetsDirectional.symmetric(horizontal: 30),
                  height: 260,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              navigate(context, const AddAnouncment());
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero, // Remove default padding
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              minimumSize: const Size(250, 125),
                            ),
                            child: Ink(
                              decoration: BoxDecoration(
                                image: const DecorationImage(
                                  image: AssetImage('images/admin/Frame 4.png'),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Container(
                                width: 250,
                                height: 125,
                                alignment: Alignment.center,
                                child: const Text(
                                  'Announcements',
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              navigate(context, Requests());
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero, // Remove default padding
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              minimumSize: const Size(250, 125),
                            ),
                            child: Ink(
                              decoration: BoxDecoration(
                                image: const DecorationImage(
                                  image: AssetImage('images/admin/Frame 2.png'),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Container(
                                width: 250,
                                height: 125,
                                alignment: Alignment.center,
                                child: const Text(
                                  'Requests',
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                const SizedBox(
                  width: double.infinity,
                  height: 300,
                  child: Image(
                    image: AssetImage('images/admin/background_admin.png'),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ],
            ),
          ),
        ]),
      );
      },
    );
  }
}

// class CustomDrawer extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // SelectedSemester = "One";
//
//     var profileModel = MainCubit.get(context).profileModel;
//     return Drawer(
//       width: screenWidth(context) / 1.3,
//       child: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TOKEN != null
//                 ? GestureDetector(
//               onTap: () {
//                 print("sdfsd");
//               },
//               child: UserAccountsDrawerHeader(
//                 decoration: BoxDecoration(color: Color(0xff0F4C75)),
//                 accountName: Row(
//                   children: [
//                     Text(
//                       profileModel!.name,
//                       style: TextStyle(overflow: TextOverflow.clip),
//                     ),
//                     Spacer(),
//                     Text(Level(profileModel.semester)),
//                     SizedBox(
//                       width: 10,
//                     )
//                   ],
//                 ),
//                 // accountEmail: Text("2nd year "),
//                 accountEmail: TextButton(
//                     style: TextButton.styleFrom(
//                       padding: EdgeInsets.zero,
//                       minimumSize: Size(0, 0),
//                       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                     ),
//                     onPressed: () => navigate(context, Profile()),
//                     child: Text(
//                       "Profile info",
//                       style: TextStyle(color: Colors.orange),
//                     )),
//                 currentAccountPicture: ClipOval(
//                   child: Image.network(
//                     profileModel.photo,
//                     width: 30,
//                     height: 30,
//                     fit: BoxFit.cover,
//                   ),
//                   // backgroundImage: NetworkImage(profileModel.photo),
//                 ),
//                 // otherAccountsPictures: [
//                 //   Icon(Icons.info, color: Colors.white),
//                 // ],
//               ),
//             )
//                 : GestureDetector(
//               onTap: () {
//                 print("sdfsd");
//               },
//               child: UserAccountsDrawerHeader(
//                 decoration: BoxDecoration(color: Color(0xff0F4C75)),
//                 // accountName: Text(""),
//                 // accountEmail: Text("2nd year "),
//                 accountName: Text(""),
//                 accountEmail: Text(
//                   Level(SelectedSemester!),
//                   style: TextStyle(fontSize: 20),
//                 ),
//                 // accountEmail:InkWell(
//                 //   child: Ink(
//                 //     child: Text(
//                 //       // style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
//                 //       // onPressed: () {
//                 //       //   Navigator.push(
//                 //       //       context,
//                 //       //       MaterialPageRoute(
//                 //       //           builder: (context) => const LoginScreen()));
//                 //       // },
//                 //       // child: const Text(
//                 //         "Login",
//                 //         style: TextStyle(color: Colors.white),
//
//                 //     ),
//                 //   ),
//                 // ) ,
//                 currentAccountPicture: CircleAvatar(
//                   backgroundImage: NetworkImage(
//                       "https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg"),
//                 ),
//                 otherAccountsPictures: [
//                   InkWell(
//                     onTap: () => navigatReplace(context, LoginScreen()),
//                     child: Ink(
//                       child: Text(
//                         // style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
//                         // onPressed: () {
//                         //   Navigator.push(
//                         //       context,
//                         //       MaterialPageRoute(
//                         //           builder: (context) => const LoginScreen()));
//                         // },
//                         // child: const Text(
//                         "Login",
//                         style: TextStyle(
//                           color: Colors.orange,
//                           fontSize: 15,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             ListTile(
//               leading: Icon(Icons.announcement),
//               title: Text("Announcements"),
//               onTap: () { navigate(context, AnnouncementsList());},
//             ),
//             ExpansionTile(
//               leading: Icon(Icons.school),
//               title: Text("Years"),
//               children: [
//                 ExpansionTile(
//                   title: Text("First Year"),
//                   children: [
//                     ListTile(title: Text("First Semester")),
//                     ListTile(title: Text("Second Semester")),
//                   ],
//                 ),
//                 ExpansionTile(
//                   title: Text("Second Year"),
//                   children: [
//                     ListTile(title: Text("First Semester")),
//                     ListTile(title: Text("Second Semester")),
//                   ],
//                 ),
//               ],
//             ),
//             ExpansionTile(
//               leading: Icon(Icons.drive_file_move),
//               title: Text("Drive"),
//               children: [
//                 ListTile(
//                   title: Text("2027"),
//                   onTap: () async {
//                     LinkableElement url = LinkableElement('drive',
//                         'https://drive.google.com/drive/folders/1-1_Ef2qF0_rDzToD4OlqIl5xubgpMGU0');
//                     await onOpen(context, url);
//                   },
//                 ),
//                 ListTile(
//                   title: Text("2026"),
//                   onTap: () async {
//                     LinkableElement url = LinkableElement('drive',
//                         'https://drive.google.com/drive/folders/1CdZDa3z97RN_yRjFlC7IAcLfmw6D1yLy');
//                     await onOpen(context, url);
//                   },
//                 ),
//                 ListTile(
//                   title: Text("2025"),
//                   onTap: () async {
//                     LinkableElement url = LinkableElement('drive',
//                         'https://drive.google.com/drive/folders/1BAXez9FJKF_ASx79usd_-Xi47TdUYK73?fbclid=IwAR3cRtEV1aJrcvKoGNBLCbqBu2LMLrsWYfQkOZUb6SQE2dtT3ZtqrcCjxno');
//                     await onOpen(context, url);
//                   },
//                 ),
//                 ListTile(
//                   title: Text("2024"),
//                   onTap: () async {
//                     LinkableElement url = LinkableElement('drive',
//                         'https://drive.google.com/drive/u/0/folders/11egB46e3wtl1Q69wdCBBam87bwMF7Qo-');
//                     await onOpen(context, url);
//                   },
//                 ),
//               ],
//             ),
//             ListTile(
//               leading: Icon(Icons.group),
//               title: Text("About Us"),
//               onTap: () {},
//             ),
//             if (profileModel!.role == "ADMIN")
//               ListTile(
//                 leading: Icon(Icons.admin_panel_settings),
//                 title: Text("Admin"),
//                 onTap: () {navigate(context, AdminPanal());},
//               ),
//             if (TOKEN != null)
//               ListTile(
//                 leading: Icon(Icons.logout, color: Colors.red),
//                 title: Text(
//                   "Log out",
//                   style: TextStyle(color: Colors.red),
//                 ),
//                 onTap: () {
//                   MainCubit.get(context).logout(context);
//                 },
//               ),
//             SizedBox(
//               height: screenHeight(context) / 5,
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: DarkLightModeToggle(context),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
