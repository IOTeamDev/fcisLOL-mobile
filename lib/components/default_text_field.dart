import 'package:flutter/material.dart';

Widget defaultTextField(
    {String? Function(String?)? validateor,
    IconData? dtaPrefIcon,
    Icon? dtaSufIcon,
    String? label,
    bool obscure = false,
    bool enabled = true,
    bool wantMargin = true,
    bool isDark = false,
    onChanged,
    suffFunc,
    controller,
    onFieldSubmitted,
    type}) {
  return Container(
    height: 45,
    margin: EdgeInsets.symmetric(vertical: wantMargin ? 5 : 0),
    child: TextFormField(
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
