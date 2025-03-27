import 'package:flutter/material.dart';

import '../../../../../core/cubits/main_cubit/main_cubit.dart';
import '../../../../../core/utils/components.dart';
import '../../../../../core/utils/resources/colors_manager.dart';

class OtherExams extends StatelessWidget {
  const OtherExams({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Other Exams',
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
            MainCubit.get(context).previousExamsOther[index].title,
            MainCubit.get(context).previousExamsOther[index].link,
            MainCubit.get(context).profileModel!.role
          ),
          separatorBuilder: (context, index) => SizedBox(height: 10,),
          itemCount: MainCubit.get(context).previousExamsOther.length,
        ),
      ],
    );
  }
}
