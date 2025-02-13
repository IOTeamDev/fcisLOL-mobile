import 'package:flutter/material.dart';
import 'package:lol/features/on_boarding/data/model/on_boarding_model.dart';

class OnBoardingItem extends StatelessWidget {
  const OnBoardingItem({super.key, required this.model});
  final OnBoardingModel model;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 50,
        ),
        Text(
          model.title!,
          style: const TextStyle(
            fontSize: 21.5,
            letterSpacing: 2.5,
            fontWeight: FontWeight.w700,
          ),
        ),
        Expanded(child: Image.asset(model.image!)),
        Center(
          child: Text(
            textAlign: TextAlign.center,
            model.body!,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
        ),
        const SizedBox(
          height: 100,
        ),
      ],
    );
  }
}
