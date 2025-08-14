import 'package:flutter/material.dart';
import 'package:lol/core/presentation/screen_size.dart';
import 'package:lol/core/resources/assets/assets_manager.dart';
import 'package:lol/core/resources/theme/values/app_strings.dart';
import 'package:lol/core/resources/theme/values/values_manager.dart';
import '../utils/components.dart';
import '../resources/theme/colors_manager.dart';
import '../resources/constants/constants_manager.dart';

class ErrorScreen extends StatelessWidget {
  FlutterErrorDetails errorDetails;
  ErrorScreen({super.key, required this.errorDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.error,
          style: Theme.of(context).textTheme.displayMedium,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppPaddings.p50),
              child: Image(image: AssetImage(AssetsManager.errorSign)),
            ),
            Text(
              '${AppStrings.anErrorOccurred}',
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    fontSize: ScreenSize.width(context) / AppSizes.s17,
                    color: ColorsManager.imperialRed,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
