import 'package:flutter/material.dart';
import 'package:lol/modules/admin/screens/Announcements/add_announcement.dart';
import 'package:lol/modules/admin/screens/requests/requests.dart';
import 'package:lol/shared/components/constants.dart';
import 'package:lol/shared/components/components.dart';
import 'package:lol/shared/components/navigation.dart';

class AdminPanal extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  AdminPanal({super.key});

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
            const SizedBox(height: 70),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
      body: Stack(children: [
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
                  scaffoldKey: scaffoldKey,
                  title: 'Admin',
                  hasDrawer: true,
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
  }
}
