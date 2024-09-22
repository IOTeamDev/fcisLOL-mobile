import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lol/auth/screens/login.dart';
import 'package:lol/constants/constants.dart';
import 'package:lol/main/screens/profile.dart';
import 'package:lol/main.dart';
import 'package:lol/utilities/navigation.dart';
import 'package:lol/utilities/shared_prefrence.dart';


class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    var scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xff1B262C),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
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

          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.light_mode,
                color: Colors.black,
              )) //State management toggle between the icons
        ],
      ),
      drawer: Drawer(
        // We Will Put In It Things
        width: width / 2.5,
        // backgroundColor: const Color(0xff0F4C75),

        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              onTap: () {},
            ),
            ListTile(
              onTap: () {},
              leading: const Icon(Icons.document_scanner),
              title: const Text("About App"),
            ),
            ListTile(
              onTap: () {
                Cache.removeValue(key: "token");
                navigatReplace(context, const LoginScreen());
              },
              leading: const Icon(Icons.exit_to_app),
              title: const Text("Log Out"),
            )
          ],
        ),
      ),
      body: Container(
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
                      child:
                          Stack(alignment: Alignment.bottomCenter, children: [
                    Container(
                      clipBehavior: Clip.antiAlias,
                      // margin: const EdgeInsets.all(6.0),
                      // child: Image.asset("images/332573639_735780287983011_1562632886952931410_n.jpg",width: 400,height: 400,fit: BoxFit.cover,),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3.0),
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
                            color: const Color.fromARGB(51, 65, 180, 197)
                                .withOpacity(0.6)
                                .withAlpha(150),
                            borderRadius: BorderRadius.circular(3)),
                        child: Text(
                          carsor.text!,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
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
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Two items per row
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio:
                        3 / 2, // Control the height and width ratio
                  ),
                  itemCount: subjectNamesList.length,
                  itemBuilder: (context, index) {
                    return subjectItemBuild(subjectNamesList[index]);
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

Widget subjectItemBuild(subjectName) {
  return GestureDetector(
    onTap: () {
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
                colorFilter:
                    const ColorFilter.mode(Color(0xfff39c12), BlendMode.dstIn),
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
List subjectNamesList = [
  "Physics",
  "Electronics",
  "Calculus",
  "Ethics",
  "Business",
  "StructuredProgramming",
];

// List carsor = [
//   "images/clock.jpeg",
//   "images/clockworkorange_tall.jpg",
//   "images/images.jfif",
//   "images/shutterstock_5885876aa.webp",
//   "images/120604_r22256_g2048.webp",
// ];  on this