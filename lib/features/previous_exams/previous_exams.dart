import 'package:flutter/material.dart';

import '../../core/utils/resources/strings_manager.dart';

class PreviousExams extends StatelessWidget {
  const PreviousExams({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringsManager.exams, style: Theme.of(context).textTheme.displayMedium,),
        centerTitle: true,
      ),
      body: Column(

      ),
    );
  }
}
