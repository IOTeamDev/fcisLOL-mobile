import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:lol/core/utils/resources/colors_manager.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:linkify/linkify.dart';
import 'package:lol/features/admin/presentation/view/admin_panal.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit_states.dart';
import 'package:lol/features/home/presentation/view/home.dart';
import 'package:lol/features/profile/view/profile.dart';
import 'package:lol/features/admin/presentation/view/announcements/announcements_list.dart';
import 'package:lol/features/auth/presentation/view/login.dart';
import 'package:lol/core/error/error_screen.dart';
import 'package:lol/core/utils/navigation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lol/core/utils/resources/constants_manager.dart';
import 'webview_screen.dart';

Widget adminTopTitleWithDrawerButton(
    {scaffoldKey,
    required String title,
    double size = 40,
    required bool hasDrawer,
    double bottomPadding = 15}) {
  return Padding(
    padding: EdgeInsetsDirectional.only(bottom: bottomPadding),
    child: Row(
      children: [
        Expanded(
          flex: 15,
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 20.0),
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white, fontSize: size),
              textAlign: TextAlign.start,
            ),
          ),
        ),
        const Spacer(),
        if (hasDrawer)
          ElevatedButton(
            onPressed: () {
              scaffoldKey.currentState?.openDrawer();
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: 5, vertical: 5),
              backgroundColor: Colors.pinkAccent,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50), // Create semi-circle effect
                  topRight: Radius.circular(0), // Create semi-circle effect
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(0),
                ),
              ),
            ),
            child: const Icon(
              Icons.menu,
              color: Colors.white,
              size: 40,
            ),
          ),
      ],
    ),
  );
}

RefreshIndicator swipeRefreshIndicator(
    {dynamic child, required Future<void> Function() onRefresh, Color indicatorColor = ColorsManager.white})
{
  return RefreshIndicator(child: child, onRefresh: onRefresh, color: indicatorColor,);
}

Widget backButton(context, {double bottomPadding = 8}) {
  return Padding(
    padding: EdgeInsets.only(bottom: bottomPadding),
    child: Row(
      children: [
        MaterialButton(
          onPressed: () {
            Navigator.pop(context);
          },
          padding: EdgeInsets.zero,
          child: const Icon(
            Icons.arrow_back,
            size: 30,
          ),
        ),
      ],
    ),
  );
}

Widget divider() {
  return Container(
    height: 1,
    width: double.infinity,
    color: Colors.grey,
  );
}

void showToastMessage({
  required String message,
  Color textColor = Colors.white,
  required ToastStates states,
  double fontSize = 16,
  gravity = ToastGravity.BOTTOM,
  int lengthForIOSAndWeb = 5,
  toastLength = Toast.LENGTH_SHORT,
}) =>
    Fluttertoast.showToast(
      msg: message,
      toastLength: toastLength,
      gravity: gravity,
      timeInSecForIosWeb: lengthForIOSAndWeb,
      backgroundColor: chooseToastColor(states),
      textColor: textColor,
      fontSize: fontSize,
    );

enum ToastStates { SUCCESS, ERROR, WARNING, INFO }

Color chooseToastColor(ToastStates states) {
  Color? color;
  switch (states) {
    case ToastStates.SUCCESS:
      color = Colors.green[600];
      break;
    case ToastStates.WARNING:
      color = Colors.amber[600];
      break;
    case ToastStates.ERROR:
      color = Colors.red[600];
      break;
    case ToastStates.INFO:
      color = Colors.grey[600];
      break;
  }
  return color!;
}

Future<String?> getYouTubeThumbnail(String videoUrl, apiKey) async {
  final Uri uri = Uri.parse(videoUrl);
  String? videoId;

  if (uri.host.contains('youtu.be')) {
    // Shortened URL (e.g., https://youtu.be/VIDEO_ID)
    videoId = uri.pathSegments.first;
  } else if (uri.queryParameters.containsKey('v')) {
    // Standard YouTube video URL (e.g., https://www.youtube.com/watch?v=VIDEO_ID)
    videoId = uri.queryParameters['v'];
  } else if (uri.queryParameters.containsKey('list')) {
    // Playlist URL
    final playlistUrl = videoUrl; // Use the playlist URL directly
    try {
      // Call getFirstVideoThumbnail function to get the thumbnail of the first video in the playlist
      final thumbnailUrl = await getFirstVideoThumbnail(playlistUrl, apiKey);
      return thumbnailUrl;
    } catch (e) {
      print('Error fetching playlist thumbnail: $e');
      return null;
    }
  } else {
    return null; // Not a valid YouTube video or playlist URL
  }

  // Return the thumbnail for the individual video
  return videoId != null
      ? 'https://img.youtube.com/vi/$videoId/hqdefault.jpg'
      : null;
}

Future<String> getFirstVideoThumbnail(String playlistUrl, String apiKey) async {
  // Extract playlist ID from the URL
  final playlistId = playlistUrl.split("list=")[1];

  // Build the API request URL
  final url =
      'https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=1&playlistId=$playlistId&key=$apiKey';

  // Send the HTTP request
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    // Parse the response body
    final data = jsonDecode(response.body);
    final firstVideo = data['items'][0]['snippet'];
    final thumbnailUrl = firstVideo['thumbnails']['high']['url'];

    return thumbnailUrl; // Return the URL of the first video's thumbnail
  } else {
    throw Exception('Failed to load playlist');
  }
}

Future<void> onOpen(BuildContext context, LinkableElement link) async {
  final url = link.url;

  // Open Facebook links directly using `url_launcher`
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    navigate(context, WebviewScreen(url));
  }
}
