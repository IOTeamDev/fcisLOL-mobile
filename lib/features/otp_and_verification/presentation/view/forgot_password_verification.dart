import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/core/presentation/cubits/main_cubit/main_cubit.dart';
import 'package:lol/core/presentation/cubits/main_cubit/main_cubit_states.dart';
import 'package:lol/core/presentation/screen_size.dart';
import 'package:lol/core/utils/components.dart';
import 'package:lol/core/utils/navigation.dart';
import 'package:lol/core/resources/assets/assets_manager.dart';
import 'package:lol/core/resources/theme/colors_manager.dart';
import 'package:lol/core/resources/constants/constants_manager.dart';
import 'package:lol/features/auth/presentation/view/registration_layout.dart';
import 'package:lol/features/auth/presentation/cubits/auth_cubit/auth_cubit.dart';
import 'package:lol/features/home/presentation/view/home.dart';
import 'package:lol/features/otp_and_verification/presentation/view/widgets/change_email_pop_up.dart';
import 'package:lol/features/otp_and_verification/presentation/cubits/verification_cubit/verification_cubit.dart';
import 'package:lol/features/pick_image/presentation/view/select_image.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../core/presentation/app_icons.dart';
import '../../../../core/resources/theme/values/app_strings.dart';
import '../../../../core/resources/theme/values/values_manager.dart';

class ForgotPasswordVerification extends StatefulWidget {
  final String? recipientEmail;
  ForgotPasswordVerification({super.key, required this.recipientEmail});

  @override
  State<ForgotPasswordVerification> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<ForgotPasswordVerification> {
  late TextEditingController _otpController;
  late String _recipientEmail;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    _recipientEmail = widget.recipientEmail!;
    _otpController = TextEditingController();
    context.read<VerificationCubit>().initializeStream();
    _sendVerificationCode();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VerificationCubit, VerificationState>(
      listener: (context, state) {
        if (state is VerificationUpdatePasswordSuccessState) {
          showToastMessage(
              message: AppStrings.passwordUpdatedMessage,
              states: ToastStates.SUCCESS);
        }
        if (state is EmailVerifiedFailed) {
          showToastMessage(
              message: state.errMessage, states: ToastStates.ERROR);
        }
        if (state is SendVerificationCodeToEmailFailed) {
          showToastMessage(
              message: state.errMessage, states: ToastStates.ERROR);
        }
      },
      builder: (context, state) {
        return BlocListener<MainCubit, MainState>(
          listener: (context, state) {
            if (state is VerificationUpdatePasswordSuccessState) {
              Navigator.pop(context);
            }
          },
          child: Scaffold(
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
                          image: DecorationImage(
                              image: AssetImage(
                                  AssetsManager.verification_screen_logo))),
                    ),
                    SizedBox(
                      height: AppSizesDouble.s15,
                    ),
                    FittedBox(
                        child: Text(
                      AppStrings.emailVerification,
                      style: Theme.of(context).textTheme.displayMedium,
                    )),
                    SizedBox(
                      height: AppSizesDouble.s5,
                    ),
                    FittedBox(
                        child:
                            Text('Enter The Otp Sent to "$_recipientEmail"')),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.center,
                      children: [
                        Text(
                          AppStrings.wrongEmail,
                          style: TextStyle(color: ColorsManager.lightGrey1),
                        ),
                        TextButton(
                          child: Text(
                            AppStrings.changeEmail,
                            style: TextStyle(color: ColorsManager.dodgerBlue),
                          ),
                          onPressed: () async {
                            String? email = await showDialog(
                                context: context,
                                builder: (context) => ChangeEmailPopUp(
                                    currentEmail: _recipientEmail));

                            if (email != null) {
                              _recipientEmail = email;
                              _passwordController.clear();
                              _confirmPassword.clear();
                              context
                                  .read<VerificationCubit>()
                                  .sendVerificationCode(
                                      recipientEmail: _recipientEmail);
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
                        vertical: ScreenSize.height(context) / AppSizes.s10),
                    width: double.infinity,
                    height: ScreenSize.height(context) / AppSizes.s2,
                    decoration: BoxDecoration(
                        color: ColorsManager.darkPrimary,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(AppSizesDouble.s95))),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          if (!VerificationCubit.get(context)
                              .isPasswordCodeVerified)
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
                                  borderRadius:
                                      BorderRadius.circular(AppSizesDouble.s10),
                                  activeColor: ColorsManager.lightPrimary,
                                  activeFillColor: ColorsManager.lightGrey1,
                                  fieldHeight: AppSizesDouble.s50,
                                  borderWidth: AppSizesDouble.s10,
                                  inactiveFillColor: ColorsManager.white,
                                  selectedColor: ColorsManager.lightPrimary,
                                  shape: PinCodeFieldShape.underline),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              onCompleted: (value) {
                                if (value.isNotEmpty) {
                                  VerificationCubit.get(context).verifyEmail(
                                      recipientEmail: _recipientEmail,
                                      otp: _otpController.text);
                                }
                              },
                            ),
                          const SizedBox(
                            height: AppSizesDouble.s15,
                          ),
                          if (VerificationCubit.get(context)
                              .isPasswordCodeVerified)
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText:
                                        VerificationCubit.get(context).obscured,
                                    keyboardType: TextInputType.visiblePassword,
                                    style:
                                        TextStyle(color: ColorsManager.black),
                                    decoration: InputDecoration(
                                      hintStyle: TextStyle(
                                          color: ColorsManager.lightGrey),
                                      hintText: AppStrings.newPassword,
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              AppSizesDouble.s15)),
                                      filled: true,
                                      fillColor: ColorsManager.grey3,
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color:
                                                  ColorsManager.lightPrimary),
                                          borderRadius: BorderRadius.circular(
                                              AppSizesDouble.s15)),
                                      suffixIcon: IconButton(
                                        icon: Icon(AppIcons.eyeIcon),
                                        color: VerificationCubit.get(context)
                                                .obscured
                                            ? ColorsManager.lightGrey
                                            : ColorsManager.lightPrimary,
                                        onPressed:
                                            VerificationCubit.get(context)
                                                .changeEyeState,
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return AppStrings.emptyFieldWarning;
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                  const SizedBox(
                                    height: AppSizesDouble.s15,
                                  ),
                                  TextFormField(
                                    controller: _confirmPassword,
                                    obscureText:
                                        VerificationCubit.get(context).obscured,
                                    keyboardType: TextInputType.visiblePassword,
                                    style:
                                        TextStyle(color: ColorsManager.black),
                                    decoration: InputDecoration(
                                      hintStyle: TextStyle(
                                          color: ColorsManager.lightGrey),
                                      hintText: AppStrings.confirmPassword,
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              AppSizesDouble.s15)),
                                      filled: true,
                                      fillColor: ColorsManager.grey3,
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color:
                                                  ColorsManager.lightPrimary),
                                          borderRadius: BorderRadius.circular(
                                              AppSizesDouble.s15)),
                                    ),
                                    validator: (value) {
                                      if (value != _passwordController.text) {
                                        return AppStrings
                                            .passwordNotMatchingError;
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                  const SizedBox(
                                    height: AppSizesDouble.s25,
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        foregroundColor: ColorsManager.white,
                                        fixedSize: Size(
                                            ScreenSize.width(context),
                                            AppSizesDouble.s50),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                AppSizesDouble.s15)),
                                        backgroundColor:
                                            ColorsManager.lightPrimary),
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        VerificationCubit.get(context)
                                            .updateForgottenPassword(
                                          _recipientEmail,
                                          _otpController.text,
                                          _passwordController.text,
                                        );
                                      }
                                    },
                                    child: Text(
                                      AppStrings.changePassword,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge!
                                          .copyWith(color: ColorsManager.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (!VerificationCubit.get(context)
                              .isPasswordCodeVerified)
                            Column(
                              children: [
                                const SizedBox(
                                  height: AppSizesDouble.s50,
                                ),
                                Text(
                                  AppStrings.noEmailReceived,
                                  style: TextStyle(
                                      color: ColorsManager.lightGrey1),
                                ),
                                const SizedBox(
                                  height: AppSizesDouble.s10,
                                ),
                                StreamBuilder<int>(
                                    stream: context
                                        .read<VerificationCubit>()
                                        .timerStream,
                                    builder: (context, snapshot) {
                                      return Text(context
                                          .read<VerificationCubit>()
                                          .currentTime
                                          .toString());
                                    }),
                                TextButton(
                                  onPressed: context
                                          .read<VerificationCubit>()
                                          .canResendCode
                                      ? () => _sendVerificationCode()
                                      : null,
                                  style: TextButton.styleFrom(
                                      foregroundColor:
                                          ColorsManager.lightPrimary,
                                      disabledForegroundColor:
                                          ColorsManager.lightGrey),
                                  child: Text(AppStrings.sendAgain),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _sendVerificationCode() {
    context
        .read<VerificationCubit>()
        .sendVerificationCode(recipientEmail: _recipientEmail);
  }
}
