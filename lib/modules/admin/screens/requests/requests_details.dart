import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:linkify/linkify.dart';
import 'package:lol/features/home/presentation/view_model/main_cubit/main_cubit_states.dart';
import 'package:lol/modules/admin/bloc/admin_cubit.dart';
import 'package:lol/modules/admin/bloc/admin_cubit_states.dart';
import 'package:lol/features/subject/presentation/cubit/subject_cubit.dart';
import 'package:lol/shared/components/components.dart';
import 'package:lol/shared/components/constants.dart';

import '../../../../features/home/presentation/view_model/main_cubit/main_cubit.dart';
import '../../../../main.dart';

class RequestsDetails extends StatelessWidget {
  int id;
  String title;
  String description;
  String subjectName;
  String link;
  String pfp;
  String type;
  String authorName;
  String semester;

  RequestsDetails(
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
    double width = screenWidth(context);
    double height = screenHeight(context);
    return BlocProvider(
      create: (context) => MainCubit()
        ..getProfileInfo()
        ..getRequests(semester: semester),
      child: BlocConsumer<MainCubit, MainCubitStates>(
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
            //backgroundColor: HexColor('#23252A'),
            body: Container(
                margin:
                    EdgeInsetsDirectional.only(top: screenHeight(context) / 10),
                width: double.infinity,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Positioned(
                          left: 0,
                          child: backButton(context),
                        ),
                        Center(
                            child: Text(
                          'Request Details',
                          style: TextStyle(
                            fontSize: width / 12,
                          ),
                          textAlign: TextAlign.center,
                        )),
                      ],
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: height / 1.4),
                      child: Container(
                        margin: const EdgeInsetsDirectional.symmetric(
                            horizontal: 15, vertical: 20),
                        padding: const EdgeInsets.all(15),
                        width: double.infinity,
                        height: screenHeight(context) / 1.4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: isDark
                              ? HexColor('#3B3B3B')
                              : HexColor('#757575'),
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
                                      padding:
                                          const EdgeInsetsDirectional.symmetric(
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
                                      maxWidth: screenWidth(context) / 1.7),
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
                              padding:
                                  EdgeInsetsDirectional.symmetric(vertical: 15),
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  return Row(
                                    children: [
                                      const Icon(Icons.link,
                                          color: Colors.white),
                                      const SizedBox(width: 5),
                                      ConstrainedBox(
                                        constraints: BoxConstraints(
                                            maxWidth:
                                                constraints.maxWidth - 30),
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
                                              decoration:
                                                  TextDecoration.underline,
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
                                          borderRadius:
                                              BorderRadius.circular(13)),
                                      padding:
                                          const EdgeInsetsDirectional.symmetric(
                                              horizontal: 40),
                                      backgroundColor: Colors.white,
                                      textStyle:
                                          TextStyle(fontSize: width / 17),
                                    ),
                                    child: const Text(
                                      'Reject',
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
                                            borderRadius:
                                                BorderRadius.circular(13)),
                                        padding: const EdgeInsetsDirectional
                                            .symmetric(horizontal: 40),
                                        backgroundColor:
                                            Color.fromARGB(255, 20, 130, 220),
                                        foregroundColor: Colors.white,
                                        textStyle:
                                            TextStyle(fontSize: width / 17),
                                      ),
                                      child: const Text('Accept')),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
          );
        },
      ),
    );
  }
}
