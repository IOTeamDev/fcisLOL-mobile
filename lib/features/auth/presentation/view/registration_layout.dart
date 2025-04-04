import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lol/core/network/local/shared_preference.dart';
import 'package:lol/core/utils/components.dart';
import 'package:lol/core/utils/navigation.dart';
import 'package:lol/core/utils/resources/colors_manager.dart';
import 'package:lol/core/utils/resources/constants_manager.dart';
import 'package:lol/core/utils/resources/strings_manager.dart';
import 'package:lol/features/auth/presentation/view/login.dart';
import 'package:lol/features/auth/presentation/view/register.dart';
import 'package:lol/features/pick_image/presentation/view/select_image.dart';
import 'package:lol/features/auth/presentation/view/verify_email.dart';
import 'package:lol/features/auth/presentation/view_model/auth_cubit/auth_cubit.dart';
import 'package:lol/features/auth/presentation/view_model/login_cubit/login_cubit.dart';
import 'package:lol/features/home/presentation/view/home.dart';
import 'package:lol/features/otp_and_verification/presentation/view/otp_verification_screen.dart';

class RegistrationLayout extends StatefulWidget {
  RegistrationLayout({super.key});

  @override
  State<RegistrationLayout> createState() => _RegistrationLayoutState();
}

class _RegistrationLayoutState extends State<RegistrationLayout>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (context) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            showToastMessage(
              message: "Successfully signed in. Welcome back!",
              states: ToastStates.SUCCESS,
            );
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => Home(),
              ),
              (route) => false,
            );
          }
          if (state is LoginFailed) {
            showToastMessage(
                states: ToastStates.ERROR,
                message: "Invalid email or password. Please try again");
          }
          if (state is RegisterSuccess) {
            AppConstants.TOKEN = state.token;

            Cache.writeData(key: KeysManager.token, value: state.token);

            showToastMessage(
              message: 'You need to verify your email',
              states: ToastStates.SUCCESS,
            );
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => Home(),
              ),
              (route) => false,
            );
            // Navigator.of(context).pushAndRemoveUntil(
            //   MaterialPageRoute(
            //     builder: (context) => OtpVerificationScreen(
            //       selectedMethod: 'email',
            //       recepientEmail: state.userEmail,
            //     ),
            //   ),
            //   (route) => false,
            // );
          }
          if (state is RegisterFailed) {
            showToastMessage(
              message: state.errMessage,
              states: ToastStates.ERROR,
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Stack(
              children: [
                Scaffold(
                  backgroundColor: ColorsManager.white,
                  appBar: AppBar(
                    backgroundColor: ColorsManager.white,
                  ),
                  body: Column(
                    children: [
                      TabBar(
                          indicatorColor: ColorsManager.lightPrimary,
                          dividerColor: ColorsManager.grey1,
                          labelColor: ColorsManager.lightPrimary,
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicatorAnimation: TabIndicatorAnimation.elastic,
                          unselectedLabelColor: ColorsManager.grey1,
                          controller: _tabController,
                          tabs: [
                            Tab(
                              text: StringsManager.login,
                            ),
                            Tab(
                              text: StringsManager.signup,
                            )
                          ]),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            LoginScreen(),
                            Registerscreen(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (state is RegisterLoading || state is LoginLoading)
                  Container(
                      color: Colors.black
                          .withValues(alpha: 0.3), // Background overlay
                      child: const Center(
                        child: CircularProgressIndicator(),
                      )),
              ],
            ),
          );
        },
      ),
    );
  }
}
