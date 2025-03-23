import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:linkify/linkify.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit.dart';
import 'package:lol/core/utils/resources/colors_manager.dart';
import 'package:lol/core/utils/resources/strings_manager.dart';
import 'package:lol/features/profile/view/other_profile.dart';
import 'package:lol/features/subject/presentation/cubit/get_material_cubit/get_material_cubit.dart';
import 'package:lol/features/subject/presentation/screens/widgets/edit_button.dart';
import 'package:lol/main.dart';
import 'package:lol/features/subject/data/models/material_model.dart';
import 'package:lol/features/subject/presentation/screens/widgets/remove_button.dart';
import 'package:lol/core/utils/components.dart';
import 'package:lol/core/utils/navigation.dart';

import '../../../../../core/utils/resources/constants_manager.dart';

class GridTileWidget extends StatelessWidget {
  const GridTileWidget({super.key, required this.video});

  final MaterialModel video;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () async {
          final linkableElement = LinkableElement(video.link, video.link!);
          await onOpen(context, linkableElement);
        },
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: FutureBuilder<String?>(
                        future: getYouTubeThumbnail(video.link!, apiKey),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                                child:
                                    CircularProgressIndicator()); // Show a loading indicator while waiting
                          } else if (snapshot.hasError) {
                            return Text(
                                'Error loading thumbnail'); // Display an error if one occurs
                          } else if (snapshot.data != null) {
                            return Image.network(
                              snapshot.data!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.network(
                                  'https://www.buffalotech.com/images/made/images/remote/https_i.ytimg.com/vi/06wIw-NdHIw/sddefault_300_225_s.jpg',
                                  fit: BoxFit.cover,
                                ); // Show default thumbnail if the URL is broken
                              },
                            ); // Display the thumbnail
                          } else {
                            return Image.network(
                              'https://www.buffalotech.com/images/made/images/remote/https_i.ytimg.com/vi/06wIw-NdHIw/sddefault_300_225_s.jpg',
                              fit: BoxFit.cover,
                            ); // Handle null cases
                          }
                        },
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${video.title}',
                        style: TextStyle(
                          fontSize: AppQueries.screenWidth(context) / 18,
                          color: ColorsManager.white,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      video.author!.authorPhoto == null
                          ? Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                'Shared by: ${video.author!.authorName}',
                                style: TextStyle(
                                  fontSize:
                                      AppQueries.screenWidth(context) / 30,
                                  color: ColorsManager.white,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          : InkWell(
                              splashColor: ColorsManager.transparent,
                              onTap: () => navigate(
                                  context,
                                  OtherProfile(
                                    id: video.author!.authorId,
                                  )),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Shared by:  ',
                                    style: TextStyle(
                                      fontSize:
                                          AppQueries.screenWidth(context) / 30,
                                      color: ColorsManager.white,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  CircleAvatar(
                                    radius:
                                        AppQueries.screenWidth(context) / 35,
                                    backgroundImage: NetworkImage(
                                        '${video.author!.authorPhoto}'),
                                  ),
                                  Text(
                                    '  ${video.author!.authorName}',
                                    style: TextStyle(
                                      fontSize:
                                          AppQueries.screenWidth(context) / 30,
                                      color: ColorsManager.white,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
            if ((MainCubit.get(context).profileModel?.role ==
                        KeysManager.admin ||
                    MainCubit.get(context).profileModel?.role ==
                        KeysManager.developer) &&
                AppConstants.TOKEN != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    EditButton(
                      material: video,
                      getMaterialCubit: GetMaterialCubit.get(context),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    RemoveButton(material: video),
                  ],
                ),
              ),
          ],
        ));
  }
}
