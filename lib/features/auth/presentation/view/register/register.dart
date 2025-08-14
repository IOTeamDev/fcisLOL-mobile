import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:googleapis/cloudsearch/v1.dart';
import 'package:lol/core/network/remote/fcm_helper.dart' show FCMHelper;
import 'package:lol/features/auth/presentation/view/widgets/auth_elevated_button.dart';
import 'package:lol/features/auth/presentation/view/widgets/auth_text_form_field.dart';
import 'package:lol/core/utils/components.dart';
import 'package:lol/core/presentation/app_icons.dart';
import 'package:lol/core/resources/theme/values/values_manager.dart';
import 'package:lol/features/auth/data/models/registration_user_model.dart';
import 'package:lol/features/auth/presentation/auth_constants/auth_strings.dart';
import 'package:lol/features/auth/presentation/view/widgets/custom_drop_down_button.dart';
import 'package:lol/features/auth/presentation/cubits/auth_cubit/auth_cubit.dart';

import 'package:lol/features/auth/presentation/view/login/login.dart';
import 'package:lol/core/resources/constants/constants_manager.dart';
import 'package:lol/features/home/presentation/view/home.dart';
import 'package:lol/core/utils/navigation.dart';
import 'package:lol/core/network/local/shared_preference.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../../core/resources/theme/colors_manager.dart';
import '../../../../../core/resources/theme/values/app_strings.dart';
import '../../auth_constants/semesters.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterscreenState();
}

class _RegisterscreenState extends State<RegisterScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPassword;
  late TextEditingController _phoneController;
  String? _selectedSemester;

  var _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPassword = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPassword.dispose();
    _phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: _formKey,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppPaddings.p20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppStrings.signup,
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                          fontSize: AppSizesDouble.s40,
                        )),
                const SizedBox(
                  height: AppSizesDouble.s25,
                ),
                AuthTextFormField(
                  controller: _nameController,
                  label: AppStrings.fullName,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(
                  height: AppSizesDouble.s15,
                ),
                AuthTextFormField(
                  controller: _emailController,
                  label: AppStrings.email,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStrings.emptyFieldWarning;
                    } else if (!emailRegExp.hasMatch(value)) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: AppSizesDouble.s15,
                ),
                AuthTextFormField(
                  controller: _phoneController,
                  label: AppStrings.phoneNumber,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(
                  height: AppSizesDouble.s15,
                ),
                AuthTextFormField(
                  controller: _passwordController,
                  label: AppStrings.password,
                  isPassword: true,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(
                  height: AppSizesDouble.s15,
                ),
                AuthTextFormField(
                  controller: _confirmPassword,
                  label: AppStrings.confirmPassword,
                  isPassword: true,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStrings.emptyFieldWarning;
                    } else if (_confirmPassword.text !=
                        _passwordController.text) {
                      return 'Passwords does not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: AppSizesDouble.s15,
                ),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    if (state is SelectedSemesterChanged) {
                      _selectedSemester = state.semester;
                    }
                    return CustomDropDownButton(
                      labelText: 'Semester',
                      items: semesters,
                      value: _selectedSemester,
                      onChanged: (value) {
                        if (value != null) {
                          context
                              .read<AuthCubit>()
                              .changeSelectedSemester(semester: value);
                        }
                      },
                    );
                  },
                ),
                const SizedBox(
                  height: AppSizesDouble.s15,
                ),
                AuthElevatedButton(
                  text: AppStrings.signup,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      FCMHelper fCMHelper = FCMHelper();
                      fCMHelper.initNotifications();
                      String? fcmToken =
                          await FirebaseMessaging.instance.getToken();
                      await context.read<AuthCubit>().register(
                            name: _nameController.text,
                            email: _emailController.text,
                            phone: _phoneController.text,
                            password: _passwordController.text,
                            semester: _selectedSemester!,
                            fcmToken: fcmToken,
                            photo: AppConstants.defaultProfileImage,
                          );
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // _onFieldSubmit(context, nameController, emailController, passwordController,
  //     phoneController) {
  //   if (_formKey.currentState!.validate()) {
  //     UserInfo userInfo = UserInfo(
  //         name: nameController.text,
  //         email: emailController.text.toLowerCase(),
  //         password: passwordController.text,
  //         phone: phoneController.text);
  //     navigate(
  //       context,
  //       SelectImage(
  //         userInfo: userInfo,
  //       )
  //     );
  //   }
  // }
}
