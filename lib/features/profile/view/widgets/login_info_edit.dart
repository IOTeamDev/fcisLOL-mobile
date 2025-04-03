import 'package:flutter/material.dart';
import 'package:lol/core/utils/resources/icons_manager.dart';

import '../../../../core/utils/resources/colors_manager.dart';
import '../../../../core/utils/resources/strings_manager.dart';
import '../../../../core/utils/resources/values_manager.dart';

class LoginInfoEdit extends StatefulWidget {
  LoginInfoEdit({super.key});

  @override
  State<LoginInfoEdit> createState() => _LoginInfoEditState();
}

class _LoginInfoEditState extends State<LoginInfoEdit> {
  bool isPasswordVisible = false;
  TextEditingController _currentPasswordController = TextEditingController();
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
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Current Password', style: Theme.of(context).textTheme.titleMedium,),
            SizedBox(height: 5,),
            TextFormField(
              controller: _currentPasswordController,
              keyboardType: TextInputType.visiblePassword,
              obscureText: !isPasswordVisible,
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
              obscureText: !isPasswordVisible,
              validator: (value){
                if(value == null){
                  return StringsManager.emptyFieldWarning;
                } else if(_currentPasswordController.text.isEmpty){
                  return 'Current Password must not be empty!';
                }else if(_currentPasswordController.text == _newPasswordController.text){
                  return 'Current Password must not equal the new Password';
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
              controller: _confirmNewPasswordController,
              keyboardType: TextInputType.visiblePassword,
              obscureText: !isPasswordVisible,
              validator: (value){
                if(value == null){
                  return StringsManager.emptyFieldWarning;
                } else if(_newPasswordController.text.isEmpty){
                  return "New Password must not be empty";
                } else if(_confirmNewPasswordController.text != _newPasswordController.text){
                  return 'Confirm Password and New Password must be equal';
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
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsManager.lightPrimary,
                  foregroundColor: ColorsManager.white,
                  padding: EdgeInsets.symmetric(vertical: 12)
                ),
                onPressed: (){},
                child: Text('Change Password')
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }
}
