import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Image and Title
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/company_banner.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/company_logo.png'),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Our Company',
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Innovating the Future',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 30),

            // Team Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Meet the Team',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),

                  // Simple List of Team Members with Role
                  _buildTeamMember('assets/team_member_1.jpg', 'Alice Smith', 'CEO'),
                  SizedBox(height: 20),
                  _buildTeamMember('assets/team_member_2.jpg', 'John Doe', 'CTO'),
                  SizedBox(height: 20),
                  _buildTeamMember('assets/team_member_3.jpg', 'Jane Williams', 'Product Manager'),SizedBox(height: 20),
                  _buildTeamMember('assets/team_member_3.jpg', 'Jane Williams', 'Product Manager'),SizedBox(height: 20),
                  _buildTeamMember('assets/team_member_3.jpg', 'Jane Williams', 'Product Manager'),
                ],
              ),
            ),

            SizedBox(height: 30),

            // Footer Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  '© 2024 Our Company | All Rights Reserved',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Simple team member card with name and role
  Widget _buildTeamMember(String imagePath, String name, String role) {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: AssetImage(imagePath),
        ),
        SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              role,
              style: TextStyle(color: Colors.grey[600], fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ],
    );
  }
}
