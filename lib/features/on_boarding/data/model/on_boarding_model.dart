import 'package:lol/core/utils/resources/assets_manager.dart';
import 'package:lol/core/utils/resources/strings_manager.dart';

class OnBoardingModel {
  String? title;
  String? image;
  OnBoardingModel({required this.title, required this.image});
}

List<OnBoardingModel> onBoardingItemsList = [
  OnBoardingModel(
    title: StringsManager.onBoardingTitle1,
    image: AssetsManager.onBoarding1
  ),
  OnBoardingModel(
    title: StringsManager.onBoardingTitle2,
    image: AssetsManager.onBoarding2
  ),
  OnBoardingModel(
    title: StringsManager.onBoardingTitle3,
    image: AssetsManager.onBoarding3
  ),
];
