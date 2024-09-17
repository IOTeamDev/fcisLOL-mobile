import 'dart:ui';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lol/auth/screens/login.dart';
import 'package:lol/constants/constants.dart';
import 'package:lol/main/screens/inside_subject.dart';
import 'package:lol/main/screens/profile.dart';
import 'package:lol/main.dart';
import 'package:lol/utilities/navigation.dart';

import '../../auth/screens/login.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    var _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xff1B262C),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            _scaffoldKey.currentState!
                .openDrawer(); // Use key to open the drawer
          },
          icon: Icon(
            Icons.menu,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xff0F4C75),
        title: const InkWell(child: Row()),
        actions: [
          if (token == null)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xff4fd1c5),
                    Color(0xff38b2ac),
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: MaterialButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                child: Text(
                  "Login",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.light_mode,
              color: Colors.black,
            ),
          ), // State management toggle between the icons
        ],
      ),
      drawer: Drawer(
        width: width / 2.5,
        backgroundColor: const Color(0xff0F4C75),
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(
                Icons.person,
                color: Colors.blue,
              ),
              title: const Text("Profile"),
              onTap: () {},
            ),
            ListTile(
              onTap: () {},
              leading: const Icon(Icons.document_scanner),
              title: const Text("About App"),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
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
              SizedBox(height: 20),
              CarouselSlider(
                items: carsor.map((carsor) {
                  return InkWell(
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3.0),
                          ),
                          child: Image.asset(
                            carsor.image!,
                            width: double.infinity,
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
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 74, 85, 122).withOpacity(0.6).withAlpha(200),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Text(
                            carsor.text!,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                options: CarouselOptions(
                  height: 200.0,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 16 / 9,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayInterval: const Duration(seconds: 10),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  viewportFraction: 0.8,
                ),
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Two items per row
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio:
                        3 / 2, // Control the height and width ratio
                  ),
                  itemCount: subjectNamesList.length,
                  itemBuilder: (context, index) {
                    return subjectItemBuild(subjectNamesList[index],context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget subjectItemBuild(subjectName,context) {
  return InkWell(
    onTap: () {
      navigate(context, InsideSubject(subjectName: subjectName));
      print("$subjectName clicked");
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
                image: AssetImage('images/${subjectName.toLowerCase()}.png' ??
                    "images/physics.png"),
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
              subjectName,
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
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
    image: "images/140.jpg",
    text: "Latest Of Academic Schedule \"9-17\"",
  ),
  CarsorModel(
    image: "images/332573639_735780287983011_1562632886952931410_n.jpg",
    text:
        "RoboTech summers training application form opens today at 9:00 pm! Be ready",
  ),
  CarsorModel(
    image: "images/338185486_3489006871419356_4868524435440167213_n.jpg",
    text:
        "Cyberus summers training application form opens today at 9:00 pm! Be ready",
  ),
];

List<dynamic> subjectNamesList = [
  "Physics",
  "Electronics",
  "Calculus",
  "Ethics",
  "Business",
  "StructuredProgramming",
];
