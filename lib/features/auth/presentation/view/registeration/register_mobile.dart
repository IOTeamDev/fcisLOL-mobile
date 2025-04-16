import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:googleapis/cloudsearch/v1.dart';
import 'package:lol/core/network/remote/fcm_helper.dart' show FCMHelper;
import 'package:lol/core/utils/components.dart';
import 'package:lol/core/utils/resources/icons_manager.dart';
import 'package:lol/core/utils/resources/values_manager.dart';
import 'package:lol/features/auth/data/models/registration_user_model.dart';
import 'package:lol/features/auth/presentation/view/widgets/custom_drop_down_button.dart';
import 'package:lol/features/auth/presentation/view_model/auth_cubit/auth_cubit.dart';
import 'package:lol/features/auth/presentation/view_model/login_cubit/login_cubit.dart';
import 'package:lol/features/auth/presentation/view_model/login_cubit/login_cubit_states.dart';
import 'package:lol/features/auth/presentation/view/login.dart';
import 'package:lol/core/utils/resources/constants_manager.dart';
import 'package:lol/features/home/presentation/view/home.dart';
import 'package:lol/core/utils/navigation.dart';
import 'package:lol/core/network/local/shared_preference.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../../core/utils/resources/colors_manager.dart';
import '../../../../../core/utils/resources/strings_manager.dart';

class RegisterMobile extends StatefulWidget {
  const RegisterMobile({super.key});

  @override
  State<RegisterMobile> createState() => _RegisterscreenState();
}

class _RegisterscreenState extends State<RegisterMobile> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPassword;
  late TextEditingController _phoneController;
  late String _selectedSemester;

  final RegExp emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  var _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPassword = TextEditingController();
    _phoneController = TextEditingController();
    _selectedSemester = 'Semester 2';
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
                Text(StringsManager.signup,
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                          fontSize: AppSizesDouble.s40,
                        )),
                const SizedBox(
                  height: AppSizesDouble.s25,
                ),
                defaultLoginInputField(_nameController, StringsManager.fullName,
                    TextInputType.name,
                    textInputAction: TextInputAction.next),
                const SizedBox(
                  height: AppSizesDouble.s15,
                ),
                defaultLoginInputField(
                  _emailController,
                  StringsManager.email,
                  TextInputType.emailAddress,
                  loginCubit: AuthCubit.get(context),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return StringsManager.emptyFieldWarning;
                    } else if (!emailRegExp.hasMatch(value)) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: AppSizesDouble.s15,
                ),
                defaultLoginInputField(_phoneController,
                    StringsManager.phoneNumber, TextInputType.phone,
                    textInputAction: TextInputAction.next),
                const SizedBox(
                  height: AppSizesDouble.s15,
                ),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    return defaultLoginInputField(_passwordController,
                        StringsManager.password, TextInputType.visiblePassword,
                        isPassword: true,
                        loginCubit: AuthCubit.get(context),
                        suffixIcon: IconsManager.eyeIcon,
                        textInputAction: TextInputAction.next);
                  },
                ),
                const SizedBox(
                  height: AppSizesDouble.s15,
                ),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    return defaultLoginInputField(
                      _confirmPassword,
                      StringsManager.confirmPassword,
                      TextInputType.visiblePassword,
                      isPassword: true,
                      loginCubit: AuthCubit.get(context),
                      isConfirmPassword: true,
                      validationMessage:
                          StringsManager.passwordNotMatchingError,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return StringsManager.emptyFieldWarning;
                        } else if (value != _passwordController.text) {
                          return 'Passwords does not match';
                        }
                        return null;
                      },
                    );
                  },
                ),
                const SizedBox(
                  height: AppSizesDouble.s15,
                ),
                CustomDropDownButton(
                  labelText: 'Semester',
                  items: AuthCubit.semesters,
                  value: _selectedSemester,
                  onChanged: (value) {
                    _selectedSemester = value!;
                  },
                ),
                const SizedBox(
                  height: AppSizesDouble.s15,
                ),
                defaultLoginButton(
                    context,
                    _formKey,
                    AuthCubit.get(context),
                    _emailController,
                    _passwordController,
                    StringsManager.signup,
                    isSignUp: true, onPressed: () async {
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
                          semester: _selectedSemester,
                          fcmToken: fcmToken,
                          photo: AppConstants.defaultProfileImage,
                        );
                  }
                }),
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
