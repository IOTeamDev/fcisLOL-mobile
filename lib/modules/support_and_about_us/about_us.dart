import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header Section

            // Meet the Team Section
            SliverPadding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 10, bottom: 5),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Meet the Team',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

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
                        'imagePath': '',
                        'role': 'Flutter Developer',
                        'contactUrl': ''
                      },
                      {
                        'name': 'Ibrahim Aboelsoud',
                        'imagePath': '',
                        'role': 'Frontend Developer',
                        'contactUrl': ''
                      },
                      {
                        'name': 'Mahmoud Saad',
                        'imagePath': '',
                        'role': 'Flutter Developer',
                        'contactUrl': ''
                      },
                      {
                        'name': 'Omar Hassan',
                        'imagePath': '',
                        'role': 'Backend Developer',
                        'contactUrl': ''
                      },
                      {
                        'name': 'Saif Elnawawy',
                        'imagePath': '',
                        'role': 'Flutter Developer',
                        'contactUrl': ''
                      },
                      {
                        'name': 'Ahmed Khalaf',
                        'imagePath': '',
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

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    '© 2024 Our Company | All Rights Reserved',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
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
              backgroundImage: AssetImage(imagePath),
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
              child: Text('Contact'),
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
