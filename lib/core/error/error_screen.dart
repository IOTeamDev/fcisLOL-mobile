import 'package:flutter/material.dart';
import 'package:lol/core/utils/resources/assets_manager.dart';
import 'package:lol/core/utils/resources/strings_manager.dart';
import 'package:lol/core/utils/resources/values_manager.dart';
import '../utils/components.dart';
import '../utils/resources/colors_manager.dart';
import '../utils/resources/constants_manager.dart';

class ErrorScreen extends StatelessWidget {
  FlutterErrorDetails errorDetails;
  ErrorScreen({super.key, required this.errorDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringsManager.error, style: Theme.of(context).textTheme.displayMedium,),
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
              '${StringsManager.anErrorOccurred}',
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                fontSize: AppQueries.screenWidth(context) / AppSizes.s17,
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
