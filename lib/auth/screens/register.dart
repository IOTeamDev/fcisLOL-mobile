import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:lol/components/default_button.dart';
import 'package:lol/components/default_text_button.dart';
import 'package:lol/components/default_text_field.dart';
import 'package:lol/components/snack.dart';
import 'package:lol/constants/colors.dart';
import 'package:lol/auth/bloc/login_cubit.dart';
import 'package:lol/auth/bloc/login_cubit_states.dart';
import 'package:lol/auth/screens/login.dart';
import 'package:lol/auth/screens/select_image.dart';
import 'package:lol/constants/constants.dart';
import 'package:lol/main/screens/home.dart';
import 'package:lol/utilities/navigation.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class UserInfo {
  late String name;
  late String email;
  late String password;
  late String phone;

  UserInfo(
      {required this.name,
      required this.email,
      required this.password,
      required this.phone});
}

class Registerscreen extends StatelessWidget {
  const Registerscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    var nameController = TextEditingController();
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var confirimPassword = TextEditingController();
    var phoneController = TextEditingController();

    var formKey = GlobalKey<FormState>();
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            // token=state.token;
            // Cache.writeData(key: "token", value: state.token);
            snack(
                context: context,
                enumColor: Messages.success,
                titleWidget: const Text("Successfully signed up !"));

            navigatReplace(context, const Home());
          }
          if (state is LoginFailed) {
            snack(
                context: context,
                enumColor: Messages.error,
                titleWidget:
                    const Text("Please try with another email address"));
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Builder(builder: (context) {
              return SafeArea(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
                  child: Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const Text(
                            "Create you account",
                            style: TextStyle(
                                // letterSpacing: 3,
                                // color: Additional2,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          const Text(
                              "Welcome! Please fill in the details to get started"),
                          const SizedBox(
                            height: 20,
                          ),
                          Column(
                            children: [
                              const Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Name",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
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
                                  controller: nameController),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Column(
                            children: [
                              const Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Email address",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              defaultTextField(
                                  validateor: (value) {
                                    if (value!.isEmpty) {
                                      return "Field cannot be empty";
                                    }
                                    if (!emailRegExp.hasMatch(value)) {
                                      return "Invalid email format";
                                    } else {
                                      return null; // Form is valid.
                                    }
                                  },
                                  controller: emailController),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Column(
                            children: [
                              const Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Password",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              defaultTextField(
                                  validateor: (Value) {
                                    return null;
                                  },
                                  controller: passwordController,
                                  obscure: true),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Column(
                            children: [
                              const Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Confirm Password",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              defaultTextField(
                                  validateor: (Value) {
                                    if (Value!.isEmpty) {
                                      return "Field cannot be empty";
                                    } else if (Value !=
                                        passwordController.text) {
                                      return "Passwords doesn't matched";
                                    } else {
                                      return null; // Form is valid.
                                    }
                                  },
                                  controller: confirimPassword,
                                  obscure: true),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          state is RegisterLoading
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : defaultButton(
                                  buttonFunc: () {
                                    // if (formKey.currentState!.validate()) {
                                    UserInfo userInfo = UserInfo(
                                        name: nameController.text,
                                        email: emailController.text,
                                        password: passwordController.text,
                                        phone: phoneController.text);
                                    navigate(
                                        context,
                                        SelectImage(
                                          userInfo: userInfo,
                                        ));
                                    // }
                                    // LoginCubit.get(context).register(
                                    //     name: nameController.text,
                                    //     email: emailController.text,
                                    //     phone: phoneController.text,
                                    //     photo:
                                    //         "https://upload.wikimedia.org/wikipedia/en/c/ce/Walter_White_Jr_S5B.png",
                                    //     password: passwordController.text,
                                    //     semester: "Four");
                                  },
                                  buttonWidth: 300,
                                  title: "NEXT"),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Already have account?",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400),
                              ),
                              defaultTextButton(
                                onPressed: () => navigatReplace(
                                    context, const LoginScreen()),
                                text: "Login",
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}

Widget LoginMethodContainer({
  String? image,
  IconData? icon,
  required String title,
}) {
  return InkWell(
    onTap: () {
      // Handle tap action
    },
    child: Container(
      // margin: EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      height: 45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (image != null)
            Image.asset(
              image,
              width: 25,
              height: 25,
            ),
          if (icon != null) Icon(icon),
          const SizedBox(width: 15),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[700],
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
        ],
      ),
    ),
  );
}
