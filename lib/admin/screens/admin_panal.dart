import 'package:flutter/material.dart';
import 'package:lol/admin/screens/add_anouncment.dart';
import 'package:lol/admin/screens/requests.dart';
import 'package:lol/main.dart';
import 'package:lol/utilities/navigation.dart';

class AdminPanal extends StatelessWidget {
  const AdminPanal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 1, shadowColor: Colors.black, title: Text('Admin Panel'),),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox
            (
              height: 60,
            ),
            
            Container
            (
              margin: EdgeInsets.only(left: 30, right: 30, bottom: 30),
              width: double.infinity,
              decoration: BoxDecoration
              (
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(40)
              ),
              child: MaterialButton
              (
                onPressed: () {navigate(context, Requests());},
                child: Text("Accept requested material"),
              )
            ),
            Container(
              height: 50,
                margin: EdgeInsets.only(left: 30, right: 30, bottom: 30),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(40)),
                child: MaterialButton(
                  
                  onPressed: () {
                    navigate(context, AddAnouncment());
                  },
                  child: Text("Add Anouncment"),
                ))
          ],
        ),
      ),
    );
  }
}
