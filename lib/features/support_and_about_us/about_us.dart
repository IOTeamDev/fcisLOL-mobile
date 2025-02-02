import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lol/main.dart';
import 'package:lol/core/utils/components.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/utils/resources/constants_manager.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsetsDirectional.only(top: AppQueries.screenHeight(context) / 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    backButton(context),
                    Center(
                      child: Text(
                        'About Us',
                        style: TextStyle(
                          fontSize: 30,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25),
                // About Us Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Who Are We',
                        style: TextStyle(fontSize: width / 13),
                      ),
                      SizedBox(height: 20),
                      Divider(color: Colors.grey),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: HexColor('#757575'),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'UniNotes',
                        style: GoogleFonts.abhayaLibre(
                          letterSpacing: 1.9,
                          fontSize: width / 8,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '“All In One”',
                        style: TextStyle(
                          fontSize: width / 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[300],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 10,
                        ),
                        child: RichText(
                          text: TextSpan(
                            text: 'UniNotes',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: width / 18,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text:
                                    ' is an interactive platform where study materials are collected, allowing students to contribute content for all academic years. Admins review and approve submissions to ensure quality.',
                                style: TextStyle(
                                  letterSpacing: 1.5,
                                  fontSize: width / 20,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: height / 25),

                // Meet the Team Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Meet The Team',
                        style: TextStyle(fontSize: width / 13),
                      ),
                      SizedBox(height: 20),
                      Divider(color: Colors.grey),
                    ],
                  ),
                ),
                SizedBox(
                  height: AppQueries.screenHeight(context),
                  child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: teamMembers.length,
                    itemBuilder: (context, index) {
                      final member = teamMembers[index];
                      return _buildTeamMember(
                        member['imagePath']!,
                        member['name']!,
                        member['role']!,
                        member['contactUrl']!,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTeamMember(
      String imagePath, String name, String role, String contactEmail) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(imagePath),
            ),
            SizedBox(height: 10),
            Text(
              name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Text(
              role,
              style: TextStyle(
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
                fontSize: 12,
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _contactTeamMember(contactEmail),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
              child: Text(
                'Contact',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _contactTeamMember(String email) async {
    launchUrl(Uri.parse(email));
  }

  List<Map<String, String>> get teamMembers => [
        {
          'name': 'Omar Nasr',
          'imagePath':
              'https://firebasestorage.googleapis.com/v0/b/fcis-da7f4.appspot.com/o/images%2Ffile.jpg?alt=media&token=7f050ff7-8d8d-4ea4-84da-3d254c36c0c2',
          'role': 'Flutter Developer',
          'contactUrl': 'https://linktr.ee/J3_Unknown'
        },
        {
          'name': 'Mahmoud Saad',
          'imagePath':
              'https://firebasestorage.googleapis.com/v0/b/fcis-da7f4.appspot.com/o/IMG_%D9%A2%D9%A0%D9%A2%D9%A4%D9%A1%D9%A0%D9%A2%D9%A9_%D9%A1%D9%A1%D9%A5%D9%A7%D9%A2%D9%A9%20(1).jpg?alt=media&token=33ea4477-f573-47e6-981e-c01dc81c1c8b',
          'role': 'Flutter Developer',
          'contactUrl': 'https://linktr.ee/malik1307'
        },
        {
          'name': 'Saif Elnawawy',
          'imagePath':
              'https://firebasestorage.googleapis.com/v0/b/fcis-da7f4.appspot.com/o/images%2F459111528_411397035091165_5639055007617670316_n.jpg?alt=media&token=6ee42433-ee9f-449c-bef2-3abf21edd5b6',
          'role': 'Flutter Developer',
          'contactUrl':
              'https://linktr.ee/Se_if?utm_source=linktree_profile_share'
        },
        {
          'name': 'Omar M. Hassan',
          'imagePath':
              'https://firebasestorage.googleapis.com/v0/b/fcis-da7f4.appspot.com/o/417357665_1165557908119538_5289593370887603831_n.jpg?alt=media&token=d112e3d8-3182-409a-a83e-0e8c581ccc4d',
          'role': 'Backend Developer',
          'contactUrl': 'https://0mr.me/who'
        },
        {
          'name': 'Mahmoud Ahmed',
          'imagePath':
              'https://firebasestorage.googleapis.com/v0/b/fcis-da7f4.appspot.com/o/images%2Ffile%20(4).jpg?alt=media&token=66fabec5-9958-4217-81cc-73bfe4cabdba',
          'role': 'UI/UX Designer',
          'contactUrl': 'https://linktr.ee/mahmoud588'
        },
        {
          'name': 'Ibrahim Abo Elso\'ud',
          'imagePath':
              'https://images-cdn.ubuy.co.in/64c7e79e11e2491d3f730794-flag-of-palestine-3x5-ft-flags-3-x-5.jpg',
          'role': 'Contributor',
          'contactUrl': 'http://Aboelsoud.vercel.app'
        },
      ];
}
