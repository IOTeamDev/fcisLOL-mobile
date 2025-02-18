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

class Registerscreen extends StatelessWidget {
  Registerscreen({super.key});

  var formKey = GlobalKey<FormState>();
  final RegExp emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  @override
  Widget build(BuildContext context) {
    var nameController = TextEditingController();
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var confirmPassword = TextEditingController();
    var phoneController = TextEditingController();

    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Form(
            key: formKey,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(AppPaddings.p20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        StringsManager.signup,
                        style: Theme
                          .of(context)
                          .textTheme
                          .headlineLarge!
                          .copyWith(
                          fontSize: AppSizesDouble.s40,
                          color: ColorsManager.black
                        )
                      ),
                      const SizedBox(height: AppSizesDouble.s25,),
                      defaultLoginInputField(
                        nameController,
                        StringsManager.fullName,
                        TextInputType.name
                      ),
                      const SizedBox(height: AppSizesDouble.s15,),
                      defaultLoginInputField(
                        emailController,
                        StringsManager.email,
                        TextInputType.emailAddress,
                        false,
                        LoginCubit.get(context)
                      ),
                      const SizedBox(height: AppSizesDouble.s15,),
                      defaultLoginInputField(
                        phoneController,
                        StringsManager.phoneNumber,
                        TextInputType.phone
                      ),
                      const SizedBox(height: AppSizesDouble.s15,),
                      defaultLoginInputField(
                        passwordController,
                        StringsManager.password,
                        TextInputType.visiblePassword,
                        true,
                        LoginCubit.get(context),
                        IconsManager.eyeIcon
                      ),
                      const SizedBox(height: AppSizesDouble.s15,),
                      defaultLoginInputField(
                        confirmPassword,
                        StringsManager.confirmPassword,
                        TextInputType.visiblePassword,
                        true,
                        LoginCubit.get(context),
                        null,
                        true,
                        StringsManager.passwordNotMatchingError,
                        (_) => _onFieldSubmit(context, nameController, emailController, passwordController, phoneController)
                      ),
                      const SizedBox(height: AppSizesDouble.s15,),
                      state is RegisterLoading ? const Center(child: CircularProgressIndicator(),) :
                      defaultLoginButton(context, formKey, LoginCubit.get(context), emailController, passwordController, StringsManager.signup),
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

  _onFieldSubmit(context, nameController, emailController, passwordController, phoneController) {
    if (formKey.currentState!.validate()) {
      UserInfo userInfo = UserInfo(
          name: nameController.text,
          email: emailController.text.toLowerCase(),
          password: passwordController.text,
          phone: phoneController.text
      );
      navigate(
          context,
          SelectImage(
            userInfo: userInfo,
          )
      );
    }
  }
}