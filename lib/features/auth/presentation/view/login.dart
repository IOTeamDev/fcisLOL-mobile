import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit.dart';
import 'package:lol/core/utils/components.dart';
import 'package:lol/core/utils/resources/icons_manager.dart';
import 'package:lol/core/utils/resources/strings_manager.dart';
import 'package:lol/core/utils/resources/values_manager.dart';
import 'package:lol/core/widgets/default_button.dart';
import 'package:lol/core/widgets/default_text_button.dart';
import 'package:lol/core/widgets/default_text_field.dart';
import 'package:lol/core/widgets/snack.dart';
import 'package:lol/features/admin/presentation/view_model/admin_cubit/admin_cubit.dart';
import 'package:lol/features/auth/presentation/view_model/auth_cubit/auth_cubit.dart';
import 'package:lol/features/auth/presentation/view/register.dart';
import 'package:lol/core/utils/resources/constants_manager.dart';
import 'package:lol/features/home/presentation/view/home.dart';
import 'package:lol/features/profile/view/profile.dart';
import 'package:lol/core/utils/navigation.dart';
import 'package:lol/core/network/local/shared_preference.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/utils/resources/colors_manager.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            showToastMessage(
              message: "Successfully signed in. Welcome back!",
              states: ToastStates.SUCCESS,
            );

            navigatReplace(context, Home());
          }
          if (state is LoginFailed) {
            showToastMessage(
              states: ToastStates.ERROR,
              message: "Invalid email or password. Please try again"
            );
          }
        },
        builder: (context, state) {
          var loginCubit = AuthCubit.get(context);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Form(
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
                          color: ColorsManager.black
                        )
                      ),
                      SizedBox(height: AppSizesDouble.s20,),
                      defaultLoginInputField(emailController, StringsManager.email, TextInputType.emailAddress, false, loginCubit,),
                      SizedBox(height: AppSizesDouble.s20,),
                      defaultLoginInputField(passwordController, StringsManager.password, TextInputType.visiblePassword, true, loginCubit, IconsManager.eyeIcon),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(AppSizesDouble.s0),
                            foregroundColor: ColorsManager.dodgerBlue
                          ),
                          child: const Text(
                            StringsManager.forgotPassword + StringsManager.qMark,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) =>
                                AlertDialog(
                                  title: const Text(StringsManager.forgotPassword),
                                  content: Form(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextFormField(
                                          controller: emailController,
                                          keyboardType:
                                          TextInputType.emailAddress,
                                          decoration: const InputDecoration(
                                            labelText: StringsManager.email,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(StringsManager.cancel),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        String email =
                                        emailController.text.trim();
                                        forgetPassword(email: email);
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(StringsManager.submit),
                                    )
                                  ],
                                ),
                            );
                          },
                        ),
                      ),
                      state is LoginLoading ? const Center(
                        child: CircularProgressIndicator(),
                      ) : defaultLoginButton(context, formKey, loginCubit, emailController, passwordController, StringsManager.login)
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

Future<void> forgetPassword({required String email}) async {
  final String subject = Uri.encodeComponent('Forgot Password');
  final String body = Uri.encodeComponent(email);

  final Uri emailUri = Uri(
    scheme: 'mailto',
    path: 'mahmoud2004saad@gmail.com',
    query: 'subject=$subject&body=$body',
  );
  await launchUrl(emailUri);
}
