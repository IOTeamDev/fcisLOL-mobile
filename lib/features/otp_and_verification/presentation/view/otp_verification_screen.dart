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
import 'package:lol/features/otp_and_verification/presentation/view/widgets/change_email_pop_up.dart';
import 'package:lol/features/otp_and_verification/presentation/view_model/verification_cubit/verification_cubit.dart';
import 'package:lol/features/pick_image/presentation/view/select_image.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../core/utils/resources/icons_manager.dart';
import '../../../../core/utils/resources/strings_manager.dart';
import '../../../../core/utils/resources/values_manager.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String? recipientEmail;
  OtpVerificationScreen({super.key, required this.recipientEmail});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  late TextEditingController _otpController;
  late String _recipientEmail;
  @override
  void initState() {
    super.initState();
    _otpController = TextEditingController();
    _recipientEmail = widget.recipientEmail!;
    context.read<VerificationCubit>().initializeStream();
    _sendVerificationCode();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VerificationCubit, VerificationState>(
      listener: (context, state) {
        if (state is EmailVerifiedSuccess) {
          showToastMessage(message: StringsManager.mailIsNowVerified, states: ToastStates.SUCCESS);
          if (context.read<MainCubit>().profileModel!.photo == AppConstants.defaultProfileImage) {
            navigatReplace(context, SelectImage());
          } else {
            navigatReplace(context, Home());
          }
        }
        if (state is EmailVerifiedFailed) {
          showToastMessage(message: state.errMessage, states: ToastStates.ERROR);
        }
        if (state is SendVerificationCodeToEmailFailed) {
          showToastMessage(message: state.errMessage, states: ToastStates.ERROR);
        }
      },
      builder: (context, state) => BlocListener<MainCubit, MainCubitStates>(
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
                icon: Icon(Icons.logout)
              )
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
                      image: DecorationImage(image: AssetImage(AssetsManager.verification_screen_logo))
                    ),
                  ),
                  SizedBox(height: AppSizesDouble.s15,),
                  FittedBox(
                    child: Text(
                      StringsManager.otpVerification,
                      style: Theme.of(context).textTheme.displayMedium,
                    )
                  ),
                  SizedBox(height: AppSizesDouble.s5,),
                  FittedBox(child: Text('Enter The Otp Sent to "${_recipientEmail}"')),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.center,
                    children: [
                      Text(StringsManager.wrongEmail, style: TextStyle(color: ColorsManager.lightGrey1),),
                      TextButton(
                        child: Text(
                          StringsManager.changeEmail,
                          style: TextStyle(color: ColorsManager.dodgerBlue),
                        ),
                        onPressed: () async{
                          String? email = await showDialog(
                            context: context,
                            builder: (context) => ChangeEmailPopUp(currentEmail: _recipientEmail)
                          );

                          if(email != null){
                            _recipientEmail = email;
                            context.read<VerificationCubit>().sendVerificationCode(recipientEmail: _recipientEmail);
                          }
                        },
                      ),
                    ],
                  )
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizesDouble.s30,
                    vertical: AppSizesDouble.s30
                  ),
                  width: double.infinity,
                  height: AppQueries.screenHeight(context) / AppSizes.s2,
                  decoration: BoxDecoration(
                    color: ColorsManager.darkPrimary,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(AppSizesDouble.s95))
                  ),
                  child: SingleChildScrollView(
                    child: Column(
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
                            borderRadius: BorderRadius.circular(AppSizesDouble.s10),
                            activeColor: ColorsManager.lightPrimary,
                            activeFillColor: ColorsManager.lightGrey1,
                            fieldHeight: AppSizesDouble.s50,
                            borderWidth: AppSizesDouble.s10,
                            inactiveFillColor: ColorsManager.white,
                            selectedColor: ColorsManager.lightPrimary,
                            shape: PinCodeFieldShape.underline
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                        const SizedBox(
                          height: AppSizesDouble.s15,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: ColorsManager.white,
                            fixedSize: Size(AppQueries.screenWidth(context), AppSizesDouble.s50),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizesDouble.s15)),
                            backgroundColor: ColorsManager.lightPrimary
                          ),
                          onPressed: () async {
                            await context.read<VerificationCubit>().verifyEmail(
                              id: context.read<MainCubit>().profileModel!.id,
                              otp: _otpController.text,
                              recipientEmail: _recipientEmail
                            );
                          },
                          child: Text(
                            StringsManager.verify,
                            style: Theme.of(context).textTheme.headlineLarge!.copyWith(color: ColorsManager.white),
                          ),
                        ),
                        const SizedBox(
                          height: AppSizesDouble.s50,
                        ),
                        Text(
                          StringsManager.noCodeReceived,
                          style: TextStyle(color: ColorsManager.lightGrey1),
                        ),
                        const SizedBox(
                          height: AppSizesDouble.s10,
                        ),
                        StreamBuilder<int>(
                          stream: context.read<VerificationCubit>().timerStream,
                          builder: (context, snapshot) {
                            return Text(context.read<VerificationCubit>().currentTime.toString());
                          }
                        ),
                        TextButton(
                          onPressed: context.read<VerificationCubit>().canResendCode?() => _sendVerificationCode():null,
                          style: TextButton.styleFrom(foregroundColor: ColorsManager.lightPrimary, disabledForegroundColor: ColorsManager.lightGrey),
                          child: Text(StringsManager.sendAgain),
                        ),
                      ],
                    ),
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
    await context.read<VerificationCubit>().sendVerificationCode(recipientEmail: widget.recipientEmail!);
  }
}
