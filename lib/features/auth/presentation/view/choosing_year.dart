import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

late String switchSemester;

class ChoosingYear extends StatelessWidget {
  final UserInfo? userInfo;
  final LoginCubit loginCubit;
  const ChoosingYear({super.key, this.userInfo, required this.loginCubit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: loginCubit,
      child: BlocConsumer<LoginCubit, LoginStates>(
        builder: (context, state) => Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            // mainAxisAlignment: userInfo==null?MainAxisAlignment.start:MainAxisAlignment.center,

            children: [
              // Content at the top of the body
              if (userInfo == null)
                Container(
                  margin: EdgeInsets.only(top: 120),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Registerscreen(),
                              ),
                              (route) => false);
                        },
                        child: Text(
                          "Sign up with Email",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Row(
                        children: [
                          Expanded(child: Divider()),
                          Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              child: Text("OR")),
                          Expanded(child: Divider()),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Continue as a guest",
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                    ],
                  ),
                ),

              // Spacer to push content to the center
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    //     .center, // Center the Year widgets vertically
                    children: [
                      if (userInfo != null)
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 3.5,
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment
                            .center, // Center the rows horizontally
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
                        mainAxisAlignment: MainAxisAlignment
                            .center, // Center the rows horizontally
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
              ),
            ],
          ),
        ),
        listener: (context, state) {
          if (state is RegisterSuccess) {
            AppConstants.TOKEN = state.token;
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
          child: AnimatedContainer(
            margin: EdgeInsets.all(20),
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: Colors.blueAccent,
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
                5.5, // Fixed height for each card
            child: Center(
              child: Text(
                widget.title,
                // 'Level $level',
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
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
                          AppConstants.SelectedSemester = switchSemester;
                          Cache.writeData(
                              key: "semester",
                              value: AppConstants.SelectedSemester);

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
                          AppConstants.SelectedSemester = switchSemester;
                          Cache.writeData(
                              key: "semester",
                              value: AppConstants.SelectedSemester);

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
