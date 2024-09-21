import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lol/shared/components/components.dart';

import '../../../constants/constants.dart';

class RequestsDetails extends StatelessWidget {

  int id;
  String title;
  String description;
  String subjectName;
  String link;
  String pfp;
  String type;
  String authorName;

  RequestsDetails({required this.authorName, required this.type, required this.description, required this.link, required this.subjectName, required this.id, required this.title, required this.pfp});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          backgroundEffects(),
          Container
          (
            margin: const EdgeInsetsDirectional.only(top: 50),
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column
              (
                children: [
                  backButton(context),
                  adminTopTitleWithDrawerButton(title: 'Request Detail', hasDrawer: false, size: 40),
                  Container(
                    margin: const EdgeInsetsDirectional.symmetric(horizontal: 15, vertical: 20),
                    padding: const EdgeInsets.all(15),
                    width: double.infinity,
                    height: screenHeight(context) / 1.45,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          HexColor('F4BEFF').withOpacity(0.2),
                          HexColor('271D30').withOpacity(0.2)
                      ], begin: Alignment.bottomRight, end: Alignment.topLeft),
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), gradient: LinearGradient(
                          colors: [
                            HexColor('BC94FF').withOpacity(0.5),
                            HexColor('BC94FF').withOpacity(1)
                          ], begin: Alignment.bottomRight, end: Alignment.topLeft),
                          boxShadow: [BoxShadow(color: Colors.black54.withOpacity(0.2), spreadRadius: 7, blurRadius: 15)]),
                      child: Column(
                        children: [
              
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ),
        ],
      ),
    );
  }
}
