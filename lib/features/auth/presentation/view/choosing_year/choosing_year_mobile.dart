import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lol/config/navigation/routes.dart';
import 'package:lol/core/data/local_data_provider.dart';
import 'package:lol/core/network/local/shared_preference.dart';
import 'package:lol/core/presentation/screen_size.dart';
import 'package:lol/core/utils/components.dart';
import 'package:lol/core/resources/theme/colors_manager.dart';
import 'package:lol/core/resources/theme/values/values_manager.dart';
import 'package:lol/features/auth/presentation/view/registration_layout.dart';
import 'package:lol/features/home/data/models/semster_model.dart';
import 'package:lol/features/home/presentation/view/home.dart';
import 'package:lol/features/home/presentation/view/loading_screen.dart';
import '../../../../../core/resources/constants/constants_manager.dart';
import '../../../../../core/presentation/app_icons.dart';
import '../../../../../core/resources/theme/values/app_strings.dart';

class ChoosingYearMobile extends StatefulWidget {
  ChoosingYearMobile({
    super.key,
  });

  @override
  State<ChoosingYearMobile> createState() => _ChoosingYearState();
}

class _ChoosingYearState extends State<ChoosingYearMobile> {
  String? selectedSemester;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppStrings.yearSelect,
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
            width: ScreenSize.width(context) / 1.3,
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
                  width: ScreenSize.width(context) / 2.7,
                  height: double.infinity,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(right: 7),
                  decoration: BoxDecoration(
                      boxShadow: [BoxShadow()],
                      color: ColorsManager.darkPrimary,
                      borderRadius: BorderRadius.circular(AppSizesDouble.s40)),
                  child: FittedBox(
                    child: Text(
                      'Level: ${_getLevelFromSemester()}',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    icon: Icon(AppIcons.dropdownIcon),
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
                    items: LocalDataProvider.semesters
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
                      return LocalDataProvider.semesters.map((String item) {
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
              width: ScreenSize.width(context) / 1.5,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: ColorsManager.lightPrimary,
                      foregroundColor: ColorsManager.white,
                      padding: EdgeInsets.symmetric(vertical: 10)),
                  onPressed: _onPressedSelectButton,
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
                AppStrings.alreadyHaveAccount,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              TextButton(
                onPressed: () {
                  context.goNamed(ScreensName.registrationLayout);
                },
                child: Text(
                  AppStrings.login,
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

  String _getLevelFromSemester() {
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

  Future<void> _onPressedSelectButton() async {
    if (selectedSemester != null) {
      AppConstants.SelectedSemester = selectedSemester;
      await Cache.writeData(key: KeysManager.semester, value: selectedSemester);
      AppConstants.navigatedSemester = AppConstants.SelectedSemester;
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoadingScreen()),
          (route) => false);
    } else {
      showToastMessage(
        message: 'Please select a semester',
        states: ToastStates.INFO,
      );
    }
  }
}
