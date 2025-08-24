import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lol/config/navigation/routes.dart';
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
import 'package:lol/features/otp_and_verification/presentation/cubits/email_verification_cubit.dart/cubit/email_verification_cubit.dart';
import 'package:lol/features/otp_and_verification/presentation/cubits/ticker_cubit.dart/cubit/ticker_cubit.dart';
import 'package:lol/features/otp_and_verification/presentation/view/widgets/change_email_pop_up.dart';
import 'package:lol/features/pick_image/presentation/view/select_image.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../core/presentation/app_icons.dart';
import '../../../../core/resources/theme/values/app_strings.dart';
import '../../../../core/resources/theme/values/values_manager.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String recipientEmail;
  EmailVerificationScreen({super.key, required this.recipientEmail});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  @override
  void initState() {
    super.initState();
    _sendEmailVerification();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EmailVerificationCubit, EmailVerificationState>(
      listener: (context, state) {
        if (state is SendingEmailFailed) {
          showToastMessage(
              message: state.errMessage, states: ToastStates.ERROR);
        }
        if (state is EmailVerified) {
          showToastMessage(
              message: AppStrings.mailIsNowVerified,
              states: ToastStates.SUCCESS);
          if (context.read<MainCubit>().profileModel!.photo ==
              AppConstants.defaultProfileImage) {
            context.replaceNamed(ScreensName.selectImage);
          } else {
            context.goNamed(ScreensName.home);
          }
        }
        if (state is SendingEmailSuccess) {
          context.read<TickerCubit>().startTicker();
        }

        if (state is LogoutSuccess) {
          context.goNamed(ScreensName.registrationLayout);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () async {
                  await context.read<MainCubit>().logout();
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
                    image: DecorationImage(
                      image: AssetImage(AssetsManager.verification_screen_logo),
                    ),
                  ),
                ),
                const SizedBox(
                  height: AppSizesDouble.s15,
                ),
                FittedBox(
                    child: Text(
                  AppStrings.emailVerification,
                  style: Theme.of(context).textTheme.displayMedium,
                )),
                const SizedBox(
                  height: AppSizesDouble.s5,
                ),
                Padding(
                  padding: EdgeInsets.all(AppPaddings.p5),
                  child: Text(
                    'A verification email has been sent to "${widget.recipientEmail}". Please check your inbox and click on the link to verify your account.',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: AppSizesDouble.s30,
                    vertical: AppSizesDouble.s30),
                width: double.infinity,
                height: ScreenSize.height(context) / AppSizes.s2,
                decoration: BoxDecoration(
                    color: ColorsManager.darkPrimary,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(AppSizesDouble.s95))),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: AppSizesDouble.s50,
                      ),
                      Text(
                        AppStrings.noEmailReceived,
                        style: TextStyle(color: ColorsManager.lightGrey1),
                      ),
                      const SizedBox(
                        height: AppSizesDouble.s10,
                      ),
                      BlocBuilder<TickerCubit, TickerState>(
                        builder: (context, state) {
                          return Column(
                            children: [
                              Text(state is TickerInProgress
                                  ? state.duration.toString()
                                  : '0'),
                              TextButton(
                                onPressed: !(state is TickerInProgress)
                                    ? () => _sendEmailVerification()
                                    : null,
                                style: TextButton.styleFrom(
                                    foregroundColor: ColorsManager.lightPrimary,
                                    disabledForegroundColor:
                                        ColorsManager.lightGrey),
                                child: Text(AppStrings.sendAgain),
                              ),
                            ],
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendEmailVerification() async {
    await context.read<EmailVerificationCubit>().sendEmailVerification();
  }
}
