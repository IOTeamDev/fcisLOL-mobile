import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lol/core/network/local/shared_preference.dart';
import 'package:lol/core/network/remote/fcm_helper.dart';
import 'package:lol/core/utils/components.dart';
import 'package:lol/core/utils/navigation.dart';
import 'package:lol/core/utils/resources/colors_manager.dart';
import 'package:lol/core/utils/resources/constants_manager.dart';
import 'package:lol/features/auth/presentation/view/choosing_year.dart';
import 'package:lol/features/auth/presentation/view/register.dart';
import 'package:lol/features/auth/presentation/view_model/login_cubit/login_cubit.dart';
import 'package:lol/features/home/presentation/view/home.dart';

class Year extends StatefulWidget {
  final String title;
  final UserInfo? userInfo;

  const Year({super.key, required this.title, this.userInfo});

  @override
  YearState createState() => YearState();
}

class YearState extends State<Year> {
  bool isExpanded = false;

  @override
  Widget build(context) {
    var loginCubit = LoginCubit.get(context);
    UserInfo? userInfo = widget.userInfo;

    return Column(
      children: [
        InkWell(
          onTap: () {
            if (widget.title == "Level 4") {
              showToastMessage(message: "Currently Updating", states: ToastStates.INFO);
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
                  fontWeight: FontWeight.bold
                ),
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
                  onTap: () => _awesomeDialogForSemester1(userInfo, loginCubit),
                ),
                ListTile(
                  title: const Text('Semester 2'),
                  textColor: ColorsManager.black,
                  onTap: () => _awesomeDialogForSemester2(userInfo, loginCubit),
                ),
              ],
            ),
          ),
      ],
    );
  }

  _awesomeDialogForSemester1(userInfo, loginCubit) => AwesomeDialog(
    context: context,
    dialogType: DialogType.info,
    animType: AnimType.rightSlide,
    title: 'You About To Assign In ${widget.title} Semester 1',
    btnOkText: "Confirm",
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
      } else {
        AppConstants.SelectedSemester = switchSemester;
        Cache.writeData(
            key: "semester",
            value: AppConstants.SelectedSemester
        );
        navigatReplace(context, const Home());
      }
    },
  ).show();

  _awesomeDialogForSemester2(userInfo, loginCubit ) => AwesomeDialog(
    context: context,
    dialogType: DialogType.info,
    animType: AnimType.rightSlide,
    title: 'You About To Assign In ${widget.title} Semester 2',
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
      } else {
        AppConstants.SelectedSemester = switchSemester;
        Cache.writeData(
            key: "semester",
            value: AppConstants.SelectedSemester
        );
        navigatReplace(context, const Home());
      }
    },
  ).show();
}

