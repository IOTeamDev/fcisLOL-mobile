import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:linkify/linkify.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit_states.dart';
import 'package:lol/core/utils/resources/colors_manager.dart';
import 'package:lol/core/utils/resources/strings_manager.dart';
import 'package:lol/core/utils/resources/theme_provider.dart';
import 'package:lol/features/admin/presentation/view_model/admin_cubit/admin_cubit_states.dart';
import 'package:lol/core/utils/components.dart';
import 'package:provider/provider.dart';

import '../../../../../core/cubits/main_cubit/main_cubit.dart';
import '../../../../../core/utils/resources/constants_manager.dart';
import '../../../../../main.dart';

class RequestsDetails extends StatelessWidget {
  final int id;
  final String title;
  final String description;
  final String subjectName;
  final String link;
  final String pfp;
  final String type;
  final String authorName;
  final String semester;

  const RequestsDetails(
      {super.key,
      required this.authorName,
      required this.type,
      required this.description,
      required this.link,
      required this.subjectName,
      required this.id,
      required this.title,
      required this.pfp,
      required this.semester});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainCubitStates>(
      listener: (context, state) {
        if (state is DeleteMaterialSuccessState) {
          showToastMessage(
              message: 'Request Rejected!!!!', states: ToastStates.WARNING);
          Navigator.pop(context, 'refresh');
        }

        if (state is AcceptRequestSuccessState) {
          showToastMessage(
              message: 'Request Accepted Successfully!!!!',
              states: ToastStates.SUCCESS);
          Navigator.pop(context, 'refresh');
        }
      },
      builder: (context, state) {
        var cubit = MainCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Request Details',
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: AppQueries.screenHeight(context) / 1.4),
                child: Container(
                  margin: const EdgeInsetsDirectional.symmetric(
                      horizontal: 15, vertical: 20),
                  padding: const EdgeInsets.all(15),
                  width: double.infinity,
                  height: AppQueries.screenHeight(context) / 1.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Provider.of<ThemeProvider>(context).isDark
                        ? ColorsManager.darkPrimary
                        : ColorsManager.lightGrey,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(pfp.toString()),
                            radius: 23,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            authorName.toString(),
                            style: TextStyle(
                                fontSize: 18, color: Colors.grey[300]),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.symmetric(
                                    vertical: 5),
                                child: Linkify(
                                  onOpen: (link) => onOpen(context, link),
                                  text: description,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                  linkStyle: const TextStyle(
                                      color: Colors.blue, fontSize: 18),
                                  linkifiers: const [
                                    UrlLinkifier(),
                                    EmailLinkifier(),
                                    PhoneNumberLinkifier(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(
                                maxWidth:
                                    AppQueries.screenWidth(context) / 1.7),
                            child: Text(
                              subjectName,
                              style: TextStyle(
                                  fontSize: 13, color: Colors.grey[300]),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Spacer(),
                          Text(
                            type,
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey[300]),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.symmetric(vertical: 15),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return Row(
                              children: [
                                const Icon(Icons.link, color: Colors.white),
                                const SizedBox(width: 5),
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                      maxWidth: constraints.maxWidth - 30),
                                  child: GestureDetector(
                                    onTap: () async {
                                      final linkElement =
                                          LinkableElement(link, link);
                                      await onOpen(context, linkElement);
                                    },
                                    child: Text(
                                      link,
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                        decorationColor: Colors.blue,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      ConditionalBuilder(
                        condition: cubit.profileModel != null &&
                            cubit.requests != null &&
                            state is! GetRequestsLoadingState,
                        fallback: (context) => Center(
                          child: CircularProgressIndicator(),
                        ),
                        builder: (context) => Row(
                          children: [
                            //cancel button
                            ElevatedButton(
                              onPressed: () {
                                //print(cubit.requests![id].id);
                                cubit.deleteMaterial(
                                    cubit.requests![id].id!, semester);
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(13)),
                                padding: const EdgeInsetsDirectional.symmetric(
                                    horizontal: 40),
                                backgroundColor: Colors.white,
                                textStyle: TextStyle(
                                    fontSize:
                                        AppQueries.screenWidth(context) / 17),
                              ),
                              child: const Text(
                                StringsManager.reject,
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            const Spacer(),
                            //submit button
                            ElevatedButton(
                                onPressed: () {
                                  cubit.acceptRequest(
                                      cubit.requests![id].id!, semester);
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(13)),
                                  padding:
                                      const EdgeInsetsDirectional.symmetric(
                                          horizontal: 40),
                                  backgroundColor: ColorsManager.lightPrimary,
                                  foregroundColor: Colors.white,
                                  textStyle: TextStyle(
                                      fontSize:
                                          AppQueries.screenWidth(context) / 17),
                                ),
                                child: const Text(StringsManager.accept)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
