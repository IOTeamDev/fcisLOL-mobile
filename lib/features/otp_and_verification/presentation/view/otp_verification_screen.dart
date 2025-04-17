import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit_states.dart';
import 'package:lol/core/utils/components.dart';
import 'package:lol/core/utils/navigation.dart';
import 'package:lol/core/utils/resources/assets_manager.dart';
import 'package:lol/core/utils/resources/colors_manager.dart';
import 'package:lol/core/utils/resources/constants_manager.dart';
import 'package:lol/features/auth/presentation/view/registration_layout.dart';
import 'package:lol/features/auth/presentation/view_model/auth_cubit/auth_cubit.dart';
import 'package:lol/features/home/presentation/view/home.dart';
import 'package:lol/features/otp_and_verification/presentation/view_model/verification_cubit/verification_cubit.dart';
import 'package:lol/features/pick_image/presentation/view/select_image.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../core/utils/resources/values_manager.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String selectedMethod;
  final String? recipientEmail;

  OtpVerificationScreen(
      {super.key, required this.selectedMethod, this.recipientEmail});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  late TextEditingController _otpController;

  @override
  void initState() {
    super.initState();
    _otpController = TextEditingController();
    _sendVerificationCode();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VerificationCubit, VerificationState>(
      listener: (context, state) {
        if (state is EmailVerifiedSuccess) {
          showToastMessage(
            message: 'Your Email is verified now.',
            states: ToastStates.SUCCESS
          );
          if (context.read<MainCubit>().profileModel!.photo == AppConstants.defaultProfileImage) {
            navigatReplace(context, SelectImage());
          } else {
            navigatReplace(context, Home());
          }
        }
        if (state is EmailVerifiedFailed) {
          showToastMessage(
              message: state.errMessage, states: ToastStates.ERROR);
        }
      },
      child: BlocListener<MainCubit, MainCubitStates>(
        listener: (context, state) {
          if (state is LogoutSuccess) {
            navigatReplace(context, RegistrationLayout());
          }
        },
        child: Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                onPressed: () async {
                  await context.read<MainCubit>().logout(context);
                },
                icon: Icon(Icons.logout))
            ],
          ),
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
                      image: DecorationImage(image: AssetImage(AssetsManager.verification_screen_logo))),
                  ),
                  SizedBox(
                    height: AppSizesDouble.s15,
                  ),
                  FittedBox(
                    child: Text(
                      'OTP Verification',
                      style: Theme.of(context).textTheme.displayMedium,
                    )
                  ),
                  SizedBox(
                    height: AppSizesDouble.s5,
                  ),
                  FittedBox(child: Text('Enter The Otp Sent to "${widget.recipientEmail}"')),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: AppSizesDouble.s30, vertical: AppSizesDouble.s50),
                  width: double.infinity,
                  height: AppQueries.screenHeight(context) / AppSizes.s2,
                  decoration: BoxDecoration(
                      color: ColorsManager.darkPrimary,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(AppSizesDouble.s95))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PinCodeTextField(
                        autoFocus: true,
                        controller: _otpController,
                        appContext: context,
                        length: AppSizes.s6,
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
                            shape: PinCodeFieldShape.underline),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            foregroundColor: ColorsManager.white,
                            fixedSize: Size(AppQueries.screenWidth(context),
                                AppSizesDouble.s50),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(AppSizesDouble.s15)),
                            backgroundColor: ColorsManager.lightPrimary),
                        onPressed: () async {
                          await context.read<VerificationCubit>().verityEmail(
                              profile: context.read<MainCubit>().profileModel!,
                              otp: _otpController.text);
                        },
                        child: Text(
                          'Verify',
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge!
                              .copyWith(color: ColorsManager.white),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Text(
                        "didn't Receive a code?",
                        style: TextStyle(color: ColorsManager.lightGrey1),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // if (!VerificationCubit.get(context).canResendCode)
                      //   StreamBuilder<int>(
                      //       stream:
                      //           VerificationCubit.get(context).timerStream,
                      //       builder: (context, snapshot) {
                      //         return Text(VerificationCubit.get(context)
                      //             .currentTime
                      //             .toString());
                      //       }),
                      TextButton(
                        onPressed: () {},
                        // VerificationCubit.get(context).canResendCode
                        //     ? () => VerificationCubit.get(context)
                        //         .counter(counter: 60)
                        //     : null,
                        style: TextButton.styleFrom(
                            foregroundColor: ColorsManager.lightPrimary,
                            disabledForegroundColor: ColorsManager.lightGrey),
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

  Future<void> _sendVerificationCode() async {
    await context
        .read<VerificationCubit>()
        .sendVerificationCode(recepientEmail: widget.recipientEmail!);
  }
}
