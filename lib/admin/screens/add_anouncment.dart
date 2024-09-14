import 'package:flutter/material.dart';

class AddAnouncment extends StatelessWidget {
  const AddAnouncment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container
      (
        child: Column
        (
          children:
          [
            TextButton
            (
                onPressed: () {},
                child: Text("data"),
            )
          ],
        ),
      ),
    );
  }
}
