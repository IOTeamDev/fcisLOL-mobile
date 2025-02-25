import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lol/core/utils/resources/colors_manager.dart';
import 'package:lol/core/utils/resources/strings_manager.dart';
import 'package:lol/core/utils/resources/theme_provider.dart';
import 'package:lol/core/utils/resources/values_manager.dart';
import 'package:lol/main.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/utils/components.dart';
import '../../core/utils/resources/constants_manager.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(StringsManager.aboutUs, style: Theme.of(context).textTheme.displayMedium,),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppPaddings.p15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // About Us Section
              Text(
                StringsManager.whoAreWe,
                style: Theme.of(context).textTheme.displayMedium,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppPaddings.p20),
                child: divider(color: Colors.grey),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: AppPaddings.p10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      StringsManager.uniNotes,
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(fontSize: AppQueries.screenWidth(context) / AppSizes.s9, fontWeight: FontWeight.bold)
                    ),
                    Text(
                      StringsManager.allInOne,
                      style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontSize:  AppQueries.screenWidth(context) / AppSizes.s15, color: Provider.of<ThemeProvider>(context).isDark? ColorsManager.lightGrey1: ColorsManager.lightGrey)
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppPaddings.p10,
                        vertical: AppPaddings.p10,
                      ),
                      child: RichText(
                        text: TextSpan(
                          text: StringsManager.uniNotes,
                          style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontSize: AppQueries.screenWidth(context) / AppSizes.s18),
                          children: <TextSpan>[
                            TextSpan(
                              text: StringsManager.aboutUsBrief,
                              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                letterSpacing: AppSizesDouble.s1_2,
                                fontSize: AppQueries.screenWidth(context) / AppSizes.s20,
                                fontWeight: FontWeight.normal,
                              )
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSizesDouble.s25),
              // Meet the Team Section
              Text(
                StringsManager.meetTheTeam,
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontSize: AppQueries.screenWidth(context) / AppSizes.s13),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppPaddings.p20),
                child: divider(color: Colors.grey),
              ),
              SizedBox(
                height: AppQueries.screenHeight(context),
                child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: AppSizes.s2,
                    crossAxisSpacing: AppSizesDouble.s10,
                    mainAxisSpacing: AppSizesDouble.s10,
                    childAspectRatio: AppSizesDouble.s0_8,
                  ),
                  itemCount: AppConstants.teamMembers.length,
                  itemBuilder: (context, index) {
                    return _buildTeamMember(
                      context,
                      AppConstants.teamMembers[index][KeysManager.imagePath]!,
                      AppConstants.teamMembers[index][KeysManager.name]!,
                      AppConstants.teamMembers[index][KeysManager.role]!,
                      AppConstants.teamMembers[index][KeysManager.contactUrl]!
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamMember(context, String imagePath, String name, String role, String contactEmail) {
    return InkWell(
      onTap: () =>  _contactTeamMember(contactEmail),
      child: Card(
        color: Theme.of(context).primaryColor,
        elevation: AppSizesDouble.s4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizesDouble.s15)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: AppSizesDouble.s40,
              backgroundImage: NetworkImage(imagePath),
            ),
            SizedBox(height: AppSizesDouble.s5),
            Text(
              name,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(color: ColorsManager.white),
              textAlign: TextAlign.center,
              maxLines: AppSizes.s2,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              role,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: ColorsManager.grey2)
            ),
            SizedBox(height: AppSizesDouble.s10),
            Text(
              StringsManager.contact,
              style: TextStyle(color: Provider.of<ThemeProvider>(context).isDark? ColorsManager.dodgerBlue:ColorsManager.lightGrey2),
            ),
          ],
        ),
      ),
    );
  }

  void _contactTeamMember(String email) async {
    launchUrl(Uri.parse(email));
  }

}
