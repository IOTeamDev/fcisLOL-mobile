import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:lol/core/utils/components.dart';
import 'package:lol/core/utils/resources/icons_manager.dart';
import 'package:lol/core/utils/resources/values_manager.dart';
import 'package:lol/core/widgets/default_button.dart';
import 'package:lol/core/widgets/default_text_button.dart';
import 'package:lol/core/widgets/default_text_field.dart';
import 'package:lol/core/widgets/snack.dart';
import 'package:lol/features/auth/presentation/view_model/auth_cubit/auth_cubit.dart';
import 'package:lol/features/auth/presentation/view_model/login_cubit/login_cubit.dart';
import 'package:lol/features/auth/presentation/view_model/login_cubit/login_cubit_states.dart';
import 'package:lol/features/auth/presentation/view/login.dart';
import 'package:lol/features/auth/presentation/view/select_image.dart';
import 'package:lol/core/utils/resources/constants_manager.dart';
import 'package:lol/features/home/presentation/view/home.dart';
import 'package:lol/core/utils/navigation.dart';
import 'package:lol/core/network/local/shared_preference.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../core/utils/resources/colors_manager.dart';
import '../../../../core/utils/resources/strings_manager.dart';

class UserInfo {
  late String name;
  late String email;
  late String password;
  late String phone;
  String? photo;

  UserInfo(
      {required this.name,
      required this.email,
      required this.password,
      this.photo,
      required this.phone});
}

class Registerscreen extends StatefulWidget {
  const Registerscreen({super.key});

  @override
  State<Registerscreen> createState() => _RegisterscreenState();
}

class _RegisterscreenState extends State<Registerscreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirimPassword;
  late TextEditingController _phoneController;
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirimPassword = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirimPassword.dispose();
    _phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    var _formKey = GlobalKey<FormState>();
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Scaffold(
          body: Builder(builder: (context) {
            return SafeArea(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
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

                        const SizedBox(
                          width: 10,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        // const Row(
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   children: [
                        //     Expanded(child: Divider()),

                        //     Text(
                        //       "   or  ",
                        //       style: TextStyle(fontSize: 17),
                        //     ),
                        //     Expanded(child: Divider()),
                        //     // Expanded(child: HalfDivider(context)),
                        //   ],
                        // ),
                        const SizedBox(
                          height: 5,
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
                            defaultTextField(
                                textInputAction: TextInputAction.next,
                                validateor: (value) {
                                  if (value!.isEmpty) {
                                    return "field cannot be empty";
                                  } else {
                                    return null; // Form is valid.
                                  }
                                },
                                controller: _nameController),
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
                            defaultTextField(
                                textInputAction: TextInputAction.next,
                                validateor: (value) {
                                  if (value!.isEmpty) {
                                    return "field cannot be empty";
                                  }
                                  if (!emailRegExp.hasMatch(value)) {
                                    return "Invalid email format";
                                  } else {
                                    return null; // Form is valid.
                                  }
                                },
                                controller: _emailController,
                                type: TextInputType.emailAddress),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "Phone number",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                const Spacer(),
                                Text(
                                  "Optional",
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            defaultTextField(
                                textInputAction: TextInputAction.next,

                                // label: "Phone",
                                controller: _phoneController),
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
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            defaultTextField(
                                textInputAction: TextInputAction.next,
                                validateor: (value) {
                                  if (value!.isEmpty) {
                                    return "field cannot be empty";
                                  }
                                  return null;
                                },
                                controller: _passwordController,
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
                            defaultTextField(
                                onFieldSubmitted: (v) {
                                  if (_formKey.currentState!.validate()) {
                                    UserInfo userInfo = UserInfo(
                                        name: _nameController.text,
                                        email:
                                            _emailController.text.toLowerCase(),
                                        password: _passwordController.text,
                                        phone: _phoneController.text);
                                    navigate(
                                        context,
                                        SelectImage(
                                          userInfo: userInfo,
                                        ));
                                  }
                                },
                                validateor: (value) {
                                  if (value != _passwordController.text) {
                                    return "Passwords doesn't matched";
                                  } else {
                                    return null; // Form is valid.
                                  }
                                },
                                controller: _confirimPassword,
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
                                color: Color(0xff4763C4),
                                buttonFunc: () {
                                  if (_formKey.currentState!.validate()) {
                                    UserInfo userInfo = UserInfo(
                                        name: _nameController.text,
                                        email:
                                            _emailController.text.toLowerCase(),
                                        password: _passwordController.text,
                                        phone: _phoneController.text);
                                    navigate(
                                        context,
                                        SelectImage(
                                          userInfo: userInfo,
                                        ));
                                  }
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
                              style: TextStyle(fontWeight: FontWeight.w400),
                            ),
                            defaultTextButton(
                                onPressed: () => navigatReplace(
                                    context, const LoginScreen()),
                                text: "Login",
                                color: Colors.blue),
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
    );
  }
}
