import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import '../utilities/shared_prefrence.dart';

screenHeight(context) => MediaQuery.of(context).size.height;
screenWidth(context) => MediaQuery.of(context).size.width;
Widget defaultForm(
    {String? label,
    bool enabled = true,
    bool wantMargin = true,
    bool isDark = false,
    onChanged,
    IconData? dtaPrefIcon,
    suffFunc,
    Icon? dtaSufIcon,
    controller,
    String? Function(String?)? validateor,
    onFieldSubmitted,
    bool obscure = false,
    type}) {
  return Container(
    // width: 400,
    height: 45,

    margin: EdgeInsets.symmetric(vertical: wantMargin ? 5 : 0),

    child: TextFormField(
      // textAlign: TextAlign.center,
      // focusNode: FocusNode(),

      enabled: enabled,
      onChanged: onChanged,
      keyboardType: type,
      // readOnly: readOnly,

      obscureText: obscure,
      onFieldSubmitted: onFieldSubmitted,
      validator: validateor,
      controller: controller,
      style: isDark
          ? const TextStyle(color: Colors.white, fontFamily: '')
          : const TextStyle(fontFamily: 'no'),
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.only(top: 10, bottom: 5, left: 10, right: 10),

        label: Text(label ?? "",
            style: TextStyle(color: isDark ? Colors.white : null)),
        border: const OutlineInputBorder(),
        suffixIcon: dtaSufIcon == null
            ? null
            : IconButton(
                icon: dtaSufIcon,
                onPressed: suffFunc,
              ),
        prefixIcon: dtaPrefIcon == null
            ? null
            : Icon(
                dtaPrefIcon,
                color: isDark ? Colors.white : null,
              ), // Use prefixIcon instead of prefix
      ),
    ),
  );
}

Widget defaultButton(
    {required buttonFunc,
    required isText,
    String? title,
    buttonIcon,
    required double buttonWidth}) {
  return buttonWidth == 0
      ? MaterialButton(
          minWidth: 0,
          onPressed: buttonFunc,
          child: isText == null
              ? null
              : isText
                  ? title == null
                      ? null
                      : Text(
                          title,
                          style: const TextStyle(color: Colors.white),
                        )
                  : buttonIcon,
        )
      : Container(
          decoration: BoxDecoration(
              color: const Color(0xff191C3B),
              borderRadius: BorderRadius.circular(0)),
          height: 50,
          width: buttonWidth,
          child: MaterialButton(
            onPressed: buttonFunc,
            child: isText == null
                ? null
                : isText
                    ? title == null
                        ? null
                        : Text(
                            title,
                            style: const TextStyle(color: Colors.white),
                          )
                    : buttonIcon,
          ),
        );
}

navigatReplace(context, targetPage) {
  Navigator.of(context).pushReplacement(MaterialPageRoute(
    builder: (context) => targetPage,
  ));
}

navigat(context, targetPage) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => targetPage,
  ));
}

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

void signOut({required String key}) {
  Cache.removeValue(key: key);
}

Widget halfDivider(context) {
  return const Divider(
    height: 1,
    // width: ScreenWidth(context),
    color: Colors.grey,
  );
}

Future<AwesomeDialog> dialgoAwesome({
  context,
  required String title,
  VoidCallback? btnCancelOnPress,
  VoidCallback? btnOkOnPress,
  required DialogType type,
  btnCancelColor,
  btnOkColor,
  String? btnOkText,
  String? btnCancelText,
}) async {
  return await AwesomeDialog(
          context: context,
          dialogType: type,
          animType: AnimType.rightSlide,
          title: title,
          btnCancelColor: btnCancelColor,
          btnOkColor: btnOkColor,
          btnOkText: btnOkText,
          btnCancelText: btnCancelText,
          btnCancelOnPress: btnCancelOnPress,
          btnOkOnPress: btnOkOnPress)
      .show();
}
