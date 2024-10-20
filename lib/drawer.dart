import 'package:flutter/material.dart';

class CustomDrawe extends StatefulWidget {
  const CustomDrawe({super.key});

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawe> {
  bool isDarkMode = false; // State for toggling the theme mode

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        drawer: Drawer(
          child: Container(
            color: isDarkMode ? Colors.black87 : const Color(0xFF2D2D2D),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Stack(
              children: [
                // Theme toggle switch at the top-right corner
                Positioned(
                  top: 20,
                  right: 0,
                  child: Column(
                    children: [
                      const Icon(Icons.dark_mode, color: Colors.white),
                      Switch(
                        value: isDarkMode,
                        onChanged: (value) {
                          setState(() {
                            isDarkMode = value;
                            // Logic to change the app theme
                          });
                        },
                        activeColor: Colors.white,
                        inactiveThumbColor: Colors.grey,
                        activeTrackColor: Colors.yellow,
                        inactiveTrackColor: Colors.white24,
                      ),
                      const Icon(Icons.light_mode, color: Colors.white),
                    ],
                  ),
                ),
                // Main content of the drawer
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 80), // Space for the top switch
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey,
                          child:
                              Icon(Icons.person, color: Colors.white, size: 30),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Mohamed Ali Klay',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const Text(
                      'Second Year Student',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.person, color: Colors.white),
                      label: const Text(
                        'Profile info',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                    const Divider(color: Colors.white54),
                    const SizedBox(height: 10),
                    // Menu items
                    Expanded(
                      child: ListView(
                        children: [
                          _buildDrawerItem(Icons.announcement, 'Announcements'),
                          _buildDrawerItem(Icons.school, 'Years'),
                          Padding(
                            padding: const EdgeInsets.only(left: 24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildDrawerItem(Icons.book, 'First Year'),
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      SizedBox(height: 8),
                                      Text('First Semester',
                                          style: TextStyle(color: Colors.grey)),
                                      SizedBox(height: 4),
                                      Text('Second Semester',
                                          style: TextStyle(color: Colors.grey)),
                                      SizedBox(height: 8),
                                    ],
                                  ),
                                ),
                                _buildDrawerItem(Icons.school, 'Second Year'),
                                _buildDrawerItem(Icons.school, 'Third Year'),
                                _buildDrawerItem(Icons.school, 'Fourth Year'),
                              ],
                            ),
                          ),
                          _buildDrawerItem(Icons.drive_file_move, 'Drive'),
                          _buildDrawerItem(Icons.support, 'Support'),
                          _buildDrawerItem(Icons.info, 'About us'),
                          _buildDrawerItem(Icons.leaderboard, 'Leaderboard'),
                        ],
                      ),
                    ),
                    // Logout Button
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Handle logout
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text('LOGOUT'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          minimumSize: const Size(double.infinity, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildDrawerItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      visualDensity: VisualDensity.compact,
      onTap: () {
        // Add navigation logic here
      },
    );
  }
}
/*

  appBar: AppBar(
                  leadingWidth: 50,

                  leading: IconButton(
                      style: IconButton.styleFrom(
                          padding: EdgeInsets.all(0), minimumSize: Size(0, 0)),
                      onPressed: () {
                        // MainCubit.get(context).openDrawerState();
                        if ((TOKEN != null && profile != null) ||
                            TOKEN == null) {
                          scaffoldKey.currentState!
                              .openDrawer(); // Use key to open the drawer
                        }
                      },
                      icon: const Icon(
                        Icons.menu,
                        size: 25,
                        color: Colors.white,
                      )),
                  backgroundColor: const Color(0xff0F4C75),
                  // centerTitle: true,
                  title: GestureDetector(
                    onTap: () => navigatReplace(context, const Home()),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Icon(Icons.apple),
                        const SizedBox(width: 10),
                        Text(
                          "name",
                          style: GoogleFonts.montserrat(),
                        ),
                        SizedBox(width: 50)
                      ],
                    ),
                  ),
                ),
*/
/*  Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                subject.subjectName.replaceAll('_', " ").replaceAll("and", "&"),
                maxLines: 2,
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ), */