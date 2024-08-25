import 'package:flutter/material.dart';
import 'package:lol/constants/componants.dart';
import 'package:lol/login/login_screen.dart';

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

    var formKey = GlobalKey<FormState>();
    return Scaffold(
      body: Builder(builder: (context) {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: loginMethodContainer(
                                title: "Google", image: "images/google1.png")),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(child: Divider()),

                        Text(
                          "   or  ",
                          style: TextStyle(fontSize: 17),
                        ),
                        Expanded(child: Divider()),
                        // Expanded(child: HalfDivider(context)),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: [
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Name",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        defaultForm(
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
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        defaultForm(
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
                      height: 5,
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
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        defaultForm(
                            validateor: (value) {
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
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        defaultForm(
                            validateor: (value) {
                              if (value!.isEmpty) {
                                return "Field cannot be empty";
                              } else if (value != passwordController.text) {
                                return "Passwords doesen't matched";
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
                    defaultButton(
                        buttonFunc: () {},
                        buttonWidth: 300,
                        isText: true,
                        title: "REGISTER"),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have account?",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w400),
                        ),
                        defaultTextButton(
                          onPressed: () =>
                              navigatReplace(context, const LoginScreen()),
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
  }
}

Widget loginMethodContainer({
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
