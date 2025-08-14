import 'package:flutter/material.dart';
import 'package:linkify/linkify.dart';
import 'package:lol/core/presentation/cubits/main_cubit/main_cubit.dart';
import 'package:lol/core/presentation/screen_size.dart';
import 'package:lol/core/resources/theme/colors_manager.dart';
import 'package:lol/core/resources/theme/theme_provider.dart';
import 'package:lol/features/profile/view/other_profile.dart';
import 'package:lol/features/subject/presentation/view_model/get_material_cubit/get_material_cubit.dart';
import 'package:lol/features/subject/presentation/screens/widgets/edit_button.dart';
import 'package:lol/main.dart';
import 'package:lol/features/subject/data/models/material_model.dart';
import 'package:lol/features/subject/presentation/screens/widgets/remove_button.dart';
import 'package:lol/core/utils/components.dart';
import 'package:lol/core/utils/navigation.dart';
import 'package:provider/provider.dart';
import '../../../../../core/resources/constants/constants_manager.dart';

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
          color: Theme.of(context).primaryColor,
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.only(end: 10.0),
                      child: Icon(
                        Icons.folder_copy_sharp,
                        size: ScreenSize.width(context) / 17,
                        color: ColorsManager.white,
                      ),
                    ),
                    Expanded(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            maxWidth: ScreenSize.width(context) - 180),
                        child: Text(
                          document.title!,
                          style: TextStyle(
                            color: ColorsManager.white,
                            fontSize: ScreenSize.width(context) / 20,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                    if ((MainCubit.get(context).profileModel?.role == 'ADMIN' ||
                            MainCubit.get(context).profileModel?.role ==
                                'DEV') &&
                        AppConstants.TOKEN != null)
                      EditButton(
                          material: document,
                          getMaterialCubit: GetMaterialCubit.get(context)),
                    if ((MainCubit.get(context).profileModel?.role == 'ADMIN' ||
                            MainCubit.get(context).profileModel?.role ==
                                'DEV') &&
                        AppConstants.TOKEN != null)
                      const SizedBox(
                        width: 10,
                      ),
                    if ((MainCubit.get(context).profileModel?.role == 'ADMIN' ||
                            MainCubit.get(context).profileModel?.role ==
                                'DEV') &&
                        AppConstants.TOKEN != null)
                      RemoveButton(material: document),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                document.author!.authorPhoto == null
                    ? Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          'Shared by: ${document.author!.authorName}',
                          style: TextStyle(
                            fontSize: ScreenSize.width(context) / 30,
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
                              id: document.author!.authorId,
                            )),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Shared by:  ',
                              style: TextStyle(
                                fontSize: ScreenSize.width(context) / 30,
                                color: ColorsManager.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            CircleAvatar(
                              radius: ScreenSize.width(context) / 35,
                              backgroundImage: NetworkImage(
                                  '${document.author!.authorPhoto}'),
                            ),
                            Text(
                              '  ${document.author!.authorName}',
                              style: TextStyle(
                                fontSize: ScreenSize.width(context) / 30,
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
          )),
    );
  }
}
