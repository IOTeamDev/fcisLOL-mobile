import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:linkify/linkify.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit_states.dart';
import 'package:lol/core/utils/resources/fonts_manager.dart';
import 'package:lol/core/utils/resources/icons_manager.dart';
import 'package:lol/core/utils/resources/strings_manager.dart';
import 'package:lol/core/utils/resources/theme_provider.dart';
import 'package:lol/main.dart';
import 'package:lol/features/admin/presentation/view_model/admin_cubit/admin_cubit.dart';
import 'package:lol/features/admin/presentation/view_model/admin_cubit/admin_cubit_states.dart';
import 'package:lol/features/admin/presentation/view/announcements/add_announcement.dart';
import 'package:lol/features/admin/presentation/view/requests/requests.dart';

import 'package:lol/core/utils/components.dart';
import 'package:lol/core/utils/navigation.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/resources/colors_manager.dart';
import '../../../../core/utils/resources/constants_manager.dart';
import '../../../../core/utils/resources/values_manager.dart';
import 'announcements/announcements_list.dart';
import '../../../auth/presentation/view/login.dart';
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
              StringsManager.admin,
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
                          IconsManager.campaignIcon,
                          StringsManager.announcements,
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
                        IconsManager.emailIcon,
                        StringsManager.requests,
                        Requests()
                      ),
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
      Container(
        height: AppSizesDouble.s13,
        width: AppQueries.screenWidth(context) - AppSizes.s70,
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
          minimumSize: Size(AppQueries.screenWidth(context) - AppSizes.s40,
              AppQueries.screenHeight(context) / AppSizesDouble.s4_5),
        ),
        child: Column(
          children: [
            Icon(icon,
                color: ColorsManager.white,
                size: AppQueries.screenWidth(context) / AppSizes.s4),
            Text(title,
                style: TextStyle(
                    fontSize: AppQueries.screenWidth(context) / AppSizes.s15,
                    color: ColorsManager.white)),
          ],
        ),
      ),
    ]);
  }
}
