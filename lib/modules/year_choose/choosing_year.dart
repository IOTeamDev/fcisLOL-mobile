import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/main.dart';
import 'package:lol/modules/auth/bloc/login_cubit.dart';
import 'package:lol/modules/auth/bloc/login_cubit_states.dart';
import 'package:lol/modules/auth/screens/login.dart';
import 'package:lol/modules/auth/screens/register.dart';
import 'package:lol/shared/components/components.dart';
import 'package:lol/shared/components/constants.dart';
import 'package:lol/layout/home/home.dart';
import 'package:lol/shared/components/navigation.dart';
import 'package:lol/shared/network/local/shared_prefrence.dart';

import '../../shared/network/remote/fcm_helper.dart';
//import 'package:lol/shared/network/remote/cloud_messeging.dart';

late String switchSemester;

class ChoosingYear extends StatelessWidget {
  UserInfo? userInfo;
  final LoginCubit loginCubit;
  ChoosingYear({super.key, this.userInfo, required this.loginCubit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: loginCubit,
      child: BlocConsumer<LoginCubit, LoginStates>(
        builder: (context, state) => Scaffold(
          backgroundColor: const Color(0xff1B262C),
          appBar: AppBar(
            title: const Text("temp"),
            centerTitle: true,
            backgroundColor: const Color(0xff0F4C75),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Year(
                    title: "Level 1",
                    userInfo: userInfo,
                  ),
                  Year(
                    title: "Level 2",
                    userInfo: userInfo,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Year(
                    title: "Level 3",
                    userInfo: userInfo,
                  ),
                  Year(
                    title: "Level 4",
                    userInfo: userInfo,
                  ),
                ],
              ),
            ],
          ),
        ),
        listener: (context, state) {
          if (state is RegisterSuccess) {
            TOKEN = state.token;
            Cache.writeData(key: "token", value: state.token);
            showToastMessage(
              message: "Successfully signed up!",
              states: ToastStates.SUCCESS,
            );

            navigatReplace(context, const Home());
          }
          if (state is RegisterFailed) {
            showToastMessage(
              message: "Please try with another email address",
              states: ToastStates.ERROR,
            );
            navigatReplace(context, const LoginScreen());
          }
        },
      ),
    );
  }
}

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
        GestureDetector(
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
          child: Container(
            width: 100,
            height: 100,
            margin: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 197, 71, 25),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Center(
              child: Text(
                widget.title,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ),
        if (isExpanded)
          Container(
            width: 150,
            margin: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              children: [
                ListTile(
                  title: const Text('Semester 1'),
                  onTap: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.info,
                      animType: AnimType.rightSlide,
                      title:
                          'You About To Assign In ${widget.title} Semester 1',
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
                          String? fcmToken =
                              await FirebaseMessaging.instance.getToken();
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
                          SelectedSemester = switchSemester;
                          Cache.writeData(
                              key: "semester", value: SelectedSemester);

                          navigatReplace(context, const Home());
                        }
                      },
                    ).show();
                  },
                ),
                ListTile(
                  title: const Text('Semester 2'),
                  onTap: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.info,
                      animType: AnimType.rightSlide,
                      title:
                          'You About To Assign In ${widget.title} Semester 2',
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
                          String? fcmToken =
                              await FirebaseMessaging.instance.getToken();

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
                          SelectedSemester = switchSemester;
                          Cache.writeData(
                              key: "semester", value: SelectedSemester);

                          navigatReplace(context, const Home());
                        }
                      },
                    ).show();
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }
}
