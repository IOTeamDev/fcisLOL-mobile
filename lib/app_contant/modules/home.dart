import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lol/app_contant/modules/profile.dart';
import 'package:lol/constants/componants.dart';
import 'package:lol/main.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

  return Scaffold(
      // backgroundColor: Colors.grey[400],
      drawer: Drawer(
        //We Will Put In It Things
        width: width / 2.5,
        backgroundColor: const Color(0xff27363D),

        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              onTap: () {
                if (!isLogin!)  
                  dialgoAwesome(
                      context: context,
                      title: 'Please SignIn First',
                      type: DialogType.info,
                      btnCancelText: "Maybe later",
                      btnOkText: "Sign In",
                      btnCancelOnPress: () {},
                      btnOkOnPress: () {});

                if (!isLogin!) print("object");

                if (isLogin!) navigat(context, const profile ());
              },
            ),
            ListTile(
              onTap: () {},
              leading: const Icon(Icons.document_scanner),
              title: const Text("About App"),
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: const InkWell(
            child:
                Row()), //The Logo With Name And Make it Always Navigate to the Home
        // iconTheme: const IconThemeData(color: Colors.white),
        // backgroundColor: Colors.blueGrey,
        actions: [
          if (!isLogin!)
            Container(
              decoration: BoxDecoration(
                  color: const Color(0xff631313),
                  borderRadius: BorderRadius.circular(10)),
              child: MaterialButton(
                onPressed: () {},
                child: const Text(
                  "Sign In",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.dark_mode,
                color: Colors.black,
              )) //State management toggle between the icons
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              items: Carsor.map((image) {
                return Container(
                  margin: const EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                      image: AssetImage(image),
                      fit: BoxFit.cover,
                    ),
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: SubjectNamesList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16.0,
                  crossAxisSpacing: 16.0,
                  childAspectRatio: 3 / 2,
                ),
                itemBuilder: (context, index) {
                  return SubjectItemBuild( SubjectNamesList[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget SubjectItemBuild  (SubjectName){
    return GestureDetector(
      onTap: () {
        print("$SubjectName clicked");
      },
      child: Card(
        elevation: 8.0,
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
                  image: AssetImage('images/${SubjectName.toLowerCase()}.png'), // Replace with your actual image assets
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
                SubjectName,
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


List SubjectNamesList = [
  "Physics",
  "Electronics",
  "English",
  "Psychology",
    "Physics",
  "Electronics",
  "English",
  "Psychology",
  
];

List Carsor = [
  "images/clock.jpeg",
  "images/clockworkorange_tall.jpg",
  "images/images.jfif",
  "images/shutterstock_5885876aa.webp",
  "images/120604_r22256_g2048.webp",
];
