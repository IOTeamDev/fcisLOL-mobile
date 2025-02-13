import 'package:flutter/material.dart';
import 'package:lol/features/auth/presentation/view_model/login_cubit/login_cubit.dart';
import 'package:lol/features/auth/presentation/view/choosing_year.dart';
import 'package:lol/core/utils/navigation.dart';
import 'package:lol/core/network/local/shared_preference.dart';
import 'package:lol/features/on_boarding/data/model/on_boarding_model.dart';
import 'package:lol/features/on_boarding/presentation/view/widgets/on_boarding_item.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

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
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                onPageChanged: (value) {
                  if (value == onBoardingItemsList.length - 1) {
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
                controller: pageViewController,
                itemBuilder: (context, index) =>
                    OnBoardingItem(model: onBoardingItemsList[index]),
                itemCount: onBoardingItemsList.length,
              ),
            ),
            Row(
              children: [
                SmoothPageIndicator(
                    effect: const JumpingDotEffect(
                        activeDotColor: Colors.blue,
                        dotHeight: 12,
                        dotWidth: 17,
                        spacing: 8,
                        jumpScale: 2),
                    controller: pageViewController,
                    count: onBoardingItemsList.length),
                const Spacer(),
                Container(
                    height: 50,
                    width: 140,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(30)),
                    child: MaterialButton(
                      child: Text(
                        isLastPage ? "Get Started" : "Next",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      onPressed: () {
                        if (isLastPage) {
                          Cache.writeData(key: "FinishedOnBoard", value: true);
                          navigatReplace(
                              context,
                              ChoosingYear(
                                loginCubit: LoginCubit(),
                              )); ////
                        } else {
                          pageViewController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease,
                          );
                        }
                      },
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
