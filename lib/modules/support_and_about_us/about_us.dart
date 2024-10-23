import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back))
              ],
            ),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  // Header Section

                  // Meet the Team Section
                  SliverPadding(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 10, bottom: 10),
                    sliver: SliverToBoxAdapter(
                      child: Center(
                        child: Text(
                          'Meet the Team',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
// SizedBox(height: 30,),
                  // Team Members Grid Section
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 10,
                        childAspectRatio: 0.8,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final teamMembers = [
                            {
                              'name': 'Omar Nasr',
                              'imagePath':
                                  'https://media-hbe1-1.cdn.whatsapp.net/v/t61.24694-24/418597847_479782551230154_2590049062991285152_n.jpg?ccb=11-4&oh=01_Q5AaINF0vC0sqpFXAp_poEBqTycKLH8tBkJsI2ojOaOwhQRn&oe=67254439&_nc_sid=5e03e0&_nc_cat=110',
                              'role': 'Flutter Developer',
                              'contactUrl': ''
                            },
                            {
                              'name': 'Mahmoud Saad',
                              'imagePath':
                                  'https://media-hbe1-1.cdn.whatsapp.net/v/t61.24694-24/454395666_917538720254082_5688042246178164073_n.jpg?ccb=11-4&oh=01_Q5AaIN9Vwc0UJUoBKTw74c6FoYmxyJyoP7g04iDHYKnHMBP0&oe=672565BA&_nc_sid=5e03e0&_nc_cat=105',
                              'role': 'Flutter Developer',
                              'contactUrl': ''
                            },
                            {
                              'name': 'Saif Elnawawy',
                              'imagePath':
                                  'https://media-hbe1-1.cdn.whatsapp.net/v/t61.24694-24/459111528_411397035091165_5639055007617670316_n.jpg?ccb=11-4&oh=01_Q5AaIHRNHZeglU-fDOb9eNSUDwWBWZWhgszeDirP6cXRei2Z&oe=672547A9&_nc_sid=5e03e0&_nc_cat=111',
                              'role': 'Flutter Developer',
                              'contactUrl': ''
                            },
                            {
                              'name': 'Omar Hassan',
                              'imagePath':
                                  "https://media-hbe1-1.cdn.whatsapp.net/v/t61.24694-24/417357665_1165557908119538_5289593370887603831_n.jpg?ccb=11-4&oh=01_Q5AaIKErL2y34Y8sL0VDkTIiSARZcjxPB3C2rneJY3PKJtIy&oe=671F50A6&_nc_sid=5e03e0&_nc_cat=109",
                              'role': 'Backend Developer',
                              'contactUrl': ''
                            },
                            {
                              'name': 'Ibrahim Aboelsoud',
                              'imagePath':
                                  'https://media-hbe1-1.cdn.whatsapp.net/v/t61.24694-24/358107689_1530656884409433_3079936151263351192_n.jpg?ccb=11-4&oh=01_Q5AaIKIu6NdWccKAO1EXCyXqEL0lZwC8QQrPbtj9xuzWzRXU&oe=67254922&_nc_sid=5e03e0&_nc_cat=105',
                              'role': 'Frontend Developer',
                              'contactUrl': ''
                            },
                            {
                              'name': 'Mahmoud Ahmed',
                              'imagePath':
                                  'https://media-hbe1-1.cdn.whatsapp.net/v/t61.24694-24/461285944_2482003412008696_545038448751502366_n.jpg?ccb=11-4&oh=01_Q5AaIKBiateq3IHED5p5nDrkpNQDxSmfujiDHbFtI_b9lgp1&oe=672562B4&_nc_sid=5e03e0&_nc_cat=107',
                              'role': 'UI/UX Designer',
                              'contactUrl': ''
                            },
                          ];
                          final member = teamMembers[index];
                          return _buildTeamMember(
                            member['imagePath']!,
                            member['name']!,
                            member['role']!,
                            member['contactUrl']!,
                          );
                        },
                        childCount: 6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
                  fontSize: 12),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _contactTeamMember(contactEmail);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
              child: Text(
                'Contact',
                style: TextStyle(color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _contactTeamMember(String email) {
    print('Contacting: $email');
  }
}
