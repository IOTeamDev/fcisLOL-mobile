import 'package:lol/core/resources/assets/assets_manager.dart';
import 'package:lol/core/resources/theme/values/app_strings.dart';

class OnBoardingModel {
  String? title;
  String? image;
  OnBoardingModel({required this.title, required this.image});
}

List<OnBoardingModel> onBoardingItemsList = [
  OnBoardingModel(
      title: AppStrings.onBoardingTitle1, image: AssetsManager.onBoarding1),
  OnBoardingModel(
      title: AppStrings.onBoardingTitle2, image: AssetsManager.onBoarding2),
  OnBoardingModel(
      title: AppStrings.onBoardingTitle3, image: AssetsManager.onBoarding3),
];
