import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lol/core/utils/resources/colors_manager.dart';
import 'package:lol/core/utils/resources/constants_manager.dart';
import 'package:lol/core/utils/resources/values_manager.dart';

class CustomDropDownButton extends StatelessWidget {
  const CustomDropDownButton(
      {super.key,
      required this.labelText,
      required this.items,
      this.value,
      this.onChanged,
      this.validator});
  final String labelText;
  final List<String> items;
  final String? value;
  final String? Function(String?)? validator;

  final ValueChanged<String?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppQueries.screenWidth(context) * 0.5,
      child: DropdownButtonFormField<String>(
        validator: validator ??
            (String? value) {
              if (value == null || value.isEmpty || value == 'Semester') {
                return 'Please select a semester';
              }
              return null;
            },
        items: items
            .map((String item) => DropdownMenuItem(
                  value: item,
                  child: Text(
                    item,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: ColorsManager.black,
                        ),
                  ),
                ))
            .toList(),
        onChanged: onChanged,
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: ColorsManager.black,
        ),
        dropdownColor: ColorsManager.white,
        decoration: InputDecoration(
          hintStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: ColorsManager.black,
              ),
          labelStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: ColorsManager.black,
              ),
          labelText: labelText,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizesDouble.s15)),
          filled: true,
          fillColor: ColorsManager.grey3,
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: ColorsManager.lightPrimary),
              borderRadius: BorderRadius.circular(AppSizesDouble.s15)),
        ),
      ),
    );
  }
}
