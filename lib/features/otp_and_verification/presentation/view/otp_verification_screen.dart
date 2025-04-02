import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/core/utils/resources/assets_manager.dart';
import 'package:lol/core/utils/resources/colors_manager.dart';
import 'package:lol/core/utils/resources/constants_manager.dart';
import 'package:lol/features/otp_and_verification/cubit/verification_cubit.dart';
import 'package:lol/features/otp_and_verification/cubit/verification_cubit_states.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../core/utils/resources/values_manager.dart';

class OtpVerificationScreen extends StatelessWidget {
  String selectedMethod;
  final TextEditingController _otpController = TextEditingController();
  OtpVerificationScreen({super.key, required this.selectedMethod});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VerificationCubit()..counter(),
      child: BlocConsumer<VerificationCubit, VerificationCubitStates>(
        listener: (context, state){},
        builder: (context, state) => Scaffold(
          appBar: AppBar(),
          body: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: AppSizesDouble.s150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorsManager.darkPrimary,
                      image: DecorationImage(image: AssetImage(AssetsManager.verification_screen_logo))
                    ),
                  ),
                  SizedBox(height: AppSizesDouble.s15,),
                  FittedBox(child: Text('OTP Verification', style: Theme.of(context).textTheme.displayMedium,)),
                  SizedBox(height: AppSizesDouble.s5,),
                  FittedBox(child: Text('Please Enter The Otp Sent to your $selectedMethod')),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
                  width: double.infinity,
                  height: AppQueries.screenHeight(context)/2,
                  decoration: BoxDecoration(
                    color: ColorsManager.darkPrimary,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(AppSizesDouble.s95))
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PinCodeTextField(
                        controller: _otpController,
                        appContext: context,
                        length: 6,
                        keyboardType: TextInputType.number,
                        cursorColor: ColorsManager.lightPrimary,
                        obscureText: false,
                        animationType: AnimationType.scale,
                        enableActiveFill: false,
                        textStyle: TextStyle(color: ColorsManager.white),
                        pinTheme: PinTheme(
                          borderRadius: BorderRadius.circular(10),
                          activeColor: ColorsManager.lightPrimary,
                          activeFillColor: ColorsManager.lightGrey1,
                          fieldHeight: 50,
                          borderWidth: 10,
                          inactiveFillColor: ColorsManager.white,
                          selectedColor: ColorsManager.lightPrimary,
                          shape: PinCodeFieldShape.underline
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                      SizedBox(height: 50,),
                      Text("didn't Receive a code?", style: TextStyle(color: ColorsManager.lightGrey1),),
                      SizedBox(height: 10,),
                      if(!VerificationCubit.get(context).canResendCode)
                        StreamBuilder<int>(
                          stream: VerificationCubit.get(context).timerStream,
                          builder: (context, snapshot) {
                            return Text(VerificationCubit.get(context).currentTime.toString());
                          }
                        ),
                      TextButton(
                        onPressed: VerificationCubit.get(context).canResendCode? () => VerificationCubit.get(context).counter(counter: 60):null,
                        style: TextButton.styleFrom(
                          foregroundColor: ColorsManager.lightPrimary,
                          disabledForegroundColor: ColorsManager.lightGrey
                        ),
                        child: Text('Send Again'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
