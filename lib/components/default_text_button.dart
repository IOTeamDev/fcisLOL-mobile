import 'package:flutter/material.dart';

Widget defaultTextButton(
    {required onPressed, required String text, Color color = Colors.black}) {
  return TextButton(
    onPressed: onPressed,
    child: Text(
      text,
      style: TextStyle(color: color),
    ),
  );
}
