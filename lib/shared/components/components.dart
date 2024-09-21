import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:linkify/linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/constants.dart';
import '../../main/screens/webview_screen.dart';

Widget adminTopTitleWithDrawerButton({scaffoldKey, required String title, double size = 40, required bool hasDrawer, double bottomPadding = 15})
{
  return  Padding(
    padding: EdgeInsetsDirectional.only(bottom: bottomPadding),
    child: Row(
      children: [
        Padding(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 20.0),
          child: Text('$title', style: TextStyle(color: Colors.white, fontSize: size),textAlign: TextAlign.start,),
        ),
        const Spacer(),
        if(hasDrawer)
        ElevatedButton(
          onPressed: ()
          {
            scaffoldKey.currentState!.openDrawer();
          },
          child: Icon(Icons.menu, color: Colors.white, size: 40,),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsetsDirectional.symmetric(horizontal: 5, vertical: 5),
            backgroundColor: Colors.pinkAccent,
            shape:RoundedRectangleBorder
              (
              borderRadius: BorderRadius.only
                (
                topLeft: Radius.circular(50), // Create semi-circle effect
                topRight: Radius.circular(0), // Create semi-circle effect
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(0),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget drawerBuilder(context)
{
  return Drawer(
    width: screenWidth(context) / 1.5,
    backgroundColor: Colors.cyan,

    child: ListView(

      padding: EdgeInsets.zero,
      children:
      [
        SizedBox(height: 70,),
        ListTile(
          leading: Icon(Icons.home),
          title: Text('Option1'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text('Option2'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}

Widget backgroundEffects()
{
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
              center: Alignment(-0.3, -0.3),
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

Widget backButton(context, {double bottomPadding = 8})
{
  return  Padding(
    padding: EdgeInsets.only(bottom: bottomPadding),
    child: Row(
      children:
      [
        MaterialButton(onPressed: () {
          Navigator.pop(context);
        },
          child: Icon(Icons.arrow_back, color: Colors.white, size: 30,),
          padding: EdgeInsets.zero,),
      ],
    ),
  );
}

Widget divider()
{
  return  Container(height: 2, width: double.infinity, color: Colors.grey,);
}

void showToastMessage({
  @required String? message,
  Color textColor = Colors.white,
  @required ToastStates? states,
  double fontSize = 16,
  gravity = ToastGravity.BOTTOM,
  int lengthForIOSAndWeb = 5,
  toastLength = Toast.LENGTH_LONG,
}) =>   Fluttertoast.showToast
  (
  msg: message!,
  toastLength: toastLength,
  gravity: gravity,
  timeInSecForIosWeb: lengthForIOSAndWeb,
  backgroundColor: chooseToastColor(states!),
  textColor: textColor,
  fontSize: fontSize,
);

enum ToastStates{SUCCESS, ERROR, WARNING}

Color chooseToastColor(ToastStates states)
{
  Color? color;
  switch(states)
  {
    case ToastStates.SUCCESS:
      color = Colors.green[600];
      break;
    case ToastStates.WARNING:
      color = Colors.amber[600];
      break;
    case ToastStates.ERROR:
      color = Colors.red[600];
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
  if (url.contains('facebook.com')) {
    // Open Facebook links directly using `url_launcher`
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  } else {
    // For other links, open them using WebView
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebviewScreen(url),
      ),
    );
  }
}