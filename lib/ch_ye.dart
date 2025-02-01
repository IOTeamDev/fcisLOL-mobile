// import 'package:flutter/material.dart';
// import 'package:lol/shared/components/constants.dart';

// class LevelGridScreen extends StatelessWidget {
//   const LevelGridScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Select Level'),
//         leading: IconButton(
//           icon: Icon(Icons.menu),
//           onPressed: () {
//             Scaffold.of(context).openDrawer();
//           },
//         ),
//       ),
//       drawer: Drawer(
//         child: ListView(
//           children: <Widget>[
//             DrawerHeader(
//               decoration: BoxDecoration(color: Colors.blue),
//               child: Text('Profile',
//                   style: TextStyle(color: Colors.white, fontSize: 24)),
//             ),
//             ListTile(
//               title: Text('Login'),
//               onTap: () {
//                 // Login action
//               },
//             ),
//             ListTile(
//               title: Text('Settings'),
//               onTap: () {
//                 // Settings action
//               },
//             ),
//           ],
//         ),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Wrap(
//                 spacing: 16.0, // Space between cards
//                 runSpacing: 16.0, // Space between rows
//                 alignment: WrapAlignment.center, // Center cards horizontally
//                 children: List.generate(4, (index) {
//                   return _buildLevelCard(context, index + 1);
//                 }),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildLevelCard(BuildContext context, int level) {
//     return GestureDetector(
//       onTap: () {
//         _showSemesterSelection(context, level);
//       },
//       child: AnimatedContainer(
//         duration: Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//         decoration: BoxDecoration(
//           color: Colors.blueAccent,
//           borderRadius: BorderRadius.circular(20.0),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black26,
//               offset: Offset(0, 4),
//               blurRadius: 8.0,
//             ),
//           ],
//         ),
//         width: screenWidth(context) / 3, // Fixed width for each card
//         height: screenHeight(context) / 3, // Fixed height for each card
//         child: Center(
//           child: Text(
//             'Level $level',
//             style: TextStyle(
//                 fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
//           ),
//         ),
//       ),
//     );
//   }

//   void _showSemesterSelection(BuildContext context, int level) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Select Semester for Level $level',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   // Handle Semester 1 selection
//                 },
//                 child: Text('Semester 1'),
//               ),
//               SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   // Handle Semester 2 selection
//                 },
//                 child: Text('Semester 2'),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
