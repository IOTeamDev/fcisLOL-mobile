import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lol/core/data/local_data_provider.dart';
import 'package:lol/core/presentation/screen_size.dart';
import 'package:lol/core/resources/theme/colors_manager.dart';
import 'package:lol/core/resources/theme/values/app_strings.dart';
import 'package:lol/core/resources/theme/theme_provider.dart';
import 'package:lol/core/resources/theme/values/values_manager.dart';
import 'package:lol/main.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/utils/components.dart';
import '../../core/resources/constants/constants_manager.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.aboutUs,
          style: Theme.of(context).textTheme.displayMedium,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppPaddings.p15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // About Us Section
              Text(
                AppStrings.whoAreWe,
                style: Theme.of(context).textTheme.displayMedium,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppPaddings.p20),
                child: divider(color: Colors.grey),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: AppPaddings.p15, vertical: AppPaddings.p20),
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(AppSizesDouble.s15)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(AppStrings.uniNotes,
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge!
                                  .copyWith(
                                      fontSize: ScreenSize.width(context) /
                                          AppSizes.s11,
                                      fontWeight: FontWeight.w500,
                                      color: ColorsManager.white)),
                        ),
                        Text(AppStrings.allInOne,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .copyWith(
                                    fontSize: ScreenSize.width(context) /
                                        AppSizes.s17,
                                    color: ColorsManager.grey2)),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: AppPaddings.p10,
                      ),
                      child: RichText(
                        text: TextSpan(
                          text: AppStrings.uniNotes,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(
                                  fontSize:
                                      ScreenSize.width(context) / AppSizes.s22,
                                  fontWeight: FontWeight.w500,
                                  color: ColorsManager.white),
                          children: <TextSpan>[
                            TextSpan(
                                text: AppStrings.aboutUsBrief,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                        fontSize: ScreenSize.width(context) /
                                            AppSizes.s27,
                                        fontWeight: FontWeight.normal,
                                        color: ColorsManager.white)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Meet the Team Section
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppPaddings.p20),
                child: divider(color: Colors.grey),
              ),
              Text(
                AppStrings.meetTheTeam,
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    fontSize: ScreenSize.width(context) / AppSizes.s13),
              ),
              SizedBox(
                height: AppSizesDouble.s10,
              ),
              ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: LocalDataProvider.teamMembers.length,
                itemBuilder: (context, index) {
                  return _buildTeamMember(
                      context,
                      LocalDataProvider.teamMembers[index]
                          [KeysManager.imagePath]!,
                      LocalDataProvider.teamMembers[index][KeysManager.name]!,
                      LocalDataProvider.teamMembers[index][KeysManager.role]!,
                      LocalDataProvider.teamMembers[index]
                          [KeysManager.contactUrl]!);
                },
                separatorBuilder: (context, index) => SizedBox(
                  height: AppSizesDouble.s15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamMember(context, String imagePath, String name, String role,
      String contactEmail) {
    return IntrinsicHeight(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          boxShadow: [
            BoxShadow(
                color:
                    ColorsManager.black.withValues(alpha: AppSizesDouble.s0_3),
                offset: Offset(0, 5),
                blurRadius: 5)
          ],
          borderRadius: BorderRadius.circular(AppSizesDouble.s15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: AppSizesDouble.s30,
              backgroundImage: NetworkImage(imagePath),
            ),
            SizedBox(width: AppSizesDouble.s10),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstrainedBox(
                  constraints:
                      BoxConstraints(maxWidth: ScreenSize.width(context) / 2.5),
                  child: Text(
                    name,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: ColorsManager.white,
                        ),
                    textAlign: TextAlign.start,
                    maxLines: AppSizes.s2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(role,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: ColorsManager.grey2)),
              ],
            ),
            Spacer(),
            TextButton(
              style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                      horizontal: ScreenSize.width(context) / AppSizes.s20),
                  backgroundColor: Provider.of<ThemeProvider>(context).isDark
                      ? ColorsManager.lightPrimary
                      : ColorsManager.white),
              onPressed: () => _contactTeamMember(contactEmail),
              child: Text(
                AppStrings.contact,
                style: TextStyle(
                    color: Theme.of(context).textTheme.titleSmall!.color),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _contactTeamMember(String email) async {
    launchUrl(Uri.parse(email));
  }
}
