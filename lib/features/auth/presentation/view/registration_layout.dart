import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lol/config/navigation/routes.dart';
import 'package:lol/core/network/local/shared_preference.dart';
import 'package:lol/core/presentation/widgets/default_loading_indicator.dart';
import 'package:lol/core/utils/components.dart';
import 'package:lol/core/utils/navigation.dart';
import 'package:lol/core/resources/theme/colors_manager.dart';
import 'package:lol/core/resources/constants/constants_manager.dart';
import 'package:lol/core/resources/theme/values/app_strings.dart';
import 'package:lol/features/auth/presentation/view/login/login.dart';
import 'package:lol/features/auth/presentation/view/register/register.dart';
import 'package:lol/features/home/presentation/view/loading_screen.dart';
import 'package:lol/features/otp_and_verification/presentation/view_model/verification_cubit/verification_cubit.dart';
import 'package:lol/features/pick_image/presentation/view/select_image.dart';
import 'package:lol/features/auth/presentation/cubits/auth_cubit/auth_cubit.dart';
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
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          context.goNamed(ScreensName.loading);
        }
        if (state is LoginFailed) {
          showToastMessage(
            states: ToastStates.ERROR,
            message: state.errMessage,
          );
        }
        if (state is RegisterSuccess) {
          AppConstants.TOKEN = state.token;
          Cache.writeData(key: KeysManager.token, value: state.token);
          showToastMessage(
            message: state.message,
            states: ToastStates.SUCCESS,
          );
          context.goNamed(ScreensName.loading);
        }
        if (state is RegisterFailed) {
          showToastMessage(
            message: state.errMessage,
            states: ToastStates.ERROR,
          );
        }
      },
      child: SafeArea(
        child: Stack(
          children: [
            Scaffold(
              appBar: AppBar(),
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
                          text: AppStrings.login,
                        ),
                        Tab(
                          text: AppStrings.signup,
                        )
                      ]),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        LoginScreen(),
                        RegisterScreen(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                if (state is RegisterLoading || state is LoginLoading) {
                  return DefaultLoadingIndicator();
                }
                return const SizedBox.shrink();
              },
            )
          ],
        ),
      ),
    );
  }
}
