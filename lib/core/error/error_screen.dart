import 'package:flutter/material.dart';
import 'package:lol/core/utils/resources/strings_manager.dart';
import 'package:lol/core/utils/resources/values_manager.dart';
import '../utils/components.dart';
import '../utils/resources/colors_manager.dart';
import '../utils/resources/constants_manager.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringsManager.error),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Center(
                    child: Text(
                      StringsManager.notFoundErrorCode,
                      style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        fontSize: AppQueries.screenWidth(context) / AppSizes.s4,
                        color: ColorsManager.imperialRed,
                      ),
                    ),
                  ),
                  Text(
                    StringsManager.thisLinkIsCorrupted,
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontSize: AppQueries.screenWidth(context) / AppSizes.s17
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
