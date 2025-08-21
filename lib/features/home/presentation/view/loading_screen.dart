import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lol/config/navigation/routes.dart';
import 'package:lol/core/presentation/cubits/main_cubit/main_cubit.dart';
import 'package:lol/core/presentation/cubits/main_cubit/main_cubit_states.dart';
import 'package:lol/core/resources/constants/constants_manager.dart';
import 'package:lol/features/home/presentation/view/home.dart';
import 'package:lol/features/otp_and_verification/presentation/view/email_verification_screen.dart';
import 'package:lol/features/otp_and_verification/presentation/cubits/verification_cubit/verification_cubit.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    _getprofileInfo();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MainCubit, MainCubitStates>(
      listener: (context, state) {
        if (state is GetProfileSuccess) {
          context.goNamed(ScreensName.home);
          // if (context.read<MainCubit>().profileModel!.isVerified == false &&
          //     context.read<MainCubit>().profileModel!.role == 'STUDENT') {
          //   context.goNamed(ScreensName.emailVerification);
          // } else {
          //   context.goNamed(ScreensName.home);
          // }
        }
        if (state is GetProfileFailure) {
          context.goNamed(ScreensName.home);
        }
      },
      child: Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Future<void> _getprofileInfo() async {
    await context.read<MainCubit>().getProfileInfo();
  }
}
