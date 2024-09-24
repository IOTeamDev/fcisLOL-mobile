import 'package:flutter/material.dart';
import 'package:lol/modules/auth/bloc/login_cubit.dart';
import 'package:lol/modules/year_choose/choosing_year.dart';
import 'package:lol/shared/components/navigation.dart';
import 'package:lol/shared/network/local/shared_prefrence.dart';
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
                    onBoardingItem(onBoardingItemsList[index]),
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
                          navigatReplace(context,  ChoosingYear(loginCubit:LoginCubit() ,));////
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

Widget onBoardingItem(OnBoardingModel model) {
  return Column(
    children: [
      const SizedBox(
        height: 50,
      ),
      Text(
        model.title!,
        style: const TextStyle(
          fontSize: 21.5,
          letterSpacing: 2.5,
          fontWeight: FontWeight.w700,
        ),
      ),
      Expanded(child: Image.asset(model.image!)),
      Center(
        child: Text(
          textAlign: TextAlign.center,
          model.body!,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
        ),
      ),
      const SizedBox(
        height: 100,
      ),
    ],
  );
}

class OnBoardingModel {
  String? title;
  String? body;
  String? image;
  OnBoardingModel(
      {required this.title, required this.body, required this.image});
}

List<OnBoardingModel> onBoardingItemsList = [
  OnBoardingModel(
      title: "All In One Place",
      body: "Videos 🎬, Notes 📝, Recordings 📹, Exams 🖊... and more ",
      image: "images/Checklist.png"),
  OnBoardingModel(
      title: "Study anytime anywhere",
      body:
          " Whether you’re on the bus or at home, your learning is always within reach.",
      image: "images/Subway-cuate.png"),
  OnBoardingModel(
      title: "A+ is Just a Tap Away !",
      body:
          "Why wait? Jump into your studies and watch your grades climb to the top.",
      image: "images/Grades-pana.png"),
];
