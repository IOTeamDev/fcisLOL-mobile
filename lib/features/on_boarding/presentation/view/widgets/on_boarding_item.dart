import 'package:flutter/material.dart';
import 'package:lol/core/utils/resources/colors_manager.dart';
import 'package:lol/features/on_boarding/data/model/on_boarding_model.dart';

class OnBoardingItem extends StatelessWidget {
  const OnBoardingItem({super.key, required this.model});
  final OnBoardingModel model;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned.fill(
            child: Image.asset(
          model.image!,
          fit: BoxFit.cover,
        )),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            model.title!,
            style: TextStyle(
              fontSize: 50,
              letterSpacing: 1.2,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  offset: Offset(3, 3), // X and Y offset
                  blurRadius: 5.0, // Spread of the shadow
                  color: ColorsManager.black
                      .withValues(alpha: 0.4), // Shadow color
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
