import 'package:flutter/material.dart';
import 'package:lol/shared/components/components.dart';

class AnnouncementsList extends StatelessWidget {
  const AnnouncementsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          backgroundEffects(),
          Container(
            margin: const EdgeInsetsDirectional.only(top: 50),
            width: double.infinity,
            child: Column(
              children: [
                backButton(context),
                adminTopTitleWithDrawerButton(hasDrawer: true, title: 'Announcements', size: 34),
              ],
            ),
          )
        ],
      ),
    );
  }
}
