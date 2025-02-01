import 'package:flutter/material.dart';
import 'package:linkify/linkify.dart';
import 'package:lol/features/home/presentation/view_model/main_cubit/main_cubit.dart';
import 'package:lol/layout/profile/other_profile.dart';
import 'package:lol/main.dart';
import 'package:lol/features/subject/data/models/material_model.dart';
import 'package:lol/features/subject/presentation/screens/widgets/remove_button.dart';
import 'package:lol/shared/components/components.dart';
import 'package:lol/shared/components/constants.dart';
import 'package:lol/shared/components/navigation.dart';

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
                  borderRadius: BorderRadius.circular(15),
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
                  padding: const EdgeInsets.only(top: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${video.title}',
                        style: TextStyle(
                          fontSize: screenWidth(context) / 18,
                          color: Colors.white,
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
                                  fontSize: screenWidth(context) / 30,
                                  color: Colors.white,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          : GestureDetector(
                              onTap: () => navigate(
                                  context,
                                  OtherProfile(
                                    id: 117,
                                  )),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Shared by:  ',
                                    style: TextStyle(
                                      fontSize: screenWidth(context) / 30,
                                      color: Colors.white,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  CircleAvatar(
                                    radius: screenWidth(context) / 25,
                                    backgroundImage: NetworkImage(
                                        '${video.author!.authorPhoto}'),
                                  ),
                                  Text(
                                    '  ${video.author!.authorName}',
                                    style: TextStyle(
                                      fontSize: screenWidth(context) / 30,
                                      color: Colors.white,
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
            if (MainCubit.get(context).profileModel?.role == 'ADMIN' &&
                TOKEN != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                    alignment: Alignment.topRight,
                    child: RemoveButton(material: video)),
              ),
          ],
        ));
  }
}
