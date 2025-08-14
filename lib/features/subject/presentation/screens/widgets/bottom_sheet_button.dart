import 'package:flutter/material.dart';
import 'package:lol/core/presentation/screen_size.dart';
import 'package:lol/core/resources/constants/constants_manager.dart';

class BottomSheetButton extends StatelessWidget {
  const BottomSheetButton(
      {super.key,
      this.onPressed,
      required this.text,
      this.color,
      this.textStyle});
  final void Function()? onPressed;
  final String text;
  final Color? color;
  final TextStyle? textStyle;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: const EdgeInsets.symmetric(vertical: 10),
      minWidth: ScreenSize.width(context) / 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: color,
      onPressed: onPressed,
      child: Text(
        text,
        style: textStyle ?? TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }
}
