import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/core/utils/components.dart';
import 'package:lol/core/widgets/default_button.dart';
import 'package:lol/core/widgets/default_text_button.dart';
import 'package:lol/core/widgets/default_text_field.dart';
import 'package:lol/core/widgets/snack.dart';
import 'package:lol/features/auth/presentation/view_model/login_cubit/login_cubit.dart';
import 'package:lol/features/auth/presentation/view_model/login_cubit/login_cubit_states.dart';
import 'package:lol/features/auth/presentation/view/register.dart';
import 'package:lol/core/utils/resources/constants_manager.dart';
import 'package:lol/features/home/presentation/view/home.dart';
import 'package:lol/features/profile/view/profile.dart';
import 'package:lol/core/utils/navigation.dart';
import 'package:lol/core/network/local/shared_prefrence.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatelessWidget {
  final maybeHeStillWantToBeAGuest;
  const LoginScreen({super.key, this.maybeHeStillWantToBeAGuest = false});

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
            AppConstants.TOKEN = state.token;
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
                      Center(
                        child: Row(
                          // mainAxisSize: MainAxisSize.min,a
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              "images/l.png",
                              width: 35,
                              height: 35,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Text(
                              "UniNotes",
                              style: TextStyle(
                                  fontSize: 20,
                                  letterSpacing: 2,
                                  color: Colors.black),
                            ),

                            // SizedBox(width:70)
                          ],
                        ),
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
                      const Text(
                          "Continue Your Success Journey with UNINOTES !"),
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
                              // textInputAction: TextInputAction.next,
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
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
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
                            ],
                          ),
                          // const SizedBox(height: 5,),
                          defaultTextField(
                              onFieldSubmitted: (val) async {
                                if (formKey.currentState!.validate()) {
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
                              color: Color(0xff4763C4),
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
