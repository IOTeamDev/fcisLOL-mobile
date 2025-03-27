import 'package:flutter/material.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit.dart';
import 'package:lol/core/utils/components.dart';
import 'package:lol/core/utils/resources/colors_manager.dart';

class FinalExams extends StatelessWidget {

  FinalExams({super.key,});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Final Exams',
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
            MainCubit.get(context).previousExamsFinal[index].title,
            MainCubit.get(context).previousExamsFinal[index].link,
            MainCubit.get(context).profileModel!.role
          ),
          separatorBuilder: (context, index) => SizedBox(height: 10,),
          itemCount: MainCubit.get(context).previousExamsFinal.length,
        ),
        if(MainCubit.get(context).previousExamsOther.isNotEmpty || MainCubit.get(context).previousExamsMid.isNotEmpty)
        divider(color: ColorsManager.white),
        if(MainCubit.get(context).previousExamsOther.isNotEmpty || MainCubit.get(context).previousExamsMid.isNotEmpty)
        SizedBox(height: 15,),
      ],
    );
  }
  
}
