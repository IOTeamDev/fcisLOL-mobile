import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lol/constants/constants.dart';

import '../../shared/components/components.dart';

class AddAnouncment extends StatefulWidget {

  @override
  State<AddAnouncment> createState() => _AddAnouncmentState();
}

class _AddAnouncmentState extends State<AddAnouncment> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  double _height = 80;
  bool isExpanded = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: drawerBuilder(context),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          backgroundEffects(),
          Container
          (
            margin: const EdgeInsetsDirectional.only(top: 50),
            width: double.infinity,
            child: Column
            (
              children:
              [
                //back button
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children:
                    [
                      MaterialButton(onPressed: (){Navigator.pop(context);}, child: Icon(Icons.arrow_back, color: Colors.white, size: 30,), padding: EdgeInsets.zero,),
                    ],
                  ),
                ),
                adminTopTitleWithDrawerButton(scaffoldKey, 'Announcements', 32),
                GestureDetector(
                  onTap: ()
                  {
                    setState(() {
                      isExpanded = true; // Toggle the expansion
                      _height = 300 ;
                     });
                  },
                  child: AnimatedContainer(
                    margin: EdgeInsetsDirectional.symmetric(vertical: 20, horizontal: 10),
                    duration: Duration(milliseconds: 500),
                    width: double.infinity,
                    height: _height,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: HexColor('B8A8F9').withOpacity(0.20)),
                    curve: Curves.fastEaseInToSlowEaseOut,
                    child: isExpanded? Padding(
                      padding: const EdgeInsetsDirectional.symmetric(horizontal: 10.0, vertical: 10),
                      child: Column(
                        children:
                       [
                         TextFormField
                         (
                           maxLines: null,
                           decoration: InputDecoration
                           (
                             hintText: 'Title',
                             hintStyle: TextStyle(fontSize: 20, color: Colors.grey[400]),
                             border: InputBorder.none,
                           ),
                           style: TextStyle(color: Colors.white),
                         ),
                         divider(),
                         SizedBox(height: 10,),
                         TextFormField
                         (
                           minLines: 2,
                           maxLines: 5,
                           keyboardType: TextInputType.multiline,
                           decoration: InputDecoration
                           (
                             hintText: 'Description',
                             hintStyle: TextStyle
                             (
                               fontSize: 20,
                               color: Colors.grey[400],
                             ),
                             border:  InputBorder.none,
                           ),
                           style: TextStyle(color: Colors.white),
                         ),
                         SizedBox(height: 20,),
                         divider(),
                         Spacer(),
                         Padding(
                           padding: const EdgeInsetsDirectional.symmetric( horizontal: 10.0),
                           child: Row(
                             children: [
                               ElevatedButton(onPressed: (){setState(() {
                                 isExpanded = false; // Toggle the expansion
                                 _height = 80 ;
                               });}, child: Text('Canel'), style: ElevatedButton.styleFrom(padding: EdgeInsetsDirectional.symmetric(horizontal: 35),  backgroundColor: HexColor('D9D9D9').withOpacity(0.2), foregroundColor: Colors.white, textStyle: TextStyle(fontSize: 15),),),
                               Spacer(),
                               ElevatedButton(onPressed: (){}, child: Text('Submit'), style: ElevatedButton.styleFrom(padding: EdgeInsetsDirectional.symmetric(horizontal: 40), backgroundColor: HexColor('B8A8F9'), foregroundColor: Colors.white, textStyle: TextStyle(fontSize: 15),)),
                             ],
                           ),
                         )
                       ],
                      ),
                    ): Padding(
                      padding: EdgeInsetsDirectional.symmetric(vertical: 10, horizontal: 10),
                      child: Row(
                        children: [
                          Text('Add New', style: TextStyle(fontSize: 30, color: Colors.white),),
                          Spacer(),
                          Icon(Icons.add, color: Colors.white, size: 40,),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) => announcementBuilder(),
                    separatorBuilder: (context, index) =>  const SizedBox(height: 10,),
                    itemCount: 10,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget announcementBuilder()
  {
    return Container
    (
      margin: EdgeInsetsDirectional.symmetric(horizontal: 10),
      padding: EdgeInsetsDirectional.symmetric(horizontal: 10),
      height: 80,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: HexColor('B8A8F9')),
      child: Row(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: screenWidth(context) - 140),
              child: Text('Lorem Ipsum dollor ad;fkajd;lfkja;ldfjsad;lfk', style: TextStyle(fontSize: 20, color: Colors.white), maxLines: 1, overflow: TextOverflow.ellipsis,),
          ),
          MaterialButton(
            onPressed: () {
              // Add action for X button
            },
            shape: const CircleBorder(), // X icon
            minWidth: 0, // Reduce min width to make it smaller
            padding: const EdgeInsets.all(5), // Circular button
            child: const Icon(Icons.edit, color: Colors.green,), // Padding for icon
          ),
          MaterialButton(
            onPressed: () {
              // Add action for X button
            },
            shape: const CircleBorder(), // X icon
            minWidth: 0, // Reduce min width to make it smaller
            padding: const EdgeInsets.all(5), // Circular button
            child: const Icon(Icons.delete_sharp, color: Colors.red,), // Padding for icon
          ),
        ],
      ),
    );
  }
}
