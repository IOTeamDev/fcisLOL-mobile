import 'package:flutter/material.dart';

snack({required titleWidget, required context, required enumColor}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: snakeColor(enumColor),
    duration: const Duration(seconds: 1),
    content: titleWidget,
  ));
}

enum Messages { success, warning, error }

Color snakeColor(Messages enumColor) {
  switch (enumColor) {
    case Messages.success:
      return Colors.green;

    case Messages.warning:
      return Colors.yellow;

    case Messages.error:
      return Colors.red;

    default:
      return Colors.grey;
  }
}
