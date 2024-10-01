import 'dart:ui';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:linkify/linkify.dart';
import 'package:lol/layout/admin_panel/admin_panal.dart';
import 'package:lol/layout/home/bloc/main_cubit.dart';
import 'package:lol/layout/home/bloc/main_cubit_states.dart';
import 'package:lol/layout/home/home.dart';
import 'package:lol/layout/profile/profile.dart';
import 'package:lol/modules/admin/screens/announcements/announcements_list.dart';
import 'package:lol/modules/auth/screens/login.dart';
import 'package:lol/shared/components/navigation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'constants.dart';
import '../../modules/webview/webview_screen.dart';

Widget adminTopTitleWithDrawerButton(
    {scaffoldKey,
    required String title,
    double size = 40,
    required bool hasDrawer,
    double bottomPadding = 15}) {
  return Padding(
    padding: EdgeInsetsDirectional.only(bottom: bottomPadding),
    child: Row(
      children: [
        Expanded(
          flex: 15,
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 20.0),
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white, fontSize: size),
              textAlign: TextAlign.start,
            ),
          ),
        ),
        const Spacer(),
        if (hasDrawer)
          ElevatedButton(
            onPressed: () {
              scaffoldKey.currentState?.openDrawer();
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: 5, vertical: 5),
              backgroundColor: Colors.pinkAccent,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50), // Create semi-circle effect
                  topRight: Radius.circular(0), // Create semi-circle effect
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(0),
                ),
              ),
            ),
            child: const Icon(
              Icons.menu,
              color: Colors.white,
              size: 40,
            ),
          ),
      ],
    ),
  );
}

Widget drawerBuilder(context) {
  return Drawer(
    width: screenWidth(context) / 1.5,
    backgroundColor: Colors.cyan,
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        const SizedBox(
          height: 70,
        ),
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text('Option1'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Option2'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}

Widget backgroundEffects() {
  return Stack(
    children: [
      Positioned(
        top: -30,
        left: -100,
        child: Container(
          width: 400,
          height: 400,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                HexColor('9F53B9').withOpacity(0.45),
                HexColor('AB29E8').withOpacity(0.15),
                Colors.black.withOpacity(0.05)
              ],
              radius: 0.85,
              center: const Alignment(-0.3, -0.3),
            ),
          ),
        ),
      ),
      //Bottom Right circle
      Positioned(
        bottom: -150,
        right: -100,
        child: Container(
          width: 400,
          height: 400,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                Colors.purpleAccent.withOpacity(0.6),
                Colors.black.withOpacity(0.2),
              ],
              radius: 0.75,
              center: const Alignment(0.2, 0.2),
            ),
          ),
        ),
      ),
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: Container(
          color: Colors.black.withOpacity(0), // Transparent layer for blur
        ),
      ),
    ],
  );
}

Widget backButton(context, {double bottomPadding = 8}) {
  return Padding(
    padding: EdgeInsets.only(bottom: bottomPadding),
    child: Row(
      children: [
        MaterialButton(
          onPressed: () {
            Navigator.pop(context);
          },
          padding: EdgeInsets.zero,
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30,
          ),
        ),
      ],
    ),
  );
}

Widget divider() {
  return Container(
    height: 2,
    width: double.infinity,
    color: Colors.grey,
  );
}

void showToastMessage({
  required String message,
  Color textColor = Colors.white,
  required ToastStates states,
  double fontSize = 16,
  gravity = ToastGravity.BOTTOM,
  int lengthForIOSAndWeb = 5,
  toastLength = Toast.LENGTH_SHORT,
}) =>
    Fluttertoast.showToast(
      msg: message,
      toastLength: toastLength,
      gravity: gravity,
      timeInSecForIosWeb: lengthForIOSAndWeb,
      backgroundColor: chooseToastColor(states),
      textColor: textColor,
      fontSize: fontSize,
    );

enum ToastStates { SUCCESS, ERROR, WARNING, INFO }

Color chooseToastColor(ToastStates states) {
  Color? color;
  switch (states) {
    case ToastStates.SUCCESS:
      color = Colors.green[600];
      break;
    case ToastStates.WARNING:
      color = Colors.amber[600];
      break;
    case ToastStates.ERROR:
      color = Colors.red[600];
      break;
    case ToastStates.INFO:
      color = Colors.grey[600];
      break;
  }
  return color!;
}

String getYouTubeThumbnail(String videoUrl) {
  final Uri uri = Uri.parse(videoUrl);
  String videoId = "";

  if (uri.host.contains('youtu.be')) {
    videoId = uri.pathSegments.first;
  } else if (uri.queryParameters.containsKey('v')) {
    videoId = uri.queryParameters['v']!;
  }
  return 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';
}

Future<void> onOpen(BuildContext context, LinkableElement link) async {
  final url = link.url;

  // Check if the link is a Facebook link
  if (url.contains('facebook.com') ||
      url.contains('drive.google.com') ||
      url.contains('web.microsoftstream.com')) {
    // Open Facebook links directly using `url_launcher`
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      navigate(context, WebviewScreen(url));
    }
  } else {
    // For other links, open them using WebView
    navigate(context, WebviewScreen(url));

    // launchUrl(Uri.parse(link.url));
  }
}

// SelectedSemester = "One";

// Widget CustomDrawer(context,
//     {required name,
//     required semester,
//     required photo,
//     required role,
//     required logout}) {
//   return Drawer(
//     width: screenWidth(context) / 1.3,
//     child: SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           TOKEN != null
//               ? GestureDetector(
//                   onTap: () {
//                     print("sdfsd");
//                   },
//                   child: UserAccountsDrawerHeader(
//                     decoration: BoxDecoration(color: Color(0xff0F4C75)),
//                     accountName: Row(
//                       children: [
//                         Text(
//                           name,
//                           style: TextStyle(overflow: TextOverflow.clip),
//                         ),
//                         Spacer(),
//                         Text(Level(semester)),
//                         SizedBox(
//                           width: 10,
//                         )
//                       ],
//                     ),
//                     // accountEmail: Text("2nd year "),
//                     accountEmail: TextButton(
//                         style: TextButton.styleFrom(
//                           padding: EdgeInsets.zero,
//                           minimumSize: Size(0, 0),
//                           tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                         ),
//                         onPressed: () => navigate(context, Profile()),
//                         child: Text(
//                           "Profile info",
//                           style: TextStyle(color: Colors.orange),
//                         )),
//                     currentAccountPicture: ClipOval(
//                       child: Image.network(
//                         photo,
//                         width: 30,
//                         height: 30,
//                         fit: BoxFit.cover,
//                       ),
//                       // backgroundImage: NetworkImage(profileModel.photo),
//                     ),
//                     // otherAccountsPictures: [
//                     //   Icon(Icons.info, color: Colors.white),
//                     // ],
//                   ),
//                 )
//               : GestureDetector(
//                   onTap: () {
//                     print("sdfsd");
//                   },
//                   child: UserAccountsDrawerHeader(
//                     decoration: BoxDecoration(color: Color(0xff0F4C75)),
//                     // accountName: Text(""),
//                     // accountEmail: Text("2nd year "),
//                     accountName: Text(""),
//                     accountEmail: Text(
//                       Level(SelectedSemester!),
//                       style: TextStyle(fontSize: 20),
//                     ),
//                     // accountEmail:InkWell(
//                     //   child: Ink(
//                     //     child: Text(
//                     //       // style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
//                     //       // onPressed: () {
//                     //       //   Navigator.push(
//                     //       //       context,
//                     //       //       MaterialPageRoute(
//                     //       //           builder: (context) => const LoginScreen()));
//                     //       // },
//                     //       // child: const Text(
//                     //         "Login",
//                     //         style: TextStyle(color: Colors.white),
//
//                     //     ),
//                     //   ),
//                     // ) ,
//                     currentAccountPicture: CircleAvatar(
//                       backgroundImage: NetworkImage(
//                           "https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg"),
//                     ),
//                     otherAccountsPictures: [
//                       InkWell(
//                         onTap: () => navigatReplace(context, LoginScreen()),
//                         child: Ink(
//                           child: Text(
//                             // style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
//                             // onPressed: () {
//                             //   Navigator.push(
//                             //       context,
//                             //       MaterialPageRoute(
//                             //           builder: (context) => const LoginScreen()));
//                             // },
//                             // child: const Text(
//                             "Login",
//                             style: TextStyle(
//                               color: Colors.orange,
//                               fontSize: 15,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//           ListTile(
//             leading: Icon(Icons.announcement),
//             title: Text("Announcements"),
//             onTap: () {
//               navigate(context, AnnouncementsList());
//             },
//           ),
//           ExpansionTile(
//             leading: Icon(Icons.school),
//             title: Text("Years"),
//             children: [
//               ExpansionTile(
//                 title: Text("First Year"),
//                 children: [
//                   ListTile(title: Text("First Semester")),
//                   ListTile(title: Text("Second Semester")),
//                 ],
//               ),
//               ExpansionTile(
//                 title: Text("Second Year"),
//                 children: [
//                   ListTile(title: Text("First Semester")),
//                   ListTile(title: Text("Second Semester")),
//                 ],
//               ),
//             ],
//           ),
//           ExpansionTile(
//             leading: Icon(Icons.drive_file_move),
//             title: Text("Drive"),
//             children: [
//               ListTile(
//                 title: Text("2027"),
//                 onTap: () async {
//                   LinkableElement url = LinkableElement('drive',
//                       'https://drive.google.com/drive/folders/1-1_Ef2qF0_rDzToD4OlqIl5xubgpMGU0');
//                   await onOpen(context, url);
//                 },
//               ),
//               ListTile(
//                 title: Text("2026"),
//                 onTap: () async {
//                   LinkableElement url = LinkableElement('drive',
//                       'https://drive.google.com/drive/folders/1CdZDa3z97RN_yRjFlC7IAcLfmw6D1yLy');
//                   await onOpen(context, url);
//                 },
//               ),
//               ListTile(
//                 title: Text("2025"),
//                 onTap: () async {
//                   LinkableElement url = LinkableElement('drive',
//                       'https://drive.google.com/drive/folders/1BAXez9FJKF_ASx79usd_-Xi47TdUYK73?fbclid=IwAR3cRtEV1aJrcvKoGNBLCbqBu2LMLrsWYfQkOZUb6SQE2dtT3ZtqrcCjxno');
//                   await onOpen(context, url);
//                 },
//               ),
//               ListTile(
//                 title: Text("2024"),
//                 onTap: () async {
//                   LinkableElement url = LinkableElement('drive',
//                       'https://drive.google.com/drive/u/0/folders/11egB46e3wtl1Q69wdCBBam87bwMF7Qo-');
//                   await onOpen(context, url);
//                 },
//               ),
//             ],
//           ),
//           ListTile(
//             leading: Icon(Icons.group),
//             title: Text("About Us"),
//             onTap: () {},
//           ),
//           if (role == "ADMIN")
//             ListTile(
//               leading: Icon(Icons.admin_panel_settings),
//               title: Text("Admin"),
//               onTap: () {
//                 navigate(context, AdminPanal());
//               },
//             ),
//           if (TOKEN != null)
//             ListTile(
//                 leading: Icon(Icons.logout, color: Colors.red),
//                 title: Text(
//                   "Log out",
//                   style: TextStyle(color: Colors.red),
//                 ),
//                 onTap: logout),
//           SizedBox(
//             height: screenHeight(context) / 5,
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: DarkLightModeToggle(context),
//           ),
//         ],
//       ),
//     ),
//   );
// }
