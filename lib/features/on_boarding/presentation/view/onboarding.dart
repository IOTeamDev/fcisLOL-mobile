import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lol/config/navigation/routes.dart';
import 'package:lol/core/utils/service_locator.dart';
import 'package:lol/core/resources/theme/colors_manager.dart';
import 'package:lol/core/presentation/app_icons.dart';
import 'package:lol/core/resources/theme/values/app_strings.dart';
import 'package:lol/features/auth/presentation/cubits/auth_cubit/auth_cubit.dart';
import 'package:lol/features/auth/presentation/view/choosing_year/choosing_year.dart';
import 'package:lol/core/utils/navigation.dart';
import 'package:lol/core/network/local/shared_preference.dart';
import 'package:lol/features/on_boarding/data/model/on_boarding_model.dart';
import 'package:lol/features/on_boarding/presentation/view/widgets/on_boarding_item.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/resources/theme/values/values_manager.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  var pageViewController = PageController();
  bool isLastPage = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: PageView.builder(
              controller: pageViewController,
              itemBuilder: (context, index) =>
                  OnBoardingItem(model: onBoardingItemsList[index]),
              itemCount: onBoardingItemsList.length,
              onPageChanged: (value) {
                if (value == onBoardingItemsList.length - AppSizes.s1) {
                  isLastPage = true;
                  setState(() {
                    print(isLastPage);
                  });
                } else {
                  isLastPage = false;
                  setState(() {
                    print(isLastPage);
                  });
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppPaddings.p50),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isLastPage
                        ? ColorsManager.grey8
                        : ColorsManager.lightPrimary,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppSizesDouble.s15)),
                    foregroundColor: ColorsManager.white,
                    padding: EdgeInsets.symmetric(
                        horizontal: AppPaddings.p50, vertical: AppPaddings.p15),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isLastPage ? AppStrings.getStarted : AppStrings.next,
                        style: const TextStyle(
                            fontSize: AppSizesDouble.s16,
                            fontWeight: FontWeight.w600),
                      ),
                      if (!isLastPage)
                        SizedBox(
                          width: AppSizesDouble.s10,
                        ),
                      if (!isLastPage)
                        Icon(
                          AppIcons.leftArrowIcon,
                          color: ColorsManager.white,
                        )
                    ],
                  ),
                  onPressed: () {
                    if (isLastPage) {
                      Cache.writeData(
                          key: KeysManager.finishedOnBoard, value: true);
                      context.replaceNamed(ScreensName.choosingYear);
                    } else {
                      pageViewController.nextPage(
                        duration: Duration(milliseconds: AppSizes.s500),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                ),
                SizedBox(
                  height: AppSizesDouble.s40,
                ),
                SmoothPageIndicator(
                  effect: const WormEffect(
                    activeDotColor: ColorsManager.lightPrimary,
                    dotHeight: AppSizesDouble.s10,
                    dotWidth: AppSizesDouble.s20,
                    spacing: AppSizesDouble.s8,
                    dotColor: ColorsManager.grey7,
                  ),
                  controller: pageViewController,
                  count: onBoardingItemsList.length,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
