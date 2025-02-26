import 'package:flutter/material.dart';
import 'package:lol/core/utils/resources/constants_manager.dart';

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
      minWidth: AppQueries.screenWidth(context) / 3,
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
