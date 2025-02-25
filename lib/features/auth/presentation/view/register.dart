import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:googleapis/cloudsearch/v1.dart';
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
  late TextEditingController _confirmPassword;
  late TextEditingController _phoneController;

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
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppPaddings.p20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(StringsManager.signup,
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge!
                            .copyWith(
                                fontSize: AppSizesDouble.s40,
                                color: ColorsManager.black)),
                    const SizedBox(
                      height: AppSizesDouble.s25,
                    ),
                    defaultLoginInputField(_nameController,
                        StringsManager.fullName, TextInputType.name,
                        textInputAction: TextInputAction.next),
                    const SizedBox(
                      height: AppSizesDouble.s15,
                    ),
                    defaultLoginInputField(_emailController,
                        StringsManager.email, TextInputType.emailAddress,
                        loginCubit: AuthCubit.get(context),
                        textInputAction: TextInputAction.next),
                    const SizedBox(
                      height: AppSizesDouble.s15,
                    ),
                    defaultLoginInputField(_phoneController,
                        StringsManager.phoneNumber, TextInputType.phone,
                        textInputAction: TextInputAction.next),
                    const SizedBox(
                      height: AppSizesDouble.s15,
                    ),
                    defaultLoginInputField(_passwordController,
                        StringsManager.password, TextInputType.visiblePassword,
                        isPassword: true,
                        loginCubit: AuthCubit.get(context),
                        suffixIcon: IconsManager.eyeIcon,
                        textInputAction: TextInputAction.next),
                    const SizedBox(
                      height: AppSizesDouble.s15,
                    ),
                    defaultLoginInputField(
                        _confirmPassword,
                        StringsManager.confirmPassword,
                        TextInputType.visiblePassword,
                        isPassword: true,
                        loginCubit: AuthCubit.get(context),
                        isConfirmPassword: true,
                        validationMessage: StringsManager.passwordNotMatchingError,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return StringsManager.emptyFieldWarning;
                          } else if (value != _passwordController.text) {
                            return 'Passwords does not match';
                          }
                          return null;
                        },
                        onFieldSubmit: (_) => _onFieldSubmit(
                            context,
                            _nameController,
                            _emailController,
                            _passwordController,
                            _phoneController)),
                    const SizedBox(
                      height: AppSizesDouble.s15,
                    ),
                    state is RegisterLoading ? const Center(
                      child: CircularProgressIndicator(),
                    ) : defaultLoginButton(
                      context,
                      _formKey,
                      AuthCubit.get(context),
                      _emailController,
                      _passwordController,
                      StringsManager.signup,
                      isSignUp: true,
                      onPressed: () => _onFieldSubmit(
                        context,
                        _nameController,
                        _emailController,
                        _passwordController,
                        _phoneController
                      )
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  _onFieldSubmit(context, nameController, emailController, passwordController,
      phoneController) {
    if (_formKey.currentState!.validate()) {
      UserInfo userInfo = UserInfo(
          name: nameController.text,
          email: emailController.text.toLowerCase(),
          password: passwordController.text,
          phone: phoneController.text);
      navigate(
        context,
        SelectImage(
          userInfo: userInfo,
        )
      );
    }
  }
}
