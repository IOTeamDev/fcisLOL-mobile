import 'package:flutter/material.dart';

class Requests extends StatelessWidget {
  const Requests({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold
    (
      appBar: AppBar(elevation: 10, shadowColor: Colors.black, title: Text('Requests Screen'),),
      body: Center(child: Text('Requests Screen'),),
    );
  }

  Widget requestedMaterialBuilder()
  {
    return Container();
  }
}
