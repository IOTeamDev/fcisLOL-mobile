import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lol/main.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    double width = screenWidth(context);
    double height = screenHeight(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsetsDirectional.only(top: 50),
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Positioned(
                      left: 0,
                      child: backButton(context),
                    ),
                    Center(
                      child: Text(
                        'About Us',
                        style: TextStyle(fontSize: width / 9, ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25,),
                Padding(
                  padding: const EdgeInsetsDirectional.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Who Are We', style: TextStyle(fontSize: width/13),),
                      divider(),
                    ],
                  ),
                ),
                SizedBox(height: 30,),
                Text('Team LOL', style: TextStyle(fontSize: width/10, fontWeight: FontWeight.bold),),
                Text('“All In One”', style: TextStyle(fontSize: width/15, fontWeight: FontWeight.bold, color: Colors.grey),),
                Padding(
                  padding: const EdgeInsetsDirectional.symmetric(horizontal: 13.0, vertical: 10),
                  child: Text('UniNotes app is an interactive platform where study materials are collected, allowing students to contribute content for all academic years. Admins review and approve submissions to ensure quality. The development team is from the Faculty of Information and Computer Science at Ain Shams University (FCIS 2027).', style: TextStyle(fontSize: width/20,),),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.symmetric(horizontal: 20.0, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Meet The team', style: TextStyle(fontSize: width/13),),
                      divider(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 20.0, bottom: 10),
                  child: Align(alignment: Alignment.centerLeft,child: Text('Flutter Developers', style: TextStyle(fontSize: 16),)),
                ),
                Container(
                  margin: EdgeInsetsDirectional.symmetric(horizontal: 15),
                  padding: EdgeInsetsDirectional.symmetric(horizontal: 15),
                  width: double.infinity,
                  height: 90,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: isDark? HexColor('#3B3B3B'): HexColor('#757575')),
                  child: Row(
                    children: [
                      CircleAvatar(radius: 30,backgroundImage: NetworkImage('https://media-hbe1-1.cdn.whatsapp.net/v/t61.24694-24/418597847_479782551230154_2590049062991285152_n.jpg?ccb=11-4&oh=01_Q5AaINF0vC0sqpFXAp_poEBqTycKLH8tBkJsI2ojOaOwhQRn&oe=67254439&_nc_sid=5e03e0&_nc_cat=110'),),
                      SizedBox(width: 10,),
                      ConstrainedBox(constraints: BoxConstraints(maxWidth: width/3), child: Text('Omar Nasr', style: TextStyle(fontSize: 20, color: Colors.white),overflow: TextOverflow.ellipsis,maxLines: 2,),),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: (){
                          launchUrl(Uri.parse('https://linktr.ee/J3_Unknown'));
                        }, 
                        child: Text('Contacts', style: TextStyle(color: Colors.white),),
                        style: ElevatedButton.styleFrom(backgroundColor: HexColor('#4764C5'), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), padding: EdgeInsetsDirectional.symmetric(horizontal: 15)),
                      )
                      
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  margin: EdgeInsetsDirectional.symmetric(horizontal: 15),
                  padding: EdgeInsetsDirectional.symmetric(horizontal: 15),
                  width: double.infinity,
                  height: 90,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),  color: isDark? HexColor('#3B3B3B'): HexColor('#757575')),
                  child: Row(
                    children: [
                      CircleAvatar(radius: 30,backgroundImage: NetworkImage('https://media-hbe1-1.cdn.whatsapp.net/v/t61.24694-24/454395666_917538720254082_5688042246178164073_n.jpg?ccb=11-4&oh=01_Q5AaIN9Vwc0UJUoBKTw74c6FoYmxyJyoP7g04iDHYKnHMBP0&oe=672565BA&_nc_sid=5e03e0&_nc_cat=105'),),
                      SizedBox(width: 10,),
                      ConstrainedBox(constraints: BoxConstraints(maxWidth: width/3.2), child: Text('Mahmoud Sa\'ad', style: TextStyle(fontSize: 20, color: Colors.white),overflow: TextOverflow.ellipsis,maxLines: 2,),),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: (){
                          launchUrl(Uri.parse('https://linktr.ee/malik1307'));
                        },
                        child: Text('Contacts', style: TextStyle(color: Colors.white),),
                        style: ElevatedButton.styleFrom(backgroundColor: HexColor('#4764C5'), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), padding: EdgeInsetsDirectional.symmetric(horizontal: 15)),
                      )

                    ],
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  margin: EdgeInsetsDirectional.symmetric(horizontal: 15),
                  padding: EdgeInsetsDirectional.symmetric(horizontal: 15),
                  width: double.infinity,
                  height: 90,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),  color: isDark? HexColor('#3B3B3B'): HexColor('#757575')),
                  child: Row(
                    children: [
                      CircleAvatar(radius: 30,backgroundImage: NetworkImage('https://media-hbe1-1.cdn.whatsapp.net/v/t61.24694-24/459111528_411397035091165_5639055007617670316_n.jpg?ccb=11-4&oh=01_Q5AaIHRNHZeglU-fDOb9eNSUDwWBWZWhgszeDirP6cXRei2Z&oe=672547A9&_nc_sid=5e03e0&_nc_cat=111'),),
                      SizedBox(width: 10,),
                      ConstrainedBox(constraints: BoxConstraints(maxWidth: width/3.2), child: Text('Saif Elnawawy', style: TextStyle(fontSize: 20, color: Colors.white),overflow: TextOverflow.ellipsis,maxLines: 2,),),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: (){
                          launchUrl(Uri.parse('https://linktr.ee/Se_if?utm_source=linktree_profile_share'));
                        },
                        child: Text('Contacts', style: TextStyle(color: Colors.white),),
                        style: ElevatedButton.styleFrom(backgroundColor: HexColor('#4764C5'), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), padding: EdgeInsetsDirectional.symmetric(horizontal: 15)),
                      )

                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 20.0, bottom: 10, top: 20),
                  child: Align(alignment: Alignment.centerLeft,child: Text('Back-End Developer', style: TextStyle(fontSize: 16),)),
                ),
                Container(
                  margin: EdgeInsetsDirectional.symmetric(horizontal: 15),
                  padding: EdgeInsetsDirectional.symmetric(horizontal: 15),
                  width: double.infinity,
                  height: 90,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),  color: isDark? HexColor('#3B3B3B'): HexColor('#757575')),
                  child: Row(
                    children: [
                      CircleAvatar(radius: 30,backgroundImage: NetworkImage('https://media-hbe1-1.cdn.whatsapp.net/v/t61.24694-24/417357665_1165557908119538_5289593370887603831_n.jpg?ccb=11-4&oh=01_Q5AaIKErL2y34Y8sL0VDkTIiSARZcjxPB3C2rneJY3PKJtIy&oe=671F50A6&_nc_sid=5e03e0&_nc_cat=109'),),
                      SizedBox(width: 10,),
                      ConstrainedBox(constraints: BoxConstraints(maxWidth: width/3.2), child: Text('Omar Hassan', style: TextStyle(fontSize: 20, color: Colors.white),overflow: TextOverflow.ellipsis,maxLines: 2,),),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: (){
                          launchUrl(Uri.parse('https://0mr.me/who'));
                        },
                        child: Text('Contacts', style: TextStyle(color: Colors.white),),
                        style: ElevatedButton.styleFrom(backgroundColor: HexColor('#4764C5'), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), padding: EdgeInsetsDirectional.symmetric(horizontal: 15)),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 20.0, bottom: 10, top: 20),
                  child: Align(alignment: Alignment.centerLeft,child: Text('UI/UX Designer', style: TextStyle(fontSize: 16),)),
                ),
                Container(
                  margin: EdgeInsetsDirectional.symmetric(horizontal: 15),
                  padding: EdgeInsetsDirectional.symmetric(horizontal: 15),
                  width: double.infinity,
                  height: 90,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),  color: isDark? HexColor('#3B3B3B'): HexColor('#757575')),
                  child: Row(
                    children: [
                      CircleAvatar(radius: 30,backgroundImage: NetworkImage('https://media-hbe1-1.cdn.whatsapp.net/v/t61.24694-24/461285944_2482003412008696_545038448751502366_n.jpg?ccb=11-4&oh=01_Q5AaIKBiateq3IHED5p5nDrkpNQDxSmfujiDHbFtI_b9lgp1&oe=672562B4&_nc_sid=5e03e0&_nc_cat=107'),),
                      SizedBox(width: 10,),
                      ConstrainedBox(constraints: BoxConstraints(maxWidth: width/3.2), child: Text('Mahmoud Ahmed', style: TextStyle(fontSize: 20, color: Colors.white),overflow: TextOverflow.ellipsis,maxLines: 2,),),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: (){
                          launchUrl(Uri.parse('https://linktr.ee/mahmoud588'));
                        },
                        child: Text('Contacts', style: TextStyle(color: Colors.white),),
                        style: ElevatedButton.styleFrom(backgroundColor: HexColor('#4764C5'), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), padding: EdgeInsetsDirectional.symmetric(horizontal: 15)),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 20.0, bottom: 10, top: 20),
                  child: Align(alignment: Alignment.centerLeft,child: Text('Contributor', style: TextStyle(fontSize: 16),)),
                ),
                Container(
                  margin: EdgeInsetsDirectional.symmetric(horizontal: 15),
                  padding: EdgeInsetsDirectional.symmetric(horizontal: 15),
                  width: double.infinity,
                  height: 90,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),  color: isDark? HexColor('#3B3B3B'): HexColor('#757575')),
                  child: Row(
                    children: [
                      CircleAvatar(radius: 30,backgroundImage: NetworkImage('https://media-hbe1-1.cdn.whatsapp.net/v/t61.24694-24/358107689_1530656884409433_3079936151263351192_n.jpg?ccb=11-4&oh=01_Q5AaIKIu6NdWccKAO1EXCyXqEL0lZwC8QQrPbtj9xuzWzRXU&oe=67254922&_nc_sid=5e03e0&_nc_cat=105'),),
                      SizedBox(width: 10,),
                      ConstrainedBox(constraints: BoxConstraints(maxWidth: width/3.2), child: Text('Ibrahim Abo Elso\'ud', style: TextStyle(fontSize: 20, color: Colors.white),overflow: TextOverflow.ellipsis,maxLines: 2,),),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: (){
                          launchUrl(Uri.parse('http://Aboelsoud.vercel.app'));
                        },
                        child: Text('Contacts', style: TextStyle(color: Colors.white),),
                        style: ElevatedButton.styleFrom(backgroundColor: HexColor('#4764C5'), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), padding: EdgeInsetsDirectional.symmetric(horizontal: 15)),
                      )
                    ],
                  ),
                ),
                // Expanded(
                //   child: CustomScrollView(
                //     slivers: [
                //       SliverPadding(
                //         padding: const EdgeInsets.symmetric(horizontal: 16.0),
                //         sliver: SliverGrid(
                //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //             crossAxisCount: 2,
                //             mainAxisSpacing: 20,
                //             crossAxisSpacing: 10,
                //             childAspectRatio: 0.8,
                //           ),
                //           delegate: SliverChildBuilderDelegate(
                //             (context, index) {
                //               final teamMembers = [
                //                 {
                //                   'name': 'Omar Nasr',
                //                   'imagePath':
                //                       'https://media-hbe1-1.cdn.whatsapp.net/v/t61.24694-24/418597847_479782551230154_2590049062991285152_n.jpg?ccb=11-4&oh=01_Q5AaINF0vC0sqpFXAp_poEBqTycKLH8tBkJsI2ojOaOwhQRn&oe=67254439&_nc_sid=5e03e0&_nc_cat=110',
                //                   'role': 'Flutter Developer',
                //                   'contactUrl': ''
                //                 },
                //                 {
                //                   'name': 'Mahmoud Saad',
                //                   'imagePath':
                //                       'https://media-hbe1-1.cdn.whatsapp.net/v/t61.24694-24/454395666_917538720254082_5688042246178164073_n.jpg?ccb=11-4&oh=01_Q5AaIN9Vwc0UJUoBKTw74c6FoYmxyJyoP7g04iDHYKnHMBP0&oe=672565BA&_nc_sid=5e03e0&_nc_cat=105',
                //                   'role': 'Flutter Developer',
                //                   'contactUrl': ''
                //                 },
                //                 {
                //                   'name': 'Saif Elnawawy',
                //                   'imagePath':
                //                       'https://media-hbe1-1.cdn.whatsapp.net/v/t61.24694-24/459111528_411397035091165_5639055007617670316_n.jpg?ccb=11-4&oh=01_Q5AaIHRNHZeglU-fDOb9eNSUDwWBWZWhgszeDirP6cXRei2Z&oe=672547A9&_nc_sid=5e03e0&_nc_cat=111',
                //                   'role': 'Flutter Developer',
                //                   'contactUrl': ''
                //                 },
                //                 {
                //                   'name': 'Omar Hassan',
                //                   'imagePath':
                //                       "https://media-hbe1-1.cdn.whatsapp.net/v/t61.24694-24/417357665_1165557908119538_5289593370887603831_n.jpg?ccb=11-4&oh=01_Q5AaIKErL2y34Y8sL0VDkTIiSARZcjxPB3C2rneJY3PKJtIy&oe=671F50A6&_nc_sid=5e03e0&_nc_cat=109",
                //                   'role': 'Backend Developer',
                //                   'contactUrl': ''
                //                 },
                //                 {
                //                   'name': 'Ibrahim Aboelsoud',
                //                   'imagePath':
                //                       'https://media-hbe1-1.cdn.whatsapp.net/v/t61.24694-24/358107689_1530656884409433_3079936151263351192_n.jpg?ccb=11-4&oh=01_Q5AaIKIu6NdWccKAO1EXCyXqEL0lZwC8QQrPbtj9xuzWzRXU&oe=67254922&_nc_sid=5e03e0&_nc_cat=105',
                //                   'role': 'Frontend Developer',
                //                   'contactUrl': ''
                //                 },
                //                 {
                //                   'name': 'Mahmoud Ahmed',
                //                   'imagePath':
                //                       'https://media-hbe1-1.cdn.whatsapp.net/v/t61.24694-24/461285944_2482003412008696_545038448751502366_n.jpg?ccb=11-4&oh=01_Q5AaIKBiateq3IHED5p5nDrkpNQDxSmfujiDHbFtI_b9lgp1&oe=672562B4&_nc_sid=5e03e0&_nc_cat=107',
                //                   'role': 'UI/UX Designer',
                //                   'contactUrl': ''
                //                 },
                //               ];
                //               final member = teamMembers[index];
                //               return _buildTeamMember(
                //                 member['imagePath']!,
                //                 member['name']!,
                //                 member['role']!,
                //                 member['contactUrl']!,
                //               );
                //             },
                //             childCount: 6,
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget _buildTeamMember(
  //     String imagePath, String name, String role, String contactEmail) {
  //   return Card(
  //     elevation: 4,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //     child: Padding(
  //       padding: const EdgeInsets.all(12.0),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           CircleAvatar(
  //             radius: 40,
  //             backgroundImage: NetworkImage(imagePath),
  //           ),
  //           SizedBox(height: 10),
  //           Text(
  //             name,
  //             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
  //           ),
  //           Text(
  //             role,
  //             style: TextStyle(
  //                 color: Colors.grey[600],
  //                 fontStyle: FontStyle.italic,
  //                 fontSize: 12),
  //           ),
  //           SizedBox(height: 10),
  //           ElevatedButton(
  //             onPressed: () {
  //               _contactTeamMember(contactEmail);
  //             },
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: Colors.blueAccent,
  //             ),
  //             child: Text(
  //               'Contact',
  //               style: TextStyle(color: Colors.black87),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  //
  // void _contactTeamMember(String email) {
  //   print('Contacting: $email');
  // }
}
