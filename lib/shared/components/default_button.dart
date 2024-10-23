import 'package:flutter/material.dart';

Widget defaultButton(

    {required buttonFunc,
    required String title,
    buttonIcon,
    required double buttonWidth, required Color color}) {
  return buttonWidth == 0
      ? MaterialButton(
          minWidth: 0,
          onPressed: buttonFunc,
          child: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ))
      : Container(
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(0)),
          height: 50,
          width: buttonWidth,
          child: MaterialButton(
              onPressed: buttonFunc,
              child: Text(
                title,
                style: const TextStyle(color: Colors.white),
              )),
        );
}
