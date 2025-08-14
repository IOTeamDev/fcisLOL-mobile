import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lol/core/utils/components.dart';
import 'package:lol/core/resources/theme/colors_manager.dart';
import 'package:lol/core/resources/constants/constants_manager.dart';
import 'package:lol/core/resources/theme/values/app_strings.dart';
import 'package:lol/features/support_and_about_us/user_advices/release_notes_widgets/model/release_notes_data.dart';
import 'package:lol/features/support_and_about_us/user_advices/release_notes_widgets/view/release_notes_generator.dart';
import 'package:provider/provider.dart';
import '../../../../../core/resources/theme/theme_provider.dart';
import '../../../../../core/resources/theme/values/values_manager.dart';

class ReleaseNotesScreen extends StatelessWidget {
  const ReleaseNotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.releaseNotes,
          style: Theme.of(context).textTheme.displayMedium,
        ),
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
                color:
                    ColorsManager.black.withValues(alpha: AppSizesDouble.s0_3),
                blurRadius: AppSizesDouble.s10,
                spreadRadius: AppSizesDouble.s3,
                offset: Offset(AppSizesDouble.s5, AppSizesDouble.s5),
              )
            ]),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Text(
                AppConstants.appVersion,
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    color: Provider.of<ThemeProvider>(context).isDark
                        ? ColorsManager.lightPrimary
                        : ColorsManager.white),
              ),
            ),
            SliverToBoxAdapter(child: divider(height: AppSizesDouble.s20)),
            if (newFeatures.isNotEmpty)
              SliverPadding(
                padding: EdgeInsets.symmetric(vertical: 10),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    AppStrings.newFeatures,
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: ColorsManager.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            if (newFeatures.isNotEmpty)
              ReleaseNotesGenerator(notes: newFeatures),
            if (patchNotes.isNotEmpty)
              SliverPadding(
                padding: EdgeInsets.symmetric(vertical: 10),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    AppStrings.patchNotes,
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: ColorsManager.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            if (patchNotes.isNotEmpty) ReleaseNotesGenerator(notes: patchNotes),
            if (bugFixes.isNotEmpty)
              SliverPadding(
                padding: EdgeInsets.symmetric(vertical: 10),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    AppStrings.bugFixes,
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: ColorsManager.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            if (bugFixes.isNotEmpty) ReleaseNotesGenerator(notes: bugFixes),
          ],
        ),
      ),
    );
  }
}
