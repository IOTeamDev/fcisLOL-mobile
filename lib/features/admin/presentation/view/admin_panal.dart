import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:linkify/linkify.dart';
import 'package:lol/core/presentation/cubits/main_cubit/main_cubit.dart';
import 'package:lol/core/presentation/cubits/main_cubit/main_cubit_states.dart';
import 'package:lol/core/presentation/screen_size.dart';
import 'package:lol/core/resources/assets/fonts_manager.dart';
import 'package:lol/core/presentation/app_icons.dart';
import 'package:lol/core/resources/theme/values/app_strings.dart';
import 'package:lol/core/resources/theme/theme_provider.dart';
import 'package:lol/main.dart';
import 'package:lol/features/admin/presentation/view_model/admin_cubit/admin_cubit.dart';
import 'package:lol/features/admin/presentation/view_model/admin_cubit/admin_cubit_states.dart';
import 'package:lol/features/admin/presentation/view/announcements/add_announcement.dart';
import 'package:lol/features/admin/presentation/view/requests/requests.dart';

import 'package:lol/core/utils/components.dart';
import 'package:lol/core/utils/navigation.dart';
import 'package:provider/provider.dart';

import '../../../../core/resources/theme/colors_manager.dart';
import '../../../../core/resources/constants/constants_manager.dart';
import '../../../../core/resources/theme/values/values_manager.dart';
import 'announcements/announcements_list.dart';
import '../../../auth/presentation/view/login/login.dart';
import '../../../home/presentation/view/home.dart';
import '../../../profile/view/profile.dart';

class AdminPanel extends StatelessWidget {
  const AdminPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainCubitStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var mainCubit = MainCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              AppStrings.admin,
              style: Theme.of(context)
                  .textTheme
                  .displayMedium!
                  .copyWith(fontWeight: FontWeightManager.semiBold),
            ),
            centerTitle: true,
          ),
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Buttons
                ConditionalBuilder(
                  condition: MainCubit.get(context).profileModel != null &&
                      state is! GetProfileLoading,
                  fallback: (context) =>
                      const Center(child: CircularProgressIndicator()),
                  builder: (context) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buttonBuilder(
                          context,
                          mainCubit,
                          ColorsManager.white,
                          ColorsManager.lightGrey1,
                          ColorsManager.darkPrimary,
                          ColorsManager.lightGrey,
                          AppIcons.campaignIcon,
                          AppStrings.announcements,
                          AddAnnouncement(
                              semester: mainCubit.profileModel!.semester)),
                      SizedBox(
                        height: AppSizesDouble.s30,
                      ),
                      buttonBuilder(
                          context,
                          mainCubit,
                          ColorsManager.white,
                          ColorsManager.lightGrey1,
                          ColorsManager.lightPrimary,
                          ColorsManager.lightPrimary,
                          AppIcons.emailIcon,
                          AppStrings.requests,
                          Requests()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buttonBuilder(
      context,
      mainCubit,
      containerDarkThemeColor,
      containerLightThemeColor,
      buttonDarkThemeColor,
      buttonLightThemeColor,
      icon,
      title,
      navigationWidget) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        height: AppSizesDouble.s13,
        width: ScreenSize.width(context) - AppSizes.s70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppSizesDouble.s40),
              topRight: Radius.circular(AppSizesDouble.s40)),
          color: Provider.of<ThemeProvider>(context).isDark
              ? containerDarkThemeColor
              : containerLightThemeColor,
        ),
      ),
      ElevatedButton(
        onPressed: () {
          if (mainCubit.profileModel != null) {
            navigate(context, navigationWidget);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Provider.of<ThemeProvider>(context).isDark
              ? buttonDarkThemeColor
              : buttonLightThemeColor,
          padding: EdgeInsets.zero, // Remove default padding
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizesDouble.s20),
          ),
          minimumSize: Size(ScreenSize.width(context) - AppSizes.s40,
              ScreenSize.height(context) / AppSizesDouble.s4_5),
        ),
        child: Column(
          children: [
            Icon(icon,
                color: ColorsManager.white,
                size: ScreenSize.width(context) / AppSizes.s4),
            Text(title,
                style: TextStyle(
                    fontSize: ScreenSize.width(context) / AppSizes.s15,
                    color: ColorsManager.white)),
          ],
        ),
      ),
    ]);
  }
}
