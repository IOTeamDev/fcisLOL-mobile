import 'package:flutter/material.dart';

import '../../../../../core/cubits/main_cubit/main_cubit.dart';
import '../../../../../core/utils/components.dart';
import '../../../../../core/utils/resources/colors_manager.dart';

class MidExams extends StatelessWidget {
  String semester;
  MidExams({super.key, required this.semester});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mid Exams',
          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
              color: ColorsManager.white,
              fontWeight: FontWeight.bold
          ),
        ),
        SizedBox(height: 15,),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => previousExamsBuilder(
            context,
            MainCubit.get(context).previousExamsMid[index],
            MainCubit.get(context).profileModel!.role,
            semester
          ),
          separatorBuilder: (context, index) => SizedBox(height: 10,),
          itemCount: MainCubit.get(context).previousExamsMid.length,
        ),
        if(MainCubit.get(context).previousExamsOther.isNotEmpty)
        divider(color: ColorsManager.white),
        if(MainCubit.get(context).previousExamsOther.isNotEmpty)
        SizedBox(height: 15,),
      ],
    );
  }
}
