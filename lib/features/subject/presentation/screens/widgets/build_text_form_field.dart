import 'package:flutter/material.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit.dart';
import 'package:lol/core/utils/resources/colors_manager.dart';
import 'package:lol/main.dart';

class BuildTextFormField extends StatelessWidget {
  const BuildTextFormField({
    super.key,
    required this.controller,
    this.hintText = '',
    this.textInputAction = TextInputAction.next,
    this.textInputType = TextInputType.text,
    this.canBeEmpty = true,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputAction textInputAction;
  final TextInputType textInputType;
  final bool canBeEmpty;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: textInputAction,
      keyboardType: textInputType,
      controller: controller,
      validator: (value) {
        if ((value == null && canBeEmpty == false) ||
            (value!.isEmpty && canBeEmpty == false)) {
          return 'This field can\'t be Empty';
        }
        return null;
      },
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: MainCubit.get(context).isDark
                    ? ColorsManager.grey
                    : ColorsManager.white)),
        hintText: hintText,
        hintStyle: TextStyle(
            fontSize: 20,
            color: MainCubit.get(context).isDark
                ? ColorsManager.grey
                : ColorsManager.white),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}
