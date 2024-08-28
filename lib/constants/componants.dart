
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:lol/Constants/color.dart';

import '../shared_prefrence/shared_prefrence.dart';

ScreenHeight(context) => MediaQuery.of(context).size.height;
ScreenWidth(context) => MediaQuery.of(context).size.width;
Widget defaultForm(
    {String? label,
    bool enabled = true,
    bool WantMargin = true,
    bool isDark = false,
    onChanged,
    IconData? dtaPrefIcon,
    suff_func,
    Icon? dtaSufIcon,
    controller,
    String? Function(String?)? validateor,
    onFieldSubmitted,
    bool Obscure = false,
    type}) {
  return Container(
    // width: 400,
    height: 45,

    margin: EdgeInsets.symmetric(vertical: WantMargin ? 5 : 0),

    child: TextFormField(
      // textAlign: TextAlign.center,
      // focusNode: FocusNode(),

      enabled: enabled,
      onChanged: onChanged,
      keyboardType: type,
      // readOnly: readOnly,

      ///عدل كسم الانواع دي
      obscureText: Obscure,
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
                onPressed: suff_func,
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
    {required ButtonFunc,
    required isText,
    String? Title,
    ButtonIcon,
    required double ButtonWidth}) {
  return ButtonWidth == 0
      ? MaterialButton(
          minWidth: 0,
          onPressed: ButtonFunc,
          child: isText == null
              ? null
              : isText
                  ? Title == null
                      ? null
                      : Text(
                          Title,
                          style: const TextStyle(color: Colors.white),
                        )
                  : ButtonIcon,
        )
      : Container(
          decoration: BoxDecoration(
              color: const Color(0xff191C3B), borderRadius: BorderRadius.circular(0)),
          height: 50,
          width: ButtonWidth,
          child: MaterialButton(
            onPressed: ButtonFunc,
            child: isText == null
                ? null
                : isText
                    ? Title == null
                        ? null
                        : Text(
                            Title,
                            style: const TextStyle(color: Colors.white),
                          )
                    : ButtonIcon,
          ),
        );
}

navigatReplace(context, TargetPage) {
  Navigator.of(context).pushReplacement(MaterialPageRoute(
    builder: (context) => TargetPage,
  ));
}
navigat(context, TargetPage) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => TargetPage,
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

Snake({required titleWidget, required context, required EnumColor}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: snakeColor(EnumColor),
    duration: const Duration(seconds: 1),
    content: titleWidget,
  ));
}

enum Messages { Success, Warning, Error }

Color snakeColor(Messages EnumColor) {
  switch (EnumColor) {
    case Messages.Success:
      return Colors.green;

    case Messages.Warning:
      return Colors.yellow;

    case Messages.Error:
      return Colors.red;

    default:
      return Colors.grey;
  }
}

void SignOut({required String key}) {
  Cache.removeValue(key: key);
}

Widget halfDivider(context) {
  return const Divider(
    height: 1,
    // width: ScreenWidth(context),
    color: Colors.grey,
  );
}

Future<AwesomeDialog>  dialgoAwesome({
  
  context,
   required String title,
   VoidCallback? btnCancelOnPress,
   VoidCallback ?btnOkOnPress,
   required DialogType type,
   btnCancelColor,
   btnOkColor,
   String?btnOkText,
   String?    btnCancelText
,

}) async{
  return await AwesomeDialog(
    context: context,
    dialogType: type,
    animType: AnimType.rightSlide,
    title: title,
    btnCancelColor:btnCancelColor,
    btnOkColor:btnOkColor ,
    btnOkText:btnOkText ,
    btnCancelText:btnCancelText ,
    btnCancelOnPress: btnCancelOnPress,
    btnOkOnPress: btnOkOnPress
  ).show();
}
