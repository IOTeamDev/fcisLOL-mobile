import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lol/constants/constants.dart';
import 'package:lol/shared/components/components.dart';

class AnnouncementDetail extends StatelessWidget {

  final String title;
  final String description;
  final String date;

  AnnouncementDetail(this.title,  this.description,  this.date);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          backgroundEffects(),
          Container(
            margin: const EdgeInsetsDirectional.only(top: 50),
            width: double.infinity,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children:
                    [
                      MaterialButton(onPressed: (){Navigator.pop(context);}, child: Icon(Icons.arrow_back, color: Colors.white, size: 30,), padding: EdgeInsets.zero,),
                    ],
                  ),
                ),
                adminTopTitleWithDrawerButton(title: 'Announcement',size: 35, hasDrawer: false),
                Container(
                  margin: EdgeInsetsDirectional.symmetric(horizontal: 15, vertical: 20),
                  padding: EdgeInsets.all(15),
                  width: double.infinity,
                  height: screenHeight(context)/1.45,
                  decoration: BoxDecoration(gradient: LinearGradient(colors: [HexColor('DA22FF').withOpacity(0.45), HexColor('9B35F3').withOpacity(0.45)], begin: Alignment.bottomRight, end: Alignment.topLeft), borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //pfp and name
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(backgroundImage: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcStCJpmc7wNF8Ti2Tuh_hcIRZUGOc23KBTx2A&s'), radius: 20,),
                          SizedBox(width: 10,),
                          Text('Name Very Long', style: TextStyle(fontSize: 14, color: Colors.white),),
                        ],
                      ),
                      SizedBox(height: 20,),
                      Text('$title',style: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.bold),),
                      SizedBox(height: 20,),
                      Container(
                        padding: EdgeInsets.all(15),
                        width: double.infinity,
                        decoration: BoxDecoration(color: HexColor('D9D9D9').withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('$description', style: TextStyle(color: Colors.white, ),),
                            Padding(
                              padding: const EdgeInsetsDirectional.symmetric(vertical: 25.0),
                              child: Text('DeadLine: $date', style: TextStyle(color: Colors.white, ),),
                            ),
                            if(true)
                              Padding(
                                padding: const EdgeInsetsDirectional.only(top: 10.0),
                                child: Row
                                  (
                                  children: [
                                    ElevatedButton(onPressed: (){}, child: Text('Remove', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),), style: ElevatedButton.styleFrom(backgroundColor: Colors.red.withOpacity(0.76), foregroundColor: Colors.white, padding: EdgeInsetsDirectional.symmetric(horizontal: 30)),),
                                    Spacer(),
                                    ElevatedButton(onPressed: (){}, child: Text('Edit', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),), style: ElevatedButton.styleFrom(backgroundColor: Colors.white.withOpacity(0.35), foregroundColor: Colors.white, padding: EdgeInsetsDirectional.symmetric(horizontal: 40)),),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
