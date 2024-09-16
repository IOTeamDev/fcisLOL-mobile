import 'dart:ui';

import 'package:flutter/material.dart';

import '../../constants/constants.dart';

Widget adminTopTitleWithDrawerButton(scaffoldKey, String title, double size)
{
  return  Padding(
    padding: const EdgeInsetsDirectional.only(bottom: 15.0),
    child: Row(
      children: [
        Padding(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 20.0),
          child: Text('$title', style: TextStyle(color: Colors.white, fontSize: size),),
        ),
        const Spacer(),
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
        )
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
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                Colors.deepPurpleAccent.withOpacity(0.7),
                Colors.black.withOpacity(0.2),
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

Widget divider()
{
  return  Container(height: 2, width: double.infinity, color: Colors.grey,);
}