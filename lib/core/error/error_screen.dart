import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import '../utils/components.dart';
import '../utils/resources/constants_manager.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(top: 20),
          child: Column(
            children: [
              Positioned(
                left: 0,
                top: 0,
                child: backButton(context),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Center(
                      child: Text(
                        '404',
                        style: TextStyle(
                            fontSize: AppQueries.screenWidth(context) / 4,
                            color: HexColor('#FF6A71'),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      'This link is Corrupted',
                      style: TextStyle(
                          fontSize: AppQueries.screenWidth(context) / 17, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
