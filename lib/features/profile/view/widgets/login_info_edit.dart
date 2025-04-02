import 'package:flutter/material.dart';
import 'package:lol/core/utils/resources/icons_manager.dart';

import '../../../../core/utils/resources/colors_manager.dart';
import '../../../../core/utils/resources/strings_manager.dart';
import '../../../../core/utils/resources/values_manager.dart';

class LoginInfoEdit extends StatefulWidget {
  late String email;
  LoginInfoEdit({super.key, required this.email});

  @override
  State<LoginInfoEdit> createState() => _LoginInfoEditState();
}

class _LoginInfoEditState extends State<LoginInfoEdit> {
  late TextEditingController _emailController;
  bool isPasswordVisible = false;
  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmNewPasswordController = TextEditingController();

  @override
  void initState() {
    _emailController = TextEditingController(text: widget.email);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Email Address', style: Theme.of(context).textTheme.titleMedium,),
              SizedBox(height: 5,),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value){
                  if(value == null){
                    return StringsManager.emptyFieldWarning;
                  }
                  return null;
                },
                cursorColor: ColorsManager.lightPrimary,
                style: TextStyle(color: ColorsManager.black, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  hintText: 'Email Address',
                  hintStyle: TextStyle(color: ColorsManager.grey),
                  filled: true,
                  fillColor: ColorsManager.grey7,
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: ColorsManager.lightPrimary)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: ColorsManager.white)),
                  errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: ColorsManager.imperialRed)),
                ),
              ),
              SizedBox(height: 10,),
              Text('Current Password', style: Theme.of(context).textTheme.titleMedium,),
              SizedBox(height: 5,),
              TextFormField(
                controller: _currentPasswordController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: isPasswordVisible,
                validator: (value){
                  if(value == null){
                    return StringsManager.emptyFieldWarning;
                  }
                  return null;
                },
                cursorColor: ColorsManager.lightPrimary,
                style: TextStyle(color: ColorsManager.black, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  hintText: 'Current Password',
                  hintStyle: TextStyle(color: ColorsManager.grey),
                  filled: true,
                  fillColor: ColorsManager.grey7,
                  suffixIcon: IconButton(
                    onPressed: (){
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                    icon: Icon(IconsManager.eyeIcon, color: isPasswordVisible? ColorsManager.lightPrimary:ColorsManager.grey,)
                  ),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: ColorsManager.lightPrimary)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: ColorsManager.white)),
                  errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: ColorsManager.imperialRed)),
                ),
              ),
              SizedBox(height: 10,),
              Text('New Password', style: Theme.of(context).textTheme.titleMedium,),
              SizedBox(height: 5,),
              TextFormField(
                controller: _newPasswordController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: isPasswordVisible,
                validator: (value){
                  if(value == null || _currentPasswordController.text.isEmpty){
                    return StringsManager.emptyFieldWarning;
                  }
                  return null;
                },
                cursorColor: ColorsManager.lightPrimary,
                style: TextStyle(color: ColorsManager.black, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  hintText: 'New Password',
                  hintStyle: TextStyle(color: ColorsManager.grey),
                  filled: true,
                  fillColor: ColorsManager.grey7,
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: ColorsManager.lightPrimary)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: ColorsManager.white)),
                  errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: ColorsManager.imperialRed)),
                ),
              ),
              SizedBox(height: 10,),
              Text('Confirm New Password', style: Theme.of(context).textTheme.titleMedium,),
              SizedBox(height: 5,),
              TextFormField(
                controller: _currentPasswordController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: isPasswordVisible,
                validator: (value){
                  if(value == null){
                    return StringsManager.emptyFieldWarning;
                  } else if(_newPasswordController.text.isEmpty){
                    return "Current Password must not be empty";
                  }
                  return null;
                },
                cursorColor: ColorsManager.lightPrimary,
                style: TextStyle(color: ColorsManager.black, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  hintText: 'Confirm New Password',
                  hintStyle: TextStyle(color: ColorsManager.grey),
                  filled: true,
                  fillColor: ColorsManager.grey7,
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: ColorsManager.lightPrimary)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: ColorsManager.white)),
                  errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: ColorsManager.imperialRed)),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: (){},
                  child: Text('Forgot Password', style: TextStyle(color: ColorsManager.dodgerBlue, decoration: TextDecoration.underline, decorationColor: ColorsManager.dodgerBlue),)
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
