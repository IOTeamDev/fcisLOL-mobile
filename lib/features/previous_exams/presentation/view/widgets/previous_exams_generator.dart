import 'package:flutter/material.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit.dart';
import 'package:lol/core/utils/components.dart';
import 'package:lol/core/utils/resources/colors_manager.dart';
import 'package:lol/features/previous_exams/data/previous_exams_model.dart';

class PreviousExamsGenerator extends StatelessWidget {
  String semester;
  List<PreviousExamModel> previousExamList;
  PreviousExamsGenerator({super.key, required this.semester, required this.previousExamList});

  @override
  Widget build(BuildContext context) {
    return SliverList.separated(
      itemBuilder: (context, index) {
        final reversedIndex = previousExamList.length -1 - index;
        return previousExamsBuilder(
          context,
          previousExamList[reversedIndex],
          MainCubit.get(context).profileModel?.role??'STUDENT',
          semester
        );
      },
      separatorBuilder: (context, index) => SizedBox(height: 10,),
      itemCount: previousExamList.length,
    );
  }
  
}
