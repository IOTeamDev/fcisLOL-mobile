import 'package:flutter/material.dart';

Widget defaultButton(
    {required buttonFunc,
    required String title,
    buttonIcon,
    required double buttonWidth}) {
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
              color: const Color(0xff191C3B),
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
