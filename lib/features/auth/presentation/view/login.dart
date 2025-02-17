import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit.dart';
import 'package:lol/core/utils/components.dart';
import 'package:lol/core/utils/resources/icons_manager.dart';
import 'package:lol/core/utils/resources/strings_manager.dart';
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
                      const Text(
                        "Login ",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w600,
                          color: ColorsManager.black,
                        ),
                      ),
                      SizedBox(height: 20,),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(color: ColorsManager.black),
                        decoration: InputDecoration(
                          //hintStyle: TextStyle(color: ColorsManager.lightGrey),
                          //hintText: 'Email',
                          labelStyle: TextStyle(color: ColorsManager.lightGrey),
                          labelText: 'Email',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                          filled: true,
                          fillColor: ColorsManager.grey3,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: ColorsManager.lightPrimary),
                            borderRadius: BorderRadius.circular(15)
                          )
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Field cannot be empty";
                          } else {
                            return null; // Form is valid.
                          }
                        },
                      ),
                      SizedBox(height: 20,),
                      TextFormField(
                        obscureText: loginCubit.hiddenPassword,
                        controller:  passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        style: TextStyle(color: ColorsManager.black),
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: ColorsManager.lightGrey),
                          labelText: 'Password',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                          filled: true,
                          fillColor: ColorsManager.grey3,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: ColorsManager.lightPrimary),
                              borderRadius: BorderRadius.circular(15)
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(IconsManager.eyeIcon),
                            color: loginCubit.hiddenPassword ? ColorsManager.lightGrey : Colors.blue,
                            onPressed: loginCubit.togglePassword,
                          ),

                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Field cannot be empty";
                          } else {
                            return null; // Form is valid.
                          }
                        },
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(0),
                            foregroundColor: ColorsManager.dodgerBlue
                          ),
                          child: const Text(
                            "Forgot Password ?",
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  AlertDialog(
                                    title: const Text('Forgot Password'),
                                    content: Form(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextFormField(
                                            controller: emailController,
                                            keyboardType:
                                            TextInputType.emailAddress,
                                            decoration: const InputDecoration(
                                              labelText: 'Enter your email',
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
                                        child: const Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          String email =
                                          emailController.text.trim();
                                          forgetPassword(email: email);
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Submit'),
                                      )
                                    ],
                                  ),
                            );
                          },
                        ),
                      ),
                      state is LoginLoading ? const Center(
                        child: CircularProgressIndicator(),
                      ) : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: ColorsManager.white,
                          fixedSize: Size(AppQueries.screenWidth(context), 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)
                          ),
                          backgroundColor: ColorsManager.lightPrimary
                        ),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            loginCubit.login(
                              email: emailController.text.toLowerCase(),
                              password: passwordController.text
                            );
                          }
                        }, 
                        child: Text('Login', style: TextStyle(fontSize: 24),),
                      ),
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
