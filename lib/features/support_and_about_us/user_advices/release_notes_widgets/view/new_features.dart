import 'package:flutter/material.dart';
import 'package:lol/core/utils/components.dart';
import 'package:lol/core/utils/resources/constants_manager.dart';
import 'package:lol/core/utils/resources/icons_manager.dart';
import 'package:lol/core/utils/resources/strings_manager.dart';
import 'package:lol/core/utils/resources/values_manager.dart';
import 'package:lol/features/support_and_about_us/user_advices/release_notes_widgets/model/release_notes_data.dart';

import '../../../../../core/utils/resources/colors_manager.dart';

class NewFeatures extends StatelessWidget {
  const NewFeatures({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          StringsManager.newFeatures,
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: ColorsManager.white,
              fontWeight: FontWeight.bold
          ),
        ),
        SizedBox(height: AppSizesDouble.s10,),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.ideographic,
            children: [
              Icon(IconsManager.circleIcon, size: AppSizesDouble.s8, color: ColorsManager.white),
              SizedBox(width: AppSizesDouble.s10,),
              Expanded(child: Text(newFeatures[index], style: Theme.of(context).textTheme.titleLarge!.copyWith(color: ColorsManager.white),))
            ],
          ),
          separatorBuilder: (context, index) => SizedBox(height: AppSizesDouble.s11,),
          itemCount: newFeatures.length
        ),
        divider(height: AppSizesDouble.s20)
      ],
    );
  }
}
