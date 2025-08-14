import 'package:flutter/material.dart';
import 'package:lol/core/resources/theme/values/app_strings.dart';

class UsefulLinks extends StatelessWidget {
  const UsefulLinks({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.links,
          style: Theme.of(context).textTheme.displayMedium,
        ),
        centerTitle: true,
      ),
      body: Column(),
    );
  }
}
