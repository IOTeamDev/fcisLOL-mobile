import 'package:flutter/material.dart';
import 'package:lol/core/resources/theme/colors_manager.dart';
import 'package:lol/core/resources/theme/values/app_strings.dart';
import 'package:lol/core/resources/theme/values/values_manager.dart';

class AuthTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String? label;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;
  final bool isPassword;
  const AuthTextFormField(
      {super.key,
      required this.controller,
      this.label,
      this.textInputAction = TextInputAction.done,
      this.keyboardType = TextInputType.text,
      this.validator,
      this.onFieldSubmitted,
      this.isPassword = false});

  @override
  State<AuthTextFormField> createState() => _AuthTextFormFieldState();
}

class _AuthTextFormFieldState extends State<AuthTextFormField> {
  late bool hiddenInput;

  @override
  void initState() {
    super.initState();
    hiddenInput = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: hiddenInput,
      controller: widget.controller,
      textInputAction: widget.textInputAction,
      keyboardType: widget.keyboardType,
      style: TextStyle(color: ColorsManager.black),
      decoration: InputDecoration(
        labelStyle: TextStyle(color: ColorsManager.lightGrey),
        labelText: widget.label,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizesDouble.s15)),
        filled: true,
        fillColor: ColorsManager.grey3,
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColorsManager.lightPrimary),
            borderRadius: BorderRadius.circular(AppSizesDouble.s15)),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: hiddenInput
                    ? Icon(Icons.visibility_off)
                    : Icon(Icons.visibility),
                color: hiddenInput
                    ? ColorsManager.lightGrey
                    : ColorsManager.lightPrimary,
                onPressed: () {
                  setState(() {
                    hiddenInput = !hiddenInput;
                  });
                },
              )
            : null,
      ),
      validator: widget.validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return AppStrings.emptyFieldWarning;
            }
            return null; // Form is valid.
          },
      onFieldSubmitted: widget.onFieldSubmitted,
    );
  }
}
