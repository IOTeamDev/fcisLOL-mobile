import 'dart:convert';
import 'dart:developer';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:lol/core/models/profile/profile_model.dart';
import 'package:lol/core/presentation/screen_size.dart';
import 'package:lol/core/resources/theme/colors_manager.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:linkify/linkify.dart';
import 'package:lol/core/presentation/app_icons.dart';
import 'package:lol/core/resources/theme/values/app_strings.dart';
import 'package:lol/core/resources/theme/theme_provider.dart';
import 'package:lol/core/resources/theme/values/values_manager.dart';
import 'package:lol/features/admin/presentation/view/admin_panal.dart';
import 'package:lol/core/presentation/cubits/main_cubit/main_cubit.dart';
import 'package:lol/core/presentation/cubits/main_cubit/main_cubit_states.dart';
import 'package:lol/features/auth/presentation/cubits/auth_cubit/auth_cubit.dart';
import 'package:lol/features/home/presentation/view/home.dart';
import 'package:lol/features/home/presentation/view/widgets/edit_exam_popup.dart';
import 'package:lol/features/previous_exams/data/previous_exams_model.dart';
import 'package:lol/features/profile/view/profile.dart';
import 'package:lol/features/admin/presentation/view/announcements/announcements_list.dart';
import 'package:lol/features/auth/presentation/view/login/login.dart';
import 'package:lol/core/error/error_screen.dart';
import 'package:lol/core/utils/navigation.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lol/core/resources/constants/constants_manager.dart';
import 'webview_screen.dart';

String getImageNameFromUrl({required String imageUrl}) {
  final path = Uri.parse(imageUrl).path;
  final encodedFileName = path.split('/').last;
  return Uri.decodeComponent(encodedFileName).split('/').last;
}

onRefresh(Function<T>() refreshMethod) => refreshMethod;

bool isArabicLanguage(BuildContext context) {
  return Localizations.localeOf(context).languageCode == 'ar';
}

Widget divider({
  Color color = ColorsManager.white,
  double height = AppSizesDouble.s1,
  double thickness = AppSizesDouble.s1,
}) =>
    Divider(
      color: color,
      height: height,
      thickness: thickness,
    );

class materialBuilder extends StatelessWidget {
  int index;
  BuildContext context;
  ProfileModel? profileModel;
  bool isMain;
  materialBuilder(this.index, this.context,
      {super.key, required this.profileModel, this.isMain = true});

  @override
  Widget build(BuildContext context) {
    var cubit = MainCubit.get(context);
    return Container(
      padding: EdgeInsets.all(AppSizesDouble.s15),
      decoration: BoxDecoration(
        //color: ColorsManager.darkPrimary,
        color: Provider.of<ThemeProvider>(context).isDark
            ? ColorsManager.darkPrimary
            : ColorsManager.white,
        borderRadius: BorderRadius.circular(AppSizesDouble.s20),
      ),
      height: AppSizesDouble.s170,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  profileModel!.name,
                  maxLines: AppSizes.s1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              if (cubit.profileModel != null)
                if (cubit.profileModel!.role == KeysManager.admin ||
                    cubit.profileModel!.role == KeysManager.developer)
                  IconButton(
                    onPressed: () {
                      AwesomeDialog(
                        context: context,
                        title: AppStrings.delete,
                        dialogType: DialogType.warning,
                        body: Text(
                          textAlign: TextAlign.center,
                          AppStrings.deleteMaterialMessage,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        animType: AnimType.scale,
                        btnOk: ElevatedButton(
                          onPressed: () {
                            cubit.deleteMaterial(
                              isMain
                                  ? cubit.profileModel!.materials[index].id!
                                  : cubit.otherProfile!.materials[index].id!,
                              isMain
                                  ? cubit.profileModel!.semester
                                  : cubit.otherProfile!.semester,
                              isMaterial: true,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: ColorsManager.imperialRed),
                          child: Text(
                            AppStrings.delete,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: ColorsManager.white),
                          ),
                        ),
                        btnCancel: ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: ColorsManager.grey4),
                            child: Text(
                              AppStrings.cancel,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: ColorsManager.black),
                            )),
                      ).show();
                    },
                    icon: Icon(AppIcons.closeIcon,
                        color: ColorsManager.imperialRed),
                  ),
            ],
          ),
          Flexible(
            child: Text(
              textAlign: TextAlign.start,
              profileModel!.materials[index].title
                  .toString()
                  .replaceAll(AppStrings.underScore, AppStrings.space),
              maxLines: AppSizes.s1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: ScreenSize.width(context) / AppSizes.s22,
                  color: ColorsManager.grey6),
            ),
          ),
          // SizedBox(height: 5,),
          Text(
            profileModel!.materials[index].type!,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: ColorsManager.grey6),
            maxLines: AppSizes.s1,
            overflow: TextOverflow.ellipsis,
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                children: [
                  Icon(AppIcons.linkIcon, color: ColorsManager.grey6),
                  SizedBox(width: AppSizesDouble.s5),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final linkElement = LinkableElement(
                            profileModel!.materials[index].link,
                            profileModel!.materials[index].link!);
                        await onOpen(context, linkElement);
                      },
                      child: Text(
                        profileModel!.materials[index].link!,
                        style: TextStyle(
                          color: Colors.lightBlueAccent,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.lightBlueAccent,
                        ),
                        maxLines: AppSizes.s1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              (isMain
                      ? cubit.profileModel!.materials[index].accepted!
                      : cubit.otherProfile!.materials[index].accepted!)
                  ? AppStrings.accepted
                  : AppStrings.pending,
              style: TextStyle(
                  color: (isMain
                          ? cubit.profileModel!.materials[index].accepted!
                          : cubit.otherProfile!.materials[index].accepted!)
                      ? ColorsManager.persianGreen
                      : ColorsManager.gold),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomExpansionTile extends StatelessWidget {
  CustomExpansionTile(
      {super.key,
      required this.title,
      this.icon,
      required this.children,
      this.childrenPadding,
      this.isImage = false,
      this.imageIcon});
  bool isImage;
  String? imageIcon;
  double? childrenPadding;
  late List<Widget> children;
  IconData? icon;
  late String title;
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: !isImage
          ? Icon(
              icon,
              color: Theme.of(context).iconTheme.color,
            )
          : Image.asset(
              imageIcon!,
              width: AppSizesDouble.s25,
              height: AppSizesDouble.s25,
              color: Theme.of(context).iconTheme.color,
            ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      childrenPadding:
          EdgeInsets.symmetric(horizontal: childrenPadding ?? AppPaddings.p0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero), // Removes divider when expanded
      collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero), // Removes divider when collapsed
      expansionAnimationStyle: AnimationStyle(
          duration: Duration(milliseconds: AppSizes.s600),
          reverseDuration: Duration(milliseconds: AppSizes.s400),
          curve: Curves.fastEaseInToSlowEaseOut,
          reverseCurve: Curves.fastOutSlowIn),
      children: children,
      iconColor: ColorsManager.white,
    );
  }
}

class CustomTile extends StatelessWidget {
  CustomTile({super.key, required this.onTap, required this.title, this.icon});

  IconData? icon;
  late String title;
  late VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).iconTheme.color,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero), // Removes divider when expanded
      onTap: onTap,
    );
  }
}

Widget previousExamsBuilder(context, PreviousExamModel exam, role, semester) {
  return InkWell(
    onTap: () {
      launchUrl(Uri.parse(exam.link));
    },
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Provider.of<ThemeProvider>(context).isDark
            ? ColorsManager.lightGrey
            : ColorsManager.grey3,
      ),
      width: double.infinity,
      height: 60,
      child: Row(
        children: [
          Expanded(
            child: Text(
              exam.title,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontWeight: FontWeight.bold),
              maxLines: AppSizes.s1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (AppConstants.TOKEN != null &&
              (role == KeysManager.admin || role == KeysManager.developer))
            IconButton(
              onPressed: () => showDialog(
                  barrierColor: ColorsManager.black.withValues(alpha: 0.4),
                  context: context,
                  builder: (context) =>
                      EditExamPopup(exam: exam, semester: semester),
                  barrierDismissible: true),
              icon: Icon(AppIcons.editIcon, color: ColorsManager.black),
              style: IconButton.styleFrom(
                  backgroundColor: ColorsManager.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
          if (AppConstants.TOKEN != null &&
              (role == KeysManager.admin || role == KeysManager.developer))
            IconButton(
              onPressed: () {
                MainCubit.get(context)
                    .deletePreviousExam(exam.id, exam.subject);
              },
              icon: Icon(
                AppIcons.deleteIcon,
                color: ColorsManager.white,
              ),
              style: IconButton.styleFrom(
                  backgroundColor: ColorsManager.imperialRed,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
        ],
      ),
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 10),
    ),
  );
}

void showToastMessage({
  required String message,
  required ToastStates states,
  Color? textColor,
  double fontSize = AppSizesDouble.s16,
  gravity = ToastGravity.BOTTOM,
  int lengthForIOSAndWeb = AppSizes.s5,
  toastLength = Toast.LENGTH_SHORT,
}) {
  textColor =
      states != ToastStates.INFO ? ColorsManager.black : ColorsManager.white;
  Fluttertoast.showToast(
    msg: message,
    toastLength: toastLength,
    gravity: gravity,
    timeInSecForIosWeb: lengthForIOSAndWeb,
    backgroundColor: chooseToastColor(states),
    textColor: textColor,
    fontSize: fontSize,
  );
}

// ignore: constant_identifier_names
enum ToastStates { SUCCESS, ERROR, WARNING, INFO }

Color chooseToastColor(ToastStates states) {
  Color color = ColorsManager.grey;
  switch (states) {
    case ToastStates.SUCCESS:
      color = ColorsManager.persianGreen;
      break;
    case ToastStates.WARNING:
      color = ColorsManager.gold;
      break;
    case ToastStates.ERROR:
      color = ColorsManager.imperialRed;
      break;
    case ToastStates.INFO:
      color = ColorsManager.grey;
      break;
  }
  return color;
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

  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    navigate(context, WebviewScreen(url));
  }
}
