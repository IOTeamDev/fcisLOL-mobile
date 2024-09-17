import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lol/admin/screens/add_anouncment.dart';
import 'package:lol/admin/screens/requests.dart';
import 'package:lol/constants/constants.dart';
import 'package:lol/main.dart';
import 'package:lol/shared/components/components.dart';
import 'package:lol/utilities/navigation.dart';

class AdminPanal extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: Drawer(
        width: screenWidth(context) / 1.5,
        backgroundColor: Colors.cyan,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 70,
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Profile'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
      //appBar: AppBar(elevation: 20, shadowColor: Colors.black, backgroundColor: Colors.black, title: Text('Admin', style: TextStyle(color: Colors.white),),),
      body: Stack(children: [
        //Top Left Circle
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
                center: Alignment(0.2, 0.2),
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
        Container(
          margin: EdgeInsetsDirectional.only(top: 50),
          width: double.infinity,
          child: Column(
            children: [
              //Back Button
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    MaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 30,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
              //Text With Drawer Button
              adminTopTitleWithDrawerButton(scaffoldKey, 'Admin', 40),
              //Buttons
              Container(
                width: double.infinity,
                margin: EdgeInsetsDirectional.symmetric(horizontal: 30),
                height: 260,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            navigate(context, AddAnouncment());
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero, // Remove default padding
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            minimumSize: const Size(
                                250, 125), // Set width and height of the button
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
                              width:
                                  250, // Ensure the width matches the button size
                              height:
                                  125, // Ensure the height matches the button size
                              alignment: Alignment.center, // Center the text
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
                    Spacer(),
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
                            minimumSize: const Size(
                                250, 125), // Set width and height of the button
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
                              width:
                                  250, // Ensure the width matches the button size
                              height:
                                  125, // Ensure the height matches the button size
                              alignment: Alignment.center, // Center the text
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
              Spacer(),
              Container(
                  width: double.infinity,
                  height: 300,
                  child: Image(
                    image: AssetImage('images/admin/background_admin.png'),
                    fit: BoxFit.fitWidth,
                  )),
            ],
          ),
        ),
      ]),
    );
  }
}
