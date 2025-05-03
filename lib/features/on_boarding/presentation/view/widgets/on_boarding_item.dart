import 'package:flutter/material.dart';
import 'package:lol/core/utils/resources/colors_manager.dart';
import 'package:lol/core/utils/resources/values_manager.dart';
import 'package:lol/features/on_boarding/data/model/on_boarding_model.dart';

class OnBoardingItem extends StatelessWidget {
  const OnBoardingItem({super.key, required this.model});
  final OnBoardingModel model;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(AppPaddings.p20),
            child: Image.asset(
              model.image!,
              fit: BoxFit.contain,
            ),
          ),
        ),
        SizedBox(height: AppSizesDouble.s20,),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppPaddings.p20),
          child: Text(
            model.title!,
            maxLines: 4,
            style: TextStyle(
              fontSize: AppSizesDouble.s40,
              letterSpacing: AppSizesDouble.s1_2,
              fontWeight: FontWeight.bold,
              color: ColorsManager.white,
              shadows: [
                Shadow(
                  offset: Offset(AppSizesDouble.s3, AppSizesDouble.s3), // X and Y offset
                  blurRadius: AppSizesDouble.s10, // Spread of the shadow
                  color: ColorsManager.black.withValues(alpha: AppSizesDouble.s0_4), // Shadow color
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
