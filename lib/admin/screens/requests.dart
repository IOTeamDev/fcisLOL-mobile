import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lol/shared/components/components.dart';
import '../../constants/constants.dart';

class Requests extends StatelessWidget {

  var scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> backgroundColor =
  [
    '94ffff',
    'ff94ad',
    'bc94ff',
    'add271',
    '5d5fff',
    'e17fd1',
    'b6bffe',
    '7d29fb',
    'ff5938',
    '00664e',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold
    (
      key: scaffoldKey,
      drawer: drawerBuilder(context),
      backgroundColor: Colors.black,
      body: Stack
      (
        children:
        [
         backgroundEffects(),
          Container
          (
            margin: const EdgeInsetsDirectional.only(top: 50),
            width: double.infinity,
            child: Column
            (
              children:
              [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children:
                    [
                      MaterialButton(onPressed: (){Navigator.pop(context);}, child: Icon(Icons.arrow_back, color: Colors.white, size: 30,), padding: EdgeInsets.zero,),
                    ],
                  ),
                ),
                //Text With Drawer Button
               adminTopTitleWithDrawerButton(scaffoldKey: scaffoldKey, title: 'Requests', size: 40, hasDrawer: true),
                Expanded(
                  child: ListView.separated
                  (
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) => requestedMaterialBuilder(backgroundColor),
                    separatorBuilder: (context, index) => const Padding(padding: EdgeInsetsDirectional.all(5)),
                    itemCount: 10
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget requestedMaterialBuilder(List<String> colorText)
  {
    var random = Random();

    int min = 0;
    int max = 9;
    int randomNum = min + random.nextInt(max - min + 1);

    return Container(
      decoration: BoxDecoration(color: HexColor('${colorText[randomNum].toString()}').withOpacity(0.45), borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsetsDirectional.symmetric(horizontal: 10),
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
      height: 180,
      child: Column
      (
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
        [
          //pfp, name, subject
          Padding(
            padding: const EdgeInsetsDirectional.only(bottom: 5, top: 10),
            child: Row(
              children:
              [
                CircleAvatar(backgroundImage: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcStCJpmc7wNF8Ti2Tuh_hcIRZUGOc23KBTx2A&s'), radius: 20,),
                SizedBox(width: 10,),
                Text('Name', style: TextStyle(fontSize: 18, color: Colors.grey[300]),),
                Spacer(),
                ConstrainedBox
                (
                  constraints: BoxConstraints(maxWidth: 100,),
                  child: Text('Subject Name', style: TextStyle(color: Colors.grey[300]),maxLines: 1, overflow: TextOverflow.ellipsis, textWidthBasis: TextWidthBasis.longestLine,),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 10.0, end: 10, top: 5, bottom: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Chapter Or lecture', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),),
                Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.', style: TextStyle(fontSize: 14, color: Colors.grey[300]), maxLines: 2, overflow: TextOverflow.ellipsis,),
              ],
            ),
          ),
          //Link Icon, Link Content preview, accept, decline
          LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                children: [
                  Icon(Icons.link, color: Colors.white),
                  SizedBox(width: 5),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: constraints.maxWidth - 140, // Subtract extra pixels from the remaining width
                    ),
                    child: Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                      style: TextStyle(color: Colors.white),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Spacer(), // Pushes the buttons to the end of the row
                  // Checkmark button
                  MaterialButton(
                    onPressed: () {
                      // Add action for checkmark button
                    },
                    shape: CircleBorder(), // Circular button
                    child: Icon(Icons.check, color: Colors.green,), // Checkmark icon
                    minWidth: 0, // Reduce min width to make it smaller
                    padding: EdgeInsets.all(8), // Padding for icon
                  ),
                  // X button
                  MaterialButton(
                    onPressed: () {
                      // Add action for X button
                    },
                    shape: CircleBorder(), // Circular button
                    child: Icon(Icons.close, color: Colors.red,), // X icon
                    minWidth: 0, // Reduce min width to make it smaller
                    padding: EdgeInsets.all(8), // Padding for icon
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
