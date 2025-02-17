import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/core/utils/resources/colors_manager.dart';
import 'package:lol/features/auth/presentation/view/registration_layout.dart';
import 'package:lol/features/auth/presentation/view/widgets/year.dart';
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
          appBar: AppBar(
            backgroundColor: ColorsManager.white,
            title: Text(
              'Year Select',
              style: Theme.of(context)
                  .textTheme
                  .displayMedium!
                  .copyWith(color: ColorsManager.black),
            ),
            centerTitle: true,
          ),
          backgroundColor: ColorsManager.white,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'already have account!!',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                        //SizedBox(width: 2,),
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
                            "Login",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: ColorsManager.lightPrimary),
                          ),
                        ),
                      ],
                    ),
                  ],
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
