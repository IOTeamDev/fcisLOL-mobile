import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/shared/components/components.dart';
import 'package:lol/shared/components/default_button.dart';
import 'package:lol/shared/components/default_text_button.dart';
import 'package:lol/shared/components/default_text_field.dart';
import 'package:lol/shared/components/snack.dart';
import 'package:lol/shared/styles/colors.dart';
import 'package:lol/modules/auth/bloc/login_cubit.dart';
import 'package:lol/modules/auth/bloc/login_cubit_states.dart';
import 'package:lol/modules/auth/screens/register.dart';
import 'package:lol/shared/components/constants.dart';
import 'package:lol/layout/home/home.dart';
import 'package:lol/layout/profile/profile.dart';
import 'package:lol/shared/components/navigation.dart';
import 'package:lol/shared/network/local/shared_prefrence.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var formKey = GlobalKey<FormState>();
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            TOKEN = state.token;
            Cache.writeData(key: "token", value: state.token);
            print("${state.token}Token");
            showToastMessage(
              message: "Successfully signed in. Welcome back!",
              states: ToastStates.SUCCESS,
            );

            navigatReplace(context, const Home());
          }
          if (state is LoginFailed) {
            showToastMessage(
                states: ToastStates.ERROR,
                // enumColor: Messages.error,
                message: "Invalid email or password. Please try again");
          }
        },
        builder: (context, state) {
          var loginCubit = LoginCubit.get(context);

          return Scaffold(
            appBar: AppBar(),
            body: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.android,
                            color: additional2,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          const Text(
                            "temp",
                            style: TextStyle(
                                fontSize: 20,
                                letterSpacing: 2,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      const Text(
                        "Login ",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text("Continue Your Success Journey with temp !"),
                      const SizedBox(
                        height: 30,
                      ),
                      Column(
                        children: [
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Email address",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          defaultTextField(
                              validateor: (value) {
                                if (value!.isEmpty) {
                                  return "Field cannot be empty";
                                } else {
                                  return null; // Form is valid.
                                }
                              },
                              controller: emailController,
                              type: TextInputType.emailAddress),
                        ],
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "Password",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              const Spacer(),
                              TextButton(
                                style: TextButton.styleFrom(
                                    padding: const EdgeInsets.all(0)),
                                child: const Text(
                                  "Forgot Password ?",
                                  textAlign: TextAlign.end,
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                          // const SizedBox(height: 5,),
                          defaultTextField(
                              onFieldSubmitted: (valu) {
                                if (formKey.currentState!.validate()) {
// update fcm token

                                  loginCubit.login(
                                      email: emailController.text.toLowerCase(),
                                      password: passwordController.text);
                                }
                              },
                              suffFunc: () {
                                loginCubit.togglePassword();
                              },
                              dtaSufIcon: Icon(
                                Icons.remove_red_eye,
                                color: loginCubit.hiddenPassword
                                    ? null
                                    : Colors.blue,
                              ),
                              wantMargin: false,
                              validateor: (value) {
                                return null;
                              },
                              controller: passwordController,
                              obscure: loginCubit.hiddenPassword),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      state is LoginLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : defaultButton(
                              buttonFunc: () {
                                if (formKey.currentState!.validate()) {
// update fcm token

                                  loginCubit.login(
                                      email: emailController.text.toLowerCase(),
                                      password: passwordController.text);
                                }
                              },
                              buttonWidth: 400,
                              title: "Log in"),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Not a member yet ?"),
                          defaultTextButton(
                            onPressed: () {
                              navigatReplace(context, Registerscreen());
                            },
                            text: "Register",
                          )
                        ],
                      )
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
