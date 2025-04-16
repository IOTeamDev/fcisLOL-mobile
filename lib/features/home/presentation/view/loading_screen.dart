import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit_states.dart';
import 'package:lol/core/utils/resources/constants_manager.dart';
import 'package:lol/features/home/presentation/view/home.dart';
import 'package:lol/features/otp_and_verification/presentation/view/otp_verification_screen.dart';
import 'package:lol/features/otp_and_verification/presentation/view_model/verification_cubit/verification_cubit.dart';

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
          if (context.read<MainCubit>().profileModel!.isVerified == false &&
              context.read<MainCubit>().profileModel!.role == 'STUDENT') {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => VerificationCubit(),
                  child: OtpVerificationScreen(
                    selectedMethod: 'email',
                    recepientEmail:
                        context.read<MainCubit>().profileModel!.email,
                  ),
                ),
              ),
              (route) => false,
            );
          } else {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => Home(),
              ),
              (route) => false,
            );
          }
        }
        if (state is GetProfileFailure) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => Home(),
            ),
            (route) => false,
          );
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
