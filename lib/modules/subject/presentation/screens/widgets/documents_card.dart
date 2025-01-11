import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:linkify/linkify.dart';
import 'package:lol/layout/home/bloc/main_cubit.dart';
import 'package:lol/layout/profile/other_profile.dart';
import 'package:lol/main.dart';
import 'package:lol/models/subjects/subject_model.dart';
import 'package:lol/modules/subject/presentation/screens/widgets/remove_button.dart';
import 'package:lol/shared/components/components.dart';
import 'package:lol/shared/components/constants.dart';
import 'package:lol/shared/components/navigation.dart';

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
          color: isDark
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
                        size: screenWidth(context) / 10,
                        color: Colors.white,
                      ),
                    ),
                    Expanded(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            maxWidth: screenWidth(context) - 180),
                        child: Text(
                          '${document.title}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth(context) / 20,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                    if (MainCubit.get(context).profileModel?.role == 'ADMIN' &&
                        TOKEN != null)
                      RemoveButton(material: document),
                  ],
                ),
                document.author!.authorPhoto == null
                    ? Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          'Shared by: ${document.author!.authorName}',
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
                                  '${document.author!.authorPhoto}'),
                            ),
                            Text(
                              '  ${document.author!.authorName}',
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
          )),
    );
  }
}
