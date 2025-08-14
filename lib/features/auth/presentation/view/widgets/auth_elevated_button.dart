import 'package:flutter/material.dart';
import 'package:lol/core/presentation/screen_size.dart';
import 'package:lol/core/resources/theme/colors_manager.dart';
import 'package:lol/core/resources/theme/values/values_manager.dart';

class AuthElevatedButton extends StatelessWidget {
  const AuthElevatedButton({
    super.key,
    this.onPressed,
    required this.text,
  });
  final void Function()? onPressed;
  final String text;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          foregroundColor: ColorsManager.white,
          fixedSize: Size(ScreenSize.width(context), AppSizesDouble.s50),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizesDouble.s15)),
          backgroundColor: ColorsManager.lightPrimary),
      onPressed: onPressed,
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .headlineLarge!
            .copyWith(color: ColorsManager.white),
      ),
    );
  }
}
