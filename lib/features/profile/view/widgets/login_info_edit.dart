import 'package:flutter/material.dart';
import 'package:lol/core/presentation/cubits/main_cubit/main_cubit.dart';
import 'package:lol/core/presentation/app_icons.dart';
import 'package:lol/features/otp_and_verification/presentation/view_model/verification_cubit/verification_cubit.dart';
import '../../../../core/resources/theme/colors_manager.dart';
import '../../../../core/resources/theme/values/app_strings.dart';
import '../../../../core/resources/theme/values/values_manager.dart';

class LoginInfoEdit extends StatefulWidget {
  LoginInfoEdit({super.key});

  @override
  State<LoginInfoEdit> createState() => _LoginInfoEditState();
}

class _LoginInfoEditState extends State<LoginInfoEdit> {
  bool isPasswordVisible = false;
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmNewPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'New Password',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(
                height: 5,
              ),
              TextFormField(
                controller: _newPasswordController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: !isPasswordVisible,
                validator: (value) {
                  if (value == null) {
                    return AppStrings.emptyFieldWarning;
                  }
                  return null;
                },
                cursorColor: ColorsManager.lightPrimary,
                style: TextStyle(
                    color: ColorsManager.black, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  hintText: 'New Password',
                  hintStyle: TextStyle(color: ColorsManager.grey),
                  filled: true,
                  fillColor: ColorsManager.grey7,
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          BorderSide(color: ColorsManager.lightPrimary)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: ColorsManager.white)),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: ColorsManager.imperialRed)),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Confirm New Password',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(
                height: 5,
              ),
              TextFormField(
                controller: _confirmNewPasswordController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: !isPasswordVisible,
                validator: (value) {
                  if (value == null) {
                    return AppStrings.emptyFieldWarning;
                  } else if (_newPasswordController.text.isEmpty) {
                    return "New Password must not be empty";
                  } else if (_confirmNewPasswordController.text !=
                      _newPasswordController.text) {
                    return 'Confirm Password and New Password must be equal';
                  }
                  return null;
                },
                cursorColor: ColorsManager.lightPrimary,
                style: TextStyle(
                    color: ColorsManager.black, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  hintText: 'Confirm New Password',
                  hintStyle: TextStyle(color: ColorsManager.grey),
                  filled: true,
                  fillColor: ColorsManager.grey7,
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          BorderSide(color: ColorsManager.lightPrimary)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: ColorsManager.white)),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: ColorsManager.imperialRed)),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsManager.lightPrimary,
                        foregroundColor: ColorsManager.white,
                        padding: EdgeInsets.symmetric(vertical: 15)),
                    onPressed: () {
                      //*check for this logic if it works or not
                      MainCubit.get(context).updateCurrentUser(
                          password: _newPasswordController.text);
                    },
                    child: Text('Change Password')),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }
}
