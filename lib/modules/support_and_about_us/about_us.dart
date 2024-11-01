import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lol/main.dart';
import 'package:lol/shared/components/components.dart';
import 'package:lol/shared/components/constants.dart';
import 'package:url_launcher/url_launcher.dart';

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
            margin: EdgeInsetsDirectional.only(top: screenHeight(context) / 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Positioned(
                      left: 0,
                      child: backButton(context),
                    ),
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
                  height: screenHeight(context),
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
              'https://media-hbe1-1.cdn.whatsapp.net/v/t61.24694-24/418597847_479782551230154_2590049062991285152_n.jpg?ccb=11-4&oh=01_Q5AaINF0vC0sqpFXAp_poEBqTycKLH8tBkJsI2ojOaOwhQRn&oe=67254439&_nc_sid=5e03e0&_nc_cat=110',
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
              'https://media-hbe1-1.cdn.whatsapp.net/v/t61.24694-24/459111528_411397035091165_5639055007617670316_n.jpg?ccb=11-4&oh=01_Q5AaIHRNHZeglU-fDOb9eNSUDwWBWZWhgszeDirP6cXRei2Z&oe=672547A9&_nc_sid=5e03e0&_nc_cat=111',
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
              'https://media-hbe1-1.cdn.whatsapp.net/v/t61.24694-24/461285944_2482003412008696_545038448751502366_n.jpg?ccb=11-4&oh=01_Q5AaIKBiateq3IHED5p5nDrkpNQDxSmfujiDHbFtI_b9lgp1&oe=672562B4&_nc_sid=5e03e0&_nc_cat=107',
          'role': 'UI/UX Designer',
          'contactUrl': 'https://linktr.ee/mahmoud588'
        },
        {
          'name': 'Ibrahim Abo Elso\'ud',
          'imagePath':
              'https://media-hbe1-1.cdn.whatsapp.net/v/t61.24694-24/358107689_1530656884409433_3079936151263351192_n.jpg?ccb=11-4&oh=01_Q5AaIKIu6NdWccKAO1EXCyXqEL0lZwC8QQrPbtj9xuzWzRXU&oe=67254922&_nc_sid=5e03e0&_nc_cat=105',
          'role': 'Contributor',
          'contactUrl': 'http://Aboelsoud.vercel.app'
        },
      ];
}
