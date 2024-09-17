import 'package:flutter/material.dart';

screenHeight(context) => MediaQuery.of(context).size.height;
screenWidth(context) => MediaQuery.of(context).size.width;

String? token;

/* if the user doesn't have an account */
int? selectedLevel;

String getYouTubeThumbnail(String videoUrl) {
  final Uri uri = Uri.parse(videoUrl);
  String videoId = "";

  if (uri.host.contains('youtu.be')) {
    videoId = uri.pathSegments.first;
  } else if (uri.queryParameters.containsKey('v')) {
    videoId = uri.queryParameters['v']!;
  }

  return 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';  // Use the size you prefer
}