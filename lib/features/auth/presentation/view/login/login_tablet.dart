import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit.dart';
import 'package:lol/core/utils/components.dart';
import 'package:lol/core/utils/dependencies_helper.dart';
import 'package:lol/core/utils/resources/icons_manager.dart';
import 'package:lol/core/utils/resources/strings_manager.dart';
import 'package:lol/core/utils/resources/values_manager.dart';
import 'package:lol/features/admin/presentation/view_model/admin_cubit/admin_cubit.dart';
import 'package:lol/features/auth/presentation/view/choosing_year.dart';
import 'package:lol/features/auth/presentation/view_model/auth_cubit/auth_cubit.dart';
import 'package:lol/features/auth/presentation/view/register.dart';
import 'package:lol/core/utils/resources/constants_manager.dart';
import 'package:lol/features/home/presentation/view/home.dart';
import 'package:lol/features/profile/view/profile.dart';
import 'package:lol/core/utils/navigation.dart';
import 'package:lol/core/network/local/shared_preference.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/utils/resources/colors_manager.dart';
import '../../../../../core/utils/resources/theme_provider.dart';
import '../../../../otp_and_verification/presentation/view/forgot_password_verification.dart';
import '../../../../otp_and_verification/presentation/view_model/verification_cubit/verification_cubit.dart';

class LoginScreenTablet extends StatefulWidget {
  const LoginScreenTablet({super.key});

  @override
  State<LoginScreenTablet> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreenTablet> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var loginCubit = AuthCubit.get(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizesDouble.s30),
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  StringsManager.login,
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        fontSize: AppSizesDouble.s40,
                      ),
                ),
                SizedBox(
                  height: AppSizesDouble.s20,
                ),
                defaultLoginInputField(
                  _emailController,
                  StringsManager.email,
                  TextInputType.emailAddress,
                  loginCubit: loginCubit,
                ),
                SizedBox(
                  height: AppSizesDouble.s20,
                ),
                defaultLoginInputField(_passwordController,
                    StringsManager.password, TextInputType.visiblePassword,
                    isPassword: true,
                    loginCubit: loginCubit,
                    suffixIcon: IconsManager.eyeIcon),
                // Align(
                //   alignment: Alignment.centerLeft,
                //   child: TextButton(
                //     style: TextButton.styleFrom(
                //         padding: const EdgeInsets.all(AppSizesDouble.s0),
                //         foregroundColor: ColorsManager.dodgerBlue),
                //     child: const Text(
                //       StringsManager.forgotPassword + StringsManager.qMark,
                //     ),
                //     onPressed: () {
                //       if(_emailController.text.isNotEmpty){
                //         Navigator.of(context).push(
                //             MaterialPageRoute(
                //                 builder: (context) => BlocProvider(
                //                     create: (context) => VerificationCubit()..initializeStream(),
                //                     child: ForgotPasswordVerification(recipientEmail: _emailController.text,)
                //                 )
                //             )
                //         );
                //       } else {
                //         showToastMessage(message: 'Please Provide Email First To Continue', states: ToastStates.INFO);
                //       }
                //     },
                //   ),
                // ),
                SizedBox(height: 10,),
                defaultLoginButton(
                    context,
                    formKey,
                    loginCubit,
                    _emailController,
                    _passwordController,
                    StringsManager.login),
                const SizedBox(
                  height: AppSizesDouble.s20,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => ChoosingYear(),
                          ),
                          (route) => false);
                    },
                    child: Text(
                      'Continue as a guest',
                      style: TextStyle(color: ColorsManager.dodgerBlue),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
