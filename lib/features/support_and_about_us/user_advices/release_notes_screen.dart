import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lol/core/utils/components.dart';
import 'package:lol/core/utils/resources/colors_manager.dart';
import 'package:lol/core/utils/resources/constants_manager.dart';
import 'package:lol/core/utils/resources/strings_manager.dart';
import 'package:lol/features/support_and_about_us/user_advices/release_notes_widgets/model/release_notes_data.dart';
import 'package:lol/features/support_and_about_us/user_advices/release_notes_widgets/view/bug_fixes.dart';
import 'package:lol/features/support_and_about_us/user_advices/release_notes_widgets/view/new_features.dart';
import 'package:lol/features/support_and_about_us/user_advices/release_notes_widgets/view/patch_notes.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/resources/theme_provider.dart';
import '../../../core/utils/resources/values_manager.dart';

class ReleaseNotesScreen extends StatelessWidget {
  const ReleaseNotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringsManager.releaseNotes, style: Theme.of(context).textTheme.displayMedium,),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.all(AppMargins.m20),
        padding: EdgeInsets.all(AppPaddings.p25),
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizesDouble.s20),
          color: Theme.of(context).primaryColor,
          boxShadow: [
            BoxShadow(
              color: ColorsManager.black.withValues(alpha: AppSizesDouble.s0_3),
              blurRadius: AppSizesDouble.s10,
              spreadRadius: AppSizesDouble.s3,
              offset: Offset(AppSizesDouble.s5, AppSizesDouble.s5),
            )
          ]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppConstants.appVersion,
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                color: Provider.of<ThemeProvider>(context).isDark? ColorsManager.lightPrimary:ColorsManager.white
              ),
            ),
            divider(height: AppSizesDouble.s20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if(newFeatures.isNotEmpty)NewFeatures(),
                    if(patchNotes.isNotEmpty)PatchNotes(),
                    if(bugFixes.isNotEmpty)BugFixes(),
                  ],
                ),
              )
            ),
            //if(newFeatures.length>0)
          ],
        ),
      ),
    );
  }
}
