import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lol/config/navigation/routes.dart';
import 'package:lol/core/presentation/cubits/main_cubit/main_cubit.dart';
import 'package:lol/features/auth/presentation/view/widgets/auth_elevated_button.dart';
import 'package:lol/features/auth/presentation/view/widgets/auth_text_form_field.dart';
import 'package:lol/core/utils/components.dart';
import 'package:lol/core/utils/service_locator.dart';
import 'package:lol/core/presentation/app_icons.dart';
import 'package:lol/core/resources/theme/values/app_strings.dart';
import 'package:lol/core/resources/theme/values/values_manager.dart';
import 'package:lol/features/admin/presentation/view_model/admin_cubit/admin_cubit.dart';
import 'package:lol/features/auth/presentation/view/choosing_year/choosing_year.dart';
import 'package:lol/features/auth/presentation/cubits/auth_cubit/auth_cubit.dart';
import 'package:lol/features/auth/presentation/view/register/register.dart';
import 'package:lol/core/resources/constants/constants_manager.dart';
import 'package:lol/features/home/presentation/view/home.dart';
import 'package:lol/features/otp_and_verification/presentation/view/forgot_password_verification.dart';
import 'package:lol/features/otp_and_verification/presentation/view_model/verification_cubit/verification_cubit.dart';
import 'package:lol/features/profile/view/profile.dart';
import 'package:lol/core/utils/navigation.dart';
import 'package:lol/core/network/local/shared_preference.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/resources/theme/colors_manager.dart';
import '../../../../../core/resources/theme/theme_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                  AppStrings.login,
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        fontSize: AppSizesDouble.s40,
                      ),
                ),
                SizedBox(
                  height: AppSizesDouble.s20,
                ),
                AuthTextFormField(
                  controller: _emailController,
                  label: AppStrings.email,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(
                  height: AppSizesDouble.s10,
                ),
                AuthTextFormField(
                  controller: _passwordController,
                  label: AppStrings.password,
                  isPassword: true,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(AppSizesDouble.s0),
                        foregroundColor: ColorsManager.dodgerBlue),
                    child: const Text(
                      AppStrings.forgotPassword + AppStrings.qMark,
                    ),
                    onPressed: () {
                      if (_emailController.text.isNotEmpty) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => BlocProvider(
                                create: (context) =>
                                    VerificationCubit()..initializeStream(),
                                child: ForgotPasswordVerification(
                                  recipientEmail: _emailController.text,
                                ))));
                      } else {
                        showToastMessage(
                            message: 'Please Provide Email First To Continue',
                            states: ToastStates.INFO);
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                AuthElevatedButton(
                  text: AppStrings.login,
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      await context.read<AuthCubit>().login(
                          email: _emailController.text,
                          password: _passwordController.text);
                    }
                  },
                ),
                const SizedBox(
                  height: AppSizesDouble.s20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Do you want to try first?'),
                    TextButton(
                        onPressed: () {
                          context.goNamed(ScreensName.choosingYear);
                        },
                        child: Text(
                          'Continue as a guest',
                          style: TextStyle(color: ColorsManager.dodgerBlue),
                        ))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
