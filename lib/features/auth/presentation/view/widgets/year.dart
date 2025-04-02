import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/core/network/local/shared_preference.dart';
import 'package:lol/core/network/remote/fcm_helper.dart';
import 'package:lol/core/utils/components.dart';
import 'package:lol/core/utils/navigation.dart';
import 'package:lol/core/utils/resources/colors_manager.dart';
import 'package:lol/core/utils/resources/constants_manager.dart';
import 'package:lol/core/utils/resources/strings_manager.dart';
import 'package:lol/features/auth/data/models/registration_user_model.dart';
import 'package:lol/features/auth/presentation/view/choosing_year.dart';
import 'package:lol/features/auth/presentation/view/register.dart';
import 'package:lol/features/auth/presentation/view_model/auth_cubit/auth_cubit.dart';
import 'package:lol/features/home/presentation/view/home.dart';

import '../../../../../core/utils/resources/values_manager.dart';

class Year extends StatefulWidget {
  final String title;
  final RegistrationUserModel? userInfo;

  const Year({super.key, required this.title, this.userInfo});

  @override
  YearState createState() => YearState();
}

class YearState extends State<Year> {
  bool isExpanded = false;
  late String switchSemester;

  @override
  Widget build(context) {
    var loginCubit = AuthCubit.get(context);

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {},
      child: Column(
        children: [
          InkWell(
            onTap: () {
              if (widget.title == "Level 4") {
                showToastMessage(
                    message: "Currently Updating", states: ToastStates.INFO);
              } else {
                setState(() {
                  isExpanded = !isExpanded;
                });
              }
            },
            child: AnimatedContainer(
              margin: EdgeInsets.all(20),
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: ColorsManager.lightPrimary,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 4),
                    blurRadius: 8.0,
                  ),
                ],
              ),
              width: AppQueries.screenWidth(context) /
                  3, // Fixed width for each card
              height: AppQueries.screenHeight(context) /
                  6, // Fixed height for each card
              child: Center(
                child: Text(
                  widget.title,
                  style: TextStyle(
                      fontSize: 24,
                      color: ColorsManager.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          if (isExpanded)
            Container(
              width: 150,
              margin: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                color: ColorsManager.lightGrey1,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Semester 1'),
                    textColor: ColorsManager.black,
                    onTap: () =>
                        _awesomeDialogForSemester1(widget.userInfo, loginCubit),
                  ),
                  ListTile(
                    title: const Text('Semester 2'),
                    textColor: ColorsManager.black,
                    onTap: () =>
                        _awesomeDialogForSemester2(widget.userInfo, loginCubit),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  _awesomeDialogForSemester1(
          RegistrationUserModel? userInfo, AuthCubit loginCubit) =>
      AwesomeDialog(
        context: context,
        dialogType: DialogType.info,
        animType: AnimType.scale,
        dialogBackgroundColor: ColorsManager.white,
        dismissOnTouchOutside: true,
        barrierColor:
            ColorsManager.black.withValues(alpha: AppSizesDouble.s0_7),
        title: 'You About To Assign In ${widget.title} Semester 1',
        titleTextStyle: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(color: ColorsManager.black),
        btnOkText: StringsManager.submit,
        btnCancelColor: ColorsManager.imperialRed,
        btnCancelOnPress: () {},
        btnOkOnPress: () async {
          switch (widget.title) {
            case "Level 1":
              switchSemester = "One";
              break;
            case "Level 2":
              switchSemester = "Three";
              break;
            case "Level 3":
              switchSemester = "Five";
              break;
            case "Level 4":
              switchSemester = "Seven";
              break;
          }
          if (userInfo != null) {
            FCMHelper fCMHelper = FCMHelper();
            fCMHelper.initNotifications();
            String? fcmToken = await FirebaseMessaging.instance.getToken();
            loginCubit.register(
              fcmToken: fcmToken,
              name: userInfo.name,
              email: userInfo.email,
              phone: userInfo.phone,
              photo: userInfo.photo!,
              password: userInfo.password,
              semester: switchSemester,
            );
            AppConstants.SelectedSemester = switchSemester;
            Cache.writeData(
                key: "semester", value: AppConstants.SelectedSemester);
          } else {
            AppConstants.SelectedSemester = switchSemester;
            Cache.writeData(
                key: "semester", value: AppConstants.SelectedSemester);
            navigatReplace(context, const Home());
          }
        },
      ).show();

  _awesomeDialogForSemester2(userInfo, AuthCubit loginCubit) => AwesomeDialog(
        context: context,
        dismissOnTouchOutside: true,
        barrierColor:
            ColorsManager.black.withValues(alpha: AppSizesDouble.s0_7),
        dialogType: DialogType.info,
        btnOkText: StringsManager.submit,
        animType: AnimType.scale,
        title: 'You About To Assign In ${widget.title} Semester 2',
        dialogBackgroundColor: ColorsManager.white,
        titleTextStyle: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(color: ColorsManager.black),
        btnCancelColor: ColorsManager.imperialRed,
        btnCancelOnPress: () {},
        btnOkOnPress: () async {
          switch (widget.title) {
            case "Level 1":
              switchSemester = "Two";
              break;
            case "Level 2":
              switchSemester = "Four";
              break;
            case "Level 3":
              switchSemester = "Six";
              break;
            case "Level 4":
              switchSemester = "Eight";
              break;
          }

          if (userInfo != null) {
            FCMHelper fCMHelper = FCMHelper();
            fCMHelper.initNotifications();
            print('semester => $switchSemester');

            String? fcmToken = await FirebaseMessaging.instance.getToken();
            loginCubit.register(
              name: userInfo.name,
              email: userInfo.email,
              phone: userInfo.phone,
              fcmToken: fcmToken,
              photo: userInfo.photo!,
              password: userInfo.password,
              semester: switchSemester,
            );

            AppConstants.SelectedSemester = switchSemester;
            Cache.writeData(
                key: "semester", value: AppConstants.SelectedSemester);
          } else {
            AppConstants.SelectedSemester = switchSemester;
            Cache.writeData(
                key: "semester", value: AppConstants.SelectedSemester);
            navigatReplace(context, const Home());
          }
        },
      ).show();
}
