import 'package:flutter/material.dart';

class TabForCustomTabBar extends StatelessWidget {
  const TabForCustomTabBar({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Center(
        child: Text(
          title,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
