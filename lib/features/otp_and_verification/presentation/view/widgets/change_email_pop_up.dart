import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/core/utils/resources/strings_manager.dart';
import 'package:lol/features/otp_and_verification/presentation/view_model/verification_cubit/verification_cubit.dart';

import '../../../../../core/utils/resources/colors_manager.dart';
import '../../../../../core/utils/resources/values_manager.dart';

class ChangeEmailPopUp extends StatefulWidget {
  ChangeEmailPopUp({super.key, required this.currentEmail});

  late String currentEmail;

  @override
  State<ChangeEmailPopUp> createState() => _ChangeEmailPopUpState();
}

class _ChangeEmailPopUpState extends State<ChangeEmailPopUp> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;

  @override
  void initState() {
    _emailController = TextEditingController(text: widget.currentEmail);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ColorsManager.darkPrimary,
      actionsAlignment: MainAxisAlignment.center,
      scrollable: true,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(StringsManager.changeEmail, style: Theme.of(context).textTheme.headlineLarge,),
          SizedBox(height: AppSizesDouble.s15,),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _emailController,
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: StringsManager.emailAddress,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: ColorsManager.lightPrimary)
                    )
                  ),
                  keyboardType: TextInputType.text,
                  cursorColor: ColorsManager.lightPrimary,
                  validator: (value){
                    if(value!.isEmpty){
                      return StringsManager.emptyFieldWarning;
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: AppSizesDouble.s20,),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: ColorsManager.white),
                  onPressed: (){Navigator.of(context).pop();},
                  child: FittedBox(child: Text(StringsManager.cancel, style: Theme.of(context).textTheme.titleLarge!.copyWith(color: ColorsManager.black),))
                )
              ),
              SizedBox(width: AppSizesDouble.s20,),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: ColorsManager.lightPrimary),
                  onPressed: (){
                    if(_formKey.currentState!.validate()){
                      Navigator.of(context).pop(_emailController.text);
                    }
                  },
                  child: FittedBox(child: Text(StringsManager.submit, style: Theme.of(context).textTheme.titleLarge!.copyWith(color: ColorsManager.white),))
                )
              ),
            ],
          ),
        ],
      ),
    );
  }
}
