import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
// import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:lol/shared/components/default_button.dart';
import 'package:lol/shared/components/default_text_button.dart';
import 'package:lol/shared/components/default_text_field.dart';
import 'package:lol/shared/components/snack.dart';
import 'package:lol/shared/styles/colors.dart';
import 'package:lol/modules/auth/bloc/login_cubit.dart';
import 'package:lol/modules/auth/bloc/login_cubit_states.dart';
import 'package:lol/modules/auth/screens/login.dart';
import 'package:lol/modules/auth/screens/select_image.dart';
import 'package:lol/shared/components/constants.dart';
import 'package:lol/layout/home/home.dart';
import 'package:lol/shared/components/navigation.dart';
import 'package:lol/shared/network/local/shared_prefrence.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../main.dart';

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
          // if (state is RegisterSuccess) {
          //   // token=state.token;
          //   TOKEN=state.token;
          //   Cache.writeData(key: "token", value: state.token);
          //   print(state.token);
          //   snack(
          //       context: context,
          //       enumColor: Messages.success,
          //       titleWidget: const Text("Successfully signed up !"));

          //   navigatReplace(context, const Home());
          // }
          // if (state is RegisterFailed) {
          //   snack(
          //       context: context,
          //       enumColor: Messages.error,
          //       titleWidget:
          //           const Text("Please try with another email address"));
          // }
        },
        builder: (context, state) {
          return Scaffold(
            body: Builder(builder: (context) {
              return SafeArea(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                    child: Form(
                      key: formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // SizedBox(
                            //   height: 10,
                            // ),
                             Text(
                              "Sign UP",
                              style: TextStyle(
                                  // letterSpacing: 3,
                                  // color: Additional2,
                                  fontSize: screenWidth(context)/10,
                                  fontWeight: FontWeight.bold),
                            ),
                            // const Text(
                            //     "Welcome! Please fill in the details to get started"),
                            // const SizedBox(
                            //   height: 20,
                            // ),
                            //
                            // const SizedBox(
                            //   width: 10,
                            // ),
                            // const SizedBox(
                            //   height: 10,
                            // ),
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
                            // const SizedBox(
                            //   height: 5,
                            // ),
                            Column(
                              children: [
                                // const Align(
                                //   alignment: Alignment.topLeft,
                                //   child: Text(
                                //     "Name",
                                //     style: TextStyle(
                                //         fontSize: 16,
                                //         fontWeight: FontWeight.w600),
                                //   ),
                                // ),
                                // const SizedBox(
                                //   height: 5,
                                // ),
                                // defaultTextField(
                                //     validateor: (value) {
                                //       if (value!.isEmpty) {
                                //         return "Field cannot be empty";
                                //       } else {
                                //         return null; // Form is valid.
                                //       }
                                //     },
                                //     controller: nameController),
                                const SizedBox(
                                  height: 30,
                                ),
                                TextFormField(
                                  controller: nameController,
                                  keyboardType: TextInputType.name,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Field cannot be empty";
                                    } else {
                                      return null; // Form is valid.
                                    }
                                  },
                                  style: TextStyle(color: isDark? Colors.white: Colors.black),
                                  decoration: InputDecoration(
                                      hintText: 'Full Name',
                                      hintStyle: TextStyle(color: isDark? Colors.grey: Colors.grey[600]),
                                      filled: true,
                                      fillColor: isDark? Colors.white:Colors.grey[350],
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20),
                                          borderSide: BorderSide.none
                                      )
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Column(
                              children: [
                                // const Align(
                                //   alignment: Alignment.topLeft,
                                //   child: Text(
                                //     "Email address",
                                //     style: TextStyle(
                                //         fontSize: 16,
                                //         fontWeight: FontWeight.w600),
                                //   ),
                                // ),
                                // const SizedBox(
                                //   height: 5,
                                // ),
                                // defaultTextField(
                                //     validateor: (value) {
                                //       if (value!.isEmpty) {
                                //         return "Field cannot be empty";
                                //       }
                                //       if (!emailRegExp.hasMatch(value)) {
                                //         return "Invalid email format";
                                //       } else {
                                //         return null; // Form is valid.
                                //       }
                                //     },
                                //     controller: emailController,
                                //     type: TextInputType.emailAddress),
                                TextFormField(
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Field cannot be empty";
                                    }
                                    if(!emailRegExp.hasMatch(value))
                                    {
                                      return 'Invalid Email format';
                                    } else {
                                      return null; // Form is valid.
                                    }
                                  },
                                  style: TextStyle(color: isDark? Colors.white: Colors.black),
                                  decoration: InputDecoration(
                                      hintText: 'Email Address',
                                      hintStyle: TextStyle(color: isDark? Colors.grey: Colors.grey[600]),
                                      filled: true,
                                      fillColor: isDark? Colors.white:Colors.grey[350],
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20),
                                          borderSide: BorderSide.none
                                      )
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Column(
  children: [
    // Uncomment and customize as needed
    // Row(
    //   children: [
    //     const Text(
    //       "Phone number",
    //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    //     ),
    //     const Spacer(),
    //     Text(
    //       "Optional",
    //       style: TextStyle(color: Colors.grey),
    //     ),
    //   ],
    // ),
    const SizedBox(height: 5),
    TextFormField(
      controller: phoneController,
      keyboardType: TextInputType.phone,
      style: TextStyle(color: isDark ? Colors.white : Colors.black),
      decoration: InputDecoration(
        hintText: 'Phone number (Optional)',
        hintStyle: TextStyle(color: isDark ? Colors.grey : Colors.grey[600]),
        filled: true,
        fillColor: isDark ? Colors.white : Colors.grey[350],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    ),
    const SizedBox(height: 15),
    Column(
      children: [
        // Uncomment and customize as needed
        // const Align(
        //   alignment: Alignment.topLeft,
        //   child: Text(
        //     "Password",
        //     style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        //   ),
        // ),
        // const SizedBox(height: 5),
        TextFormField(
          controller: passwordController,
          obscureText: LoginCubit.get(context).hiddenPassword,
          keyboardType: TextInputType.visiblePassword,
          validator: (value) {
            return null;
          },
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
          decoration: InputDecoration(
            hintText: 'Password',
            hintStyle: TextStyle(color: isDark ? Colors.grey : Colors.grey[600]),
            filled: true,
            suffixIcon: IconButton(
              icon: Icon(
                Icons.remove_red_eye,
                color: LoginCubit.get(context).hiddenPassword ? (isDark ? Colors.grey : null) : Colors.blue,
              ),
              onPressed: () {
                LoginCubit.get(context).togglePassword();
              },
            ),
            fillColor: isDark ? Colors.white : Colors.grey[350],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: confirimPassword, // Make sure to declare this controller
          obscureText: true,
          onFieldSubmitted: (val) {
            if (formKey.currentState!.validate()) {
              UserInfo userInfo = UserInfo(
                name: nameController.text,
                email: emailController.text.toLowerCase(),
                password: passwordController.text,
                phone: phoneController.text,
              );
              navigate(
                context,
                SelectImage(userInfo: userInfo),
              );
            }
          },
          validator: (value) {
            if (value!.isEmpty) {
              return "Field cannot be empty";
            } else if (value != passwordController.text) {
              return "Passwords don't match";
            } else {
              return null; // Form is valid
            }
          },
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
          decoration: InputDecoration(
            hintText: 'Confirm Password',
            hintStyle: TextStyle(color: isDark ? Colors.grey : Colors.grey[600]),
            filled: true,
            fillColor: isDark ? Colors.white : Colors.grey[350],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    ),
  ],
),

                            const SizedBox(
                              height: 15,
                            ),
                            state is RegisterLoading
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                 :
                                //defaultButton(
                                //     buttonFunc: () {
                                //       if (formKey.currentState!.validate()) {
                                //         UserInfo userInfo = UserInfo(
                                //             name: nameController.text,
                                //             email: emailController.text
                                //                 .toLowerCase(),
                                //             password: passwordController.text,
                                //             phone: phoneController.text);
                                //         navigate(
                                //             context,
                                //             SelectImage(
                                //               userInfo: userInfo,
                                //             ));
                                //       }
                                //       // LoginCubit.get(context).register(
                                //       //     name: nameController.text,
                                //       //     email: emailController.text,
                                //       //     phone: phoneController.text,
                                //       //     photo:
                                //       //         "https://upload.wikimedia.org/wikipedia/en/c/ce/Walter_White_Jr_S5B.png",
                                //       //     password: passwordController.text,
                                //       //     semester: "Four");
                                //     },
                                //     buttonWidth: 300,
                                //     title: "NEXT"),
                            MaterialButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  UserInfo userInfo = UserInfo(
                                      name: nameController.text,
                                      email: emailController.text.toLowerCase(),
                                      password: passwordController.text,
                                      phone: phoneController.text);
                                  navigate(context, SelectImage(userInfo: userInfo,));
                                }
                              },
                              padding: EdgeInsetsDirectional.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              color: HexColor('#4764C5'),
                              minWidth: double.infinity,
                              child: Text('NEXT', style: TextStyle(fontSize: screenWidth(context)/15, color: Colors.white),),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Already have account?",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400),
                                ),
                                // defaultTextButton(
                                //   onPressed: () => navigatReplace(
                                //       context, const LoginScreen()),
                                //   text: "Login",
                                // ),
                                TextButton(onPressed: () => navigatReplace(context, const LoginScreen()), child: Text('Register'))
                              ],
                            ),
                          ],
                        ),
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
