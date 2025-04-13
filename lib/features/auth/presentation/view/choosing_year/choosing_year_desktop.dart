import 'package:flutter/material.dart';
import 'package:lol/core/network/local/shared_preference.dart';
import 'package:lol/core/utils/components.dart';
import 'package:lol/core/utils/resources/colors_manager.dart';
import 'package:lol/core/utils/resources/values_manager.dart';
import 'package:lol/features/auth/presentation/view/registration_layout.dart';
import 'package:lol/features/home/data/models/semster_model.dart';
import 'package:lol/features/home/presentation/view/home.dart';

import '../../../../../core/utils/resources/constants_manager.dart';
import '../../../../../core/utils/resources/icons_manager.dart';
import '../../../../../core/utils/resources/strings_manager.dart';

class ChoosingYearDesktop extends StatefulWidget {
  ChoosingYearDesktop({
    super.key,
  });

  @override
  State<ChoosingYearDesktop> createState() => _ChoosingYearState();
}

class _ChoosingYearState extends State<ChoosingYearDesktop> {
  String? selectedSemester;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            StringsManager.yearSelect,
            style: Theme.of(context)
                .textTheme
                .displayLarge!
                .copyWith(fontSize: 40),
          ),
          SizedBox(
            height: 40,
          ),
          Container(
            height: 50,
            width: 450,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: ColorsManager.white,
                borderRadius: BorderRadius.circular(AppSizesDouble.s40)),
            padding: EdgeInsets.only(
              right: 15,
            ),
            child: Row(
              children: [
                Container(
                  width: 170,
                  height: double.infinity,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(right: 15),
                  decoration: BoxDecoration(
                      boxShadow: [BoxShadow()],
                      color: ColorsManager.darkPrimary,
                      borderRadius: BorderRadius.circular(AppSizesDouble.s40)),
                  child: FittedBox(
                    child: Text(
                      'Level: ${getLevelFromSemester()}',
                      style: TextStyle(fontSize: 20),
                    ),

                  ),
                ),
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    icon: Icon(IconsManager.dropdownIcon),
                    value: selectedSemester,
                    underline: SizedBox(),
                    hint: Text('Select Semester',
                        style: TextStyle(color: ColorsManager.grey)),
                    dropdownColor: ColorsManager
                        .white, // Background color for the dropdown list
                    iconEnabledColor:
                    ColorsManager.black, // Color of the dropdown icon
                    style: const TextStyle(
                        color: ColorsManager
                            .white), // Style for the selected item outside
                    items: AppConstants.semesters
                        .map((String item) => DropdownMenuItem(
                      value: item,
                      child: Text(
                        item,
                        style:
                        const TextStyle(color: ColorsManager.black),
                      ),
                    ))
                        .toList(),
                    selectedItemBuilder: (BuildContext context) {
                      return AppConstants.semesters.map((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: FittedBox(
                            child: Text(
                              'Semester: $item',
                              style: const TextStyle(
                                  color: ColorsManager.black, fontSize: 16),
                            ),
                          ),
                        );
                      }).toList();
                    },
                    onChanged: (value) {
                      setState(() {
                        selectedSemester = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 5),
            child: SizedBox(
              width: 450,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: ColorsManager.lightPrimary,
                      foregroundColor: ColorsManager.white,
                      padding: EdgeInsets.symmetric(vertical: 20)),
                  onPressed: onPressedSelectButton,
                  child: FittedBox(
                      child: Text(
                        'Select',
                        style: TextStyle(fontSize: 20),
                      ))),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                StringsManager.alreadyHaveAccount,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegistrationLayout(),
                      ),
                          (route) => false);
                },
                child: Text(
                  StringsManager.login,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: ColorsManager.dodgerBlue),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String getLevelFromSemester() {
    if (selectedSemester == 'One' || selectedSemester == 'Two') {
      return '1';
    } else if (selectedSemester == 'Three' || selectedSemester == 'Four') {
      return '2';
    } else if (selectedSemester == 'Five' || selectedSemester == 'Six') {
      return '3';
    } else if (selectedSemester == 'Seven' || selectedSemester == 'Eight') {
      return '4';
    }
    return '';
  }

  Future<void> onPressedSelectButton() async {
    if (selectedSemester != null) {
      AppConstants.SelectedSemester = selectedSemester;
      await Cache.writeData(key: KeysManager.semester, value: selectedSemester);
      AppConstants.navigatedSemester = AppConstants.SelectedSemester;
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Home()), (route) => false);
    } else {
      showToastMessage(
        message: 'Please select a semester',
        states: ToastStates.INFO,
      );
    }
  }
}
