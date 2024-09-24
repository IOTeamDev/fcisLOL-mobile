import 'package:flutter/material.dart';
import 'package:lol/main/bloc/main_cubit.dart';
import 'package:lol/main/screens/home.dart';

class pa extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Custom Drawer Example"),
      ),
      drawer: CustomDrawer(), // Custom Drawer
      body: Center(
        child: Text('Main Page Content'),
      ),
    );
  }
}

