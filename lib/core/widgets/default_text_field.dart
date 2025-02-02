import 'package:flutter/material.dart';
import 'package:lol/core/utils/colors.dart';

import '../utils/resources/colors_manager.dart';

Widget defaultTextField(
    {String? Function(String?)? validateor,
    IconData? dtaPrefIcon,
    Icon? dtaSufIcon,
    String? label,
    bool obscure = false,
    bool enabled = true,
    bool wantMargin = true,
    bool isDark = false,
    TextInputAction? textInputAction,
    onChanged,
    suffFunc,
    controller,
    onFieldSubmitted,
    type}) {
  return Container(
    height: 45,
    margin: EdgeInsets.symmetric(vertical: wantMargin ? 5 : 0),
    child: TextFormField(
      textInputAction: textInputAction ?? TextInputAction.none,
      enabled: enabled,
      onChanged: onChanged,
      keyboardType: type,
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

Widget customTextFormField(
    {required String title,
    required TextEditingController controller,
    required TextInputType keyboardtype,
    int? maxLines,
    bool isDescription = false,
    bool autoFocus = false}) {
  return TextFormField(
    autofocus: autoFocus,
    maxLines: maxLines,
    keyboardType: keyboardtype,
    textInputAction: TextInputAction.next,
    validator: (value) {
      if (value == null || value.isEmpty && !isDescription) {
        return 'This field must not be Empty';
      }
      return null;
    },
    style: TextStyle(color: ColorsManager.lightCyan, fontSize: 20),
    controller: controller,
    decoration: InputDecoration(
        fillColor: const Color.fromRGBO(217, 217, 217, 0.25),
        filled: true,
        contentPadding: const EdgeInsets.all(20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        hintText: title,
        hintStyle: const TextStyle(
          color: Color.fromRGBO(255, 255, 255, 0.48),
          fontSize: 22,
        )),
  );
}
