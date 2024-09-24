import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/modules/auth/bloc/login_cubit.dart';
import 'package:lol/modules/auth/bloc/login_cubit_states.dart';
import 'package:lol/modules/auth/screens/login.dart';
import 'package:lol/modules/auth/screens/register.dart';
import 'package:lol/shared/components/snack.dart';
import 'package:lol/shared/components/constants.dart';
import 'package:lol/layout/home/home.dart';
import 'package:lol/shared/components/navigation.dart';
import 'package:lol/shared/network/local/shared_prefrence.dart';

late String semester;

class ChoosingYear extends StatelessWidget {
  UserInfo? userInfo;
  final LoginCubit loginCubit;
  ChoosingYear({super.key, this.userInfo, required this.loginCubit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: loginCubit,
      // create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
          builder: (context, state) => Scaffold(
                backgroundColor: Colors.blueGrey,
                appBar: AppBar(
                  title: const Text("temp"),
                  centerTitle: true,
                  backgroundColor: Colors.blueGrey,
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
              // token=state.token;
              TOKEN = state.token;
              Cache.writeData(key: "token", value: state.token);
              print(state.token);
              snack(
                  context: context,
                  enumColor: Messages.success,
                  titleWidget: const Text("Successfully signed up !"));

              navigatReplace(context, const Home());
            }
            if (state is RegisterFailed) {
              snack(
                  context: context,
                  enumColor: Messages.error,
                  titleWidget:
                      const Text("Please try with another email address"));
              navigatReplace(context, LoginScreen());
            }
          }),
    );
  }
}

class Year extends StatefulWidget {
  final String title;
  final UserInfo? userInfo;

  Year({super.key, required this.title, this.userInfo});

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
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Container(
            width: 150,
            height: 100,
            margin: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.grey,
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
                          'You About To Assign In ${widget.title} Semster 1 ',
                      btnOkText: "Confirm",
                      btnCancelOnPress: () {},
                      btnOkOnPress: () {
                        late int value;
                        switch (widget.title) {
                          case "Level 1":
                            semester = "One";
                            break;
                          case "Level 2":
                            semester = "Three";
                            break;
                          case "Level 3":
                            semester = "Five";
                            break;
                          case "Level 4":
                            semester = "Seven";
                            break;
                        }
                        if (userInfo != null) print(userInfo.email);
                        if (userInfo != null)
                          loginCubit.register(
                              name: userInfo.name,
                              email: userInfo.email,
                              phone: userInfo.phone,
                              photo: userInfo.photo!,
                              password: userInfo.password,
                              semester: semester);
                        else {
                          Cache.writeData(key: "semester", value: semester);
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
                          'You About To Assign In ${widget.title} Semester 2 ',
                      btnCancelOnPress: () {},
                      btnOkOnPress: () {
                        switch (widget.title) {
                          case "Level 1":
                            semester = "Two";
                            break;
                          case "Level 2":
                            semester = "Four";
                            break;
                          case "Level 3":
                            semester = "Six";
                            break;
                          case "Level 4":
                            semester = "Eight";
                            break;
                        }

                        if (userInfo != null) print(userInfo.email);
                        if (userInfo != null)
                          loginCubit.register(
                              name: userInfo.name,
                              email: userInfo.email,
                              phone: userInfo.phone,
                              photo: userInfo.photo!,
                              password: userInfo.password,
                              semester: semester);
                        else {
                          Cache.writeData(key: "semester", value: semester);
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