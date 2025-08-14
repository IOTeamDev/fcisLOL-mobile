import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lol/core/presentation/screen_size.dart';
import 'package:lol/core/resources/theme/colors_manager.dart';
import 'package:lol/core/resources/constants/constants_manager.dart';
import 'package:lol/core/resources/theme/values/values_manager.dart';
import 'package:lol/core/utils/responsive/device_type.dart';
import 'package:lol/features/home/data/models/semster_model.dart';

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
    return Wrap(
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SizedBox(
          width: getDeviceType(context) != DeviceType.MOBILE
              ? 300
              : ScreenSize.width(context) * 0.45,
          child: DropdownButtonFormField<String>(
            validator: validator ??
                (value) {
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
            style: TextStyle(color: ColorsManager.black),
            decoration: InputDecoration(
              labelStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: ColorsManager.black,
                  ),
              labelText: value ?? labelText,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizesDouble.s15)),
              filled: true,
              fillColor: ColorsManager.grey3,
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: ColorsManager.lightPrimary),
                  borderRadius: BorderRadius.circular(AppSizesDouble.s15)),
            ),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        if (value != null)
          Text(
            'Level ${(getSemesterIndex(value!) / AppSizes.s2 + AppSizes.s1).floor()}',
            style: Theme.of(context).textTheme.titleLarge,
          )
      ],
    );
  }
}
