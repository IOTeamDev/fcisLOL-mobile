import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:lol/core/utils/resources/colors_manager.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:linkify/linkify.dart';
import 'package:lol/core/utils/resources/icons_manager.dart';
import 'package:lol/core/utils/resources/strings_manager.dart';
import 'package:lol/core/utils/resources/theme_provider.dart';
import 'package:lol/core/utils/resources/values_manager.dart';
import 'package:lol/features/admin/presentation/view/admin_panal.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit_states.dart';
import 'package:lol/features/auth/presentation/view_model/auth_cubit/auth_cubit.dart';
import 'package:lol/features/home/presentation/view/home.dart';
import 'package:lol/features/profile/view/profile.dart';
import 'package:lol/features/admin/presentation/view/announcements/announcements_list.dart';
import 'package:lol/features/auth/presentation/view/login.dart';
import 'package:lol/core/error/error_screen.dart';
import 'package:lol/core/utils/navigation.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lol/core/utils/resources/constants_manager.dart';
import 'webview_screen.dart';

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

Widget materialBuilder(index, context, {title, link, type, subjectName, description, isMain = true}) {
  var cubit = MainCubit.get(context);
  return Container(
    padding: EdgeInsets.all(AppSizesDouble.s15),
    decoration: BoxDecoration(
      color: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(AppSizesDouble.s20),
    ),
    height: AppSizesDouble.s170,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                maxLines: AppSizes.s1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(color: ColorsManager.white, fontWeight: FontWeight.bold),
              ),
            ),
            if (cubit.profileModel!.role == KeysManager.admin || cubit.profileModel!.role == KeysManager.developer)
              IconButton(
                onPressed: () {
                  AwesomeDialog(
                    context: context,
                    title: StringsManager.delete,
                    dialogType: DialogType.warning,
                    body: Text(
                      textAlign: TextAlign.center,
                      StringsManager.deleteMaterialMessage,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    animType: AnimType.scale,
                    btnOk: ElevatedButton(
                      onPressed: (){
                        cubit.deleteMaterial(
                          isMain?
                          cubit.profileModel!.materials[index].id!:
                          cubit.otherProfile!.materials[index].id!,
                          isMain?
                          cubit.profileModel!.semester:
                          cubit.otherProfile!.semester,
                          isMaterial: true,
                        );
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: ColorsManager.imperialRed),
                      child: Text(StringsManager.delete, style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: ColorsManager.white),),
                    ),
                    btnCancel: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(backgroundColor:  ColorsManager.grey4),
                        child: Text(StringsManager.cancel, style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: ColorsManager.black),)
                    ),
                  ).show();
                },
                icon: Icon(IconsManager.closeIcon, color: ColorsManager.imperialRed),
              ),
          ],
        ),
        Flexible(
          child: Text(
            textAlign: TextAlign.start,
            subjectName.toString()
              .replaceAll(StringsManager.underScore, StringsManager.space)
              .replaceAll(StringsManager.andWord.substring(AppSizes.s0).toUpperCase()+StringsManager.andWord.substring(AppSizes.s1).toUpperCase(), StringsManager.andSymbol),
            maxLines: AppSizes.s1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: AppQueries.screenWidth(context) / AppSizes.s22,
              color: ColorsManager.white
            ),
          ),
        ),
        // SizedBox(height: 5,),
        Text(
          type,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: ColorsManager.grey4),
          maxLines: AppSizes.s1,
          overflow: TextOverflow.ellipsis,
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              children: [
                Icon(IconsManager.linkIcon, color: ColorsManager.grey2),
                SizedBox(width: AppSizesDouble.s5),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final linkElement = LinkableElement(link, link);
                      await onOpen(context, linkElement);
                    },
                    child: Text(
                      link,
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
            (isMain?
            cubit.profileModel!.materials[index].accepted!:
            cubit.otherProfile!.materials[index].accepted! )?
            StringsManager.accepted :
            StringsManager.pending,
            style: TextStyle(
              color: (isMain? cubit.profileModel!.materials[index].accepted!: cubit.otherProfile!.materials[index].accepted!) ?
              ColorsManager.persianGreen :
              ColorsManager.gold
            ),
          ),
        ),
      ],
    ),
  );
}

Widget defaultLoginButton(
  context,
  GlobalKey<FormState> formKey,
  AuthCubit loginCubit,
  TextEditingController emailController,
  TextEditingController passwordController,
  String text,
  {bool isSignUp = false,
  Function()? onPressed}) =>
  ElevatedButton(
    style: ElevatedButton.styleFrom(
        foregroundColor: ColorsManager.white,
        fixedSize: Size(AppQueries.screenWidth(context), AppSizesDouble.s50),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizesDouble.s15)),
        backgroundColor: ColorsManager.lightPrimary),
    onPressed: isSignUp
        ? onPressed
        : () {
            if (formKey.currentState!.validate()) {
              loginCubit.login(
                  email: emailController.text.toLowerCase(),
                  password: passwordController.text);
            }
          },
    child: Text(
      text,
      style: Theme.of(context)
          .textTheme
          .headlineLarge!
          .copyWith(color: ColorsManager.white),
    ),
  );

Widget previousExamsBuilder(context, String title, String link, role){
  return InkWell(
    onTap: (){
      launchUrl(Uri.parse(link));
    },
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Provider.of<ThemeProvider>(context).isDark? ColorsManager.lightGrey:ColorsManager.grey3,
      ),
      width: double.infinity,
      height: 60,
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.bold
              ),
              maxLines: AppSizes.s1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if(role == KeysManager.admin || role == KeysManager.developer)
          IconButton(
            onPressed: (){},
            icon: Icon(IconsManager.editIcon, color: ColorsManager.black),
            style: IconButton.styleFrom(
              backgroundColor: ColorsManager.white,
              shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10))
            ),
          ),
          if(role == KeysManager.admin || role == KeysManager.developer)
          IconButton(
            onPressed: (){},
            icon: Icon(IconsManager.deleteIcon, color: ColorsManager.white,),
            style: IconButton.styleFrom(
                backgroundColor: ColorsManager.imperialRed,
                shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10))
            ),
          ),
        ],
      ),
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 10),
    ),
  );
}

Widget defaultLoginInputField(controller, label, keyboardType,
        {bool isPassword = false,
        loginCubit,
        suffixIcon,
        bool isConfirmPassword = false,
        validationMessage,
        onFieldSubmit,
        TextInputAction textInputAction = TextInputAction.done,
        String? Function(String?)? validator = null}) =>
    TextFormField(
      obscureText: isPassword ? loginCubit.hiddenPassword : false,
      controller: controller,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      style: TextStyle(color: ColorsManager.black),
      decoration: InputDecoration(
        labelStyle: TextStyle(color: ColorsManager.lightGrey),
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSizesDouble.s15)),
        filled: true,
        fillColor: ColorsManager.grey3,
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColorsManager.lightPrimary),
            borderRadius: BorderRadius.circular(AppSizesDouble.s15)),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(suffixIcon),
                color: loginCubit.hiddenPassword
                    ? ColorsManager.lightGrey
                    : ColorsManager.lightPrimary,
                onPressed: loginCubit.togglePassword,
              )
            : null,
      ),
      validator: validator ??
      (value) {
        if (value!.isEmpty) {
          return isConfirmPassword
              ? validationMessage
              : StringsManager.emptyFieldWarning;
        } else {
          return null; // Form is valid.
        }
      },
      onFieldSubmitted: isConfirmPassword ? onFieldSubmit : null,
    );

void showToastMessage({
  required String message,
  Color textColor = ColorsManager.white,
  required ToastStates states,
  double fontSize = AppSizesDouble.s16,
  gravity = ToastGravity.BOTTOM,
  int lengthForIOSAndWeb = AppSizes.s5,
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
