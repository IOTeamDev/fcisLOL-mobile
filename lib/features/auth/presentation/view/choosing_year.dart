import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/core/utils/resources/colors_manager.dart';
import 'package:lol/core/utils/resources/values_manager.dart';
import 'package:lol/features/auth/presentation/view/registration_layout.dart';
import 'package:lol/features/auth/presentation/view/widgets/year.dart';
import 'package:lol/features/auth/presentation/view_model/auth_cubit/auth_cubit.dart';
import 'package:lol/features/home/data/models/semster_model.dart';
import 'package:lol/main.dart';
import 'package:lol/features/auth/presentation/view_model/login_cubit/login_cubit.dart';
import 'package:lol/features/auth/presentation/view_model/login_cubit/login_cubit_states.dart';
import 'package:lol/features/auth/presentation/view/login.dart';
import 'package:lol/features/auth/presentation/view/register.dart';
import 'package:lol/core/utils/components.dart';
import 'package:lol/features/home/presentation/view/home.dart';
import 'package:lol/core/utils/navigation.dart';
import 'package:lol/core/network/local/shared_preference.dart';
import 'package:lol/core/network/remote/fcm_helper.dart';

import '../../../../core/utils/resources/constants_manager.dart';
import '../../../../core/utils/resources/icons_manager.dart';
import '../../../../core/utils/resources/strings_manager.dart';

class ChoosingYear extends StatefulWidget {
  final UserInfo? userInfo;
  final AuthCubit authCubit;

  ChoosingYear({
    super.key,
    this.userInfo,
    required this.authCubit,
  });

  @override
  State<ChoosingYear> createState() => _ChoosingYearState();
}

class _ChoosingYearState extends State<ChoosingYear> {
  String? selectedSemester;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider.value(
        value: widget.authCubit,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              StringsManager.yearSelect,
              style: Theme.of(context).textTheme.displayLarge!.copyWith(fontSize: 40),
            ),
            SizedBox(height: 40,),
            Container(
              height: 50,
              width: AppQueries.screenWidth(context)/1.3,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: ColorsManager.white,
                borderRadius: BorderRadius.circular(AppSizesDouble.s40)
              ),
              padding: EdgeInsets.only(right: 15,),
              child: Row(
                children: [
                  Container(
                    width: AppQueries.screenWidth(context)/2.7,
                    height: double.infinity,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(right: 7),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow()
                      ],
                      color: ColorsManager.darkPrimary,
                      borderRadius: BorderRadius.circular(AppSizesDouble.s40)
                    ),
                    child: FittedBox(
                      child: Text(
                        'Level: ${(semsesterIndex(selectedSemester??'')/2 + 1).floor() == 0? '':(semsesterIndex(selectedSemester??'')/2 + 1).floor()}',
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
                      hint: Text('Select Semester', style: TextStyle(color: ColorsManager.grey)),
                      dropdownColor: ColorsManager.white, // Background color for the dropdown list
                      iconEnabledColor: ColorsManager.black, // Color of the dropdown icon
                      style: const TextStyle(color: ColorsManager.white), // Style for the selected item outside
                      items: AppConstants.semesters.map(
                              (String item) => DropdownMenuItem(value: item, child: Text(item,  style: const TextStyle(color: ColorsManager.black),),)
                      ).toList(),
                      selectedItemBuilder: (BuildContext context) {
                        return AppConstants.semesters.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: FittedBox(
                              child: Text(
                                'Semester: $item',
                                style: const TextStyle(
                                  color:
                                  ColorsManager.black,
                                  fontSize: 16
                                ),
                              ),
                            ),
                          );
                        }).toList();
                      },
                      onChanged: (value){
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
                width: AppQueries.screenWidth(context)/1.3,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsManager.lightPrimary,
                        foregroundColor: ColorsManager.white,
                        padding: EdgeInsets.symmetric(vertical: 7)
                    ),
                    onPressed: (){},
                    child: FittedBox(child: Text('Select', style: TextStyle(fontSize: 20),))
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  StringsManager.alreadyHaveAccount,
                  style: TextStyle(fontSize: 14,),
                ),
                //SizedBox(width: 2,),
                TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegistrationLayout(),
                      ),
                      (route) => false
                    );
                  },
                  child: Text(
                    StringsManager.login,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: ColorsManager.dodgerBlue
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
