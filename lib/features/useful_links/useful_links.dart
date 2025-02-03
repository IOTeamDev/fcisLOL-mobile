import 'package:flutter/material.dart';
import 'package:lol/core/utils/resources/strings_manager.dart';

class UsefulLinks extends StatelessWidget {
  const UsefulLinks({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringsManager.links, style: Theme.of(context).textTheme.displayMedium,),
        centerTitle: true,
      ),
      body: Column(

      ),
    );
  }
}
