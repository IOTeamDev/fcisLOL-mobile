import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:linkify/linkify.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit.dart';
import 'package:lol/features/profile/view/other_profile.dart';
import 'package:lol/main.dart';
import 'package:lol/features/subject/data/models/material_model.dart';
import 'package:lol/features/subject/presentation/screens/widgets/remove_button.dart';
import 'package:lol/core/utils/components.dart';
import 'package:lol/core/utils/navigation.dart';
import '../../../../../core/utils/resources/constants_manager.dart';

class DocumentsCard extends StatelessWidget {
  const DocumentsCard({super.key, required this.document});
  final MaterialModel document;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final linkElement = LinkableElement(document.link, document.link!);
        await onOpen(context, linkElement);
      },
      child: Card(
          color: MainCubit.get(context).isDark
              ? const Color.fromRGBO(59, 59, 59, 1)
              : HexColor('#4764C5'),
          child: Container(
            padding:
                const EdgeInsets.only(left: 8, right: 8, top: 20, bottom: 8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.only(end: 10.0),
                      child: Icon(
                        Icons.folder_copy_sharp,
                        size: AppQueries.screenWidth(context) / 10,
                        color: Colors.white,
                      ),
                    ),
                    Expanded(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            maxWidth: AppQueries.screenWidth(context) - 180),
                        child: Text(
                          '${document.title}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: AppQueries.screenWidth(context) / 20,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                    if (MainCubit.get(context).profileModel?.role == 'ADMIN' &&
                        AppConstants.TOKEN != null)
                      RemoveButton(material: document),
                  ],
                ),
                document.author!.authorPhoto == null
                    ? Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          'Shared by: ${document.author!.authorName}',
                          style: TextStyle(
                            fontSize: AppQueries.screenWidth(context) / 30,
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
                                fontSize: AppQueries.screenWidth(context) / 30,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            CircleAvatar(
                              radius: AppQueries.screenWidth(context) / 25,
                              backgroundImage: NetworkImage(
                                  '${document.author!.authorPhoto}'),
                            ),
                            Text(
                              '  ${document.author!.authorName}',
                              style: TextStyle(
                                fontSize: AppQueries.screenWidth(context) / 30,
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
          )),
    );
  }
}
