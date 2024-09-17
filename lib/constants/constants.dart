import 'package:flutter/material.dart';

screenHeight(context) => MediaQuery.of(context).size.height;
screenWidth(context) => MediaQuery.of(context).size.width;

String TOKEN = 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOjExLCJpYXQiOjE3MjY1ODgxMzYsImV4cCI6MTc1NzY5MjEzNn0.GkJ9XNQsTm_nlN9KB2yDk_iaJBL4RBPCARKEXQlHJg0';

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