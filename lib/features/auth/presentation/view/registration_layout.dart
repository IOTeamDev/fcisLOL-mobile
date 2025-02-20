import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/core/utils/resources/colors_manager.dart';
import 'package:lol/core/utils/resources/constants_manager.dart';
import 'package:lol/features/auth/presentation/view/login.dart';
import 'package:lol/features/auth/presentation/view/register.dart';
import 'package:lol/features/auth/presentation/view_model/auth_cubit/auth_cubit.dart';
import 'package:lol/features/auth/presentation/view_model/login_cubit/login_cubit.dart';

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
      child: SafeArea(
        child: Scaffold(
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
                      text: 'Login',
                    ),
                    Tab(
                      text: 'Register',
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
      ),
    );
  }
}
  // listener: (context, state) {
  //         // if (state is RegisterSuccess) {
  //         //   // token=state.token;
  //         //   TOKEN=state.token;
  //         //   Cache.writeData(key: "token", value: state.token);
  //         //   print(state.token);
  //         //   snack(
  //         //       context: context,
  //         //       enumColor: Messages.success,
  //         //       titleWidget: const Text("Successfully signed up !"));

  //         //   navigatReplace(context, const Home());
  //         // }
  //         // if (state is RegisterFailed) {
  //         //   snack(
  //         //       context: context,
  //         //       enumColor: Messages.error,
  //         //       titleWidget:
  //         //           const Text("Please try with another email address"));
  //         // }
  //       },

    //  listener: (context, state) {
    //       if (state is LoginSuccess) {
    //         showToastMessage(
    //           message: "Successfully signed in. Welcome back!",
    //           states: ToastStates.SUCCESS,
    //         );

    //         navigatReplace(context, Home());
    //       }
    //       if (state is LoginFailed) {
    //         showToastMessage(
    //           states: ToastStates.ERROR,
    //           message: "Invalid email or password. Please try again"
    //         );
    //       }
    //     },

    // listener: (context, state) {
    //     if (state is RegisterSuccess) {
    //       AppConstants.TOKEN = state.token;
    //       Cache.writeData(key: "token", value: state.token);
    //       showToastMessage(
    //         message: "Successfully signed up!",
    //         states: ToastStates.SUCCESS,
    //       );
    
    //       navigatReplace(context, const Home());
    //     }
    //     if (state is RegisterFailed) {
    //       showToastMessage(
    //         message: "Please try with another email address",
    //         states: ToastStates.ERROR,
    //       );
    //       navigatReplace(context, const LoginScreen());
    //     }
    //   },