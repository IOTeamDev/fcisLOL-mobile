import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/core/utils/resources/colors_manager.dart';
import 'package:lol/core/utils/resources/values_manager.dart';
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
import '../../../../core/utils/resources/strings_manager.dart';

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
              StringsManager.yearSelect,
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
                        height: MediaQuery.of(context).size.height / AppSizesDouble.s3_5,
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment
                          .center, // Center the rows horizontally
                      children: [
                        Year(
                          title: StringsManager.level1,
                          userInfo: userInfo,
                        ),
                        Year(
                          title: StringsManager.level2,
                          userInfo: userInfo,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center, // Center the rows horizontally
                      children: [
                        Year(
                          title: StringsManager.level3,
                          userInfo: userInfo,
                        ),
                        Year(
                          title: StringsManager.level4,
                          userInfo: userInfo,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          StringsManager.alreadyHaveAccount,
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
                            StringsManager.login,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: ColorsManager.lightPrimary
                            ),
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
            Cache.writeData(key: KeysManager.token, value: state.token);
            showToastMessage(
              message: StringsManager.successfullySignedIn,
              states: ToastStates.SUCCESS,
            );

            navigatReplace(context, const Home());
          }
          if (state is RegisterFailed) {
            showToastMessage(
              message: StringsManager.signInErrorMessage,
              states: ToastStates.ERROR,
            );
            navigatReplace(context, const LoginScreen());
          }
        },
      ),
    );
  }
}
