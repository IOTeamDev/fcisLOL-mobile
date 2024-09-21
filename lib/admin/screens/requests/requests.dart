import 'dart:math';
import 'dart:ui';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:linkify/linkify.dart';
import 'package:lol/admin/bloc/admin_cubit.dart';
import 'package:lol/admin/bloc/admin_cubit_states.dart';
import 'package:lol/admin/screens/requests/requests_details.dart';
import 'package:lol/shared/components/components.dart';
import 'package:lol/utilities/navigation.dart';
import '../../../constants/constants.dart';

class Requests extends StatelessWidget {
  // String title;
  // String description;
  // String link;
  // String type;

  var scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> backgroundColor = [
    '94ffff',
    'ff94ad',
    'bc94ff',
    'add271',
    '5d5fff',
    'e17fd1',
    'b6bffe',
    '7d29fb',
    'ff5938',
    '00664e',
  ];

  Requests({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCubit, AdminCubitStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AdminCubit.get(context);
        return Scaffold(
          key: scaffoldKey,
          drawer: drawerBuilder(context),
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              backgroundEffects(),
              Container(
                margin: const EdgeInsetsDirectional.only(top: 50),
                width: double.infinity,
                child: Column(
                  children: [
                    //backButton
                    backButton(context),
                    //Text With Drawer Button
                    adminTopTitleWithDrawerButton(
                        title: 'Requests', size: 40, hasDrawer: false),
                    Expanded(
                      child: ConditionalBuilder(
                        condition: state is! AdminGetRequestsLoadingState &&
                            cubit.requests != null &&
                            cubit.requests!.isNotEmpty,
                        builder: (context) => ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              //return Text('${cubit.requests![index].author?.authorName}', style: TextStyle(fontSize: 30, color: Colors.white),);
                              return requestedMaterialBuilder(
                                  backgroundColor, index, context,
                                  title: 'material Title',
                                  type: cubit.requests![index].type,
                                  pfp: cubit.requests![index].author?.photo,
                                  authorName:
                                      cubit.requests![index].author?.name,
                                  link: cubit.requests![index].link,
                                  subjectName: 'Calculus1',
                                  description: 'chapter 4');
                            },
                            separatorBuilder: (context, index) => const Padding(
                                padding: EdgeInsetsDirectional.all(5)),
                            itemCount: cubit.requests!.length),
                        fallback: (context) {
                          if (state is AdminGetRequestsLoadingState) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          return const Center(
                            child: Text(
                              'You have no requests yet!!!!!',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 40,
                                  color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget requestedMaterialBuilder(List<String> colorText, index, context,
      {title, link, type, authorName, pfp, subjectName, description}) {
    var random = Random();

    int min = 0;
    int max = 9;
    int randomNum = min + random.nextInt(max - min + 1);

    return Container(
      decoration: BoxDecoration(
          color: HexColor(colorText[randomNum]).withOpacity(0.45),
          borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsetsDirectional.symmetric(horizontal: 10),
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
      height: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //pfp, name, subject
          Padding(
            padding: const EdgeInsetsDirectional.only(bottom: 5, top: 10),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(pfp.toString()),
                  radius: 20,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  authorName.toString(),
                  style: TextStyle(fontSize: 18, color: Colors.grey[300]),
                ),
                const Spacer(),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 100,
                  ),
                  child: Text(
                    subjectName,
                    style: TextStyle(color: Colors.grey[300]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textWidthBasis: TextWidthBasis.longestLine,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(
                start: 10.0, end: 10, top: 5, bottom: 5),
            child: Text(
              description,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          //Link Icon, Link Content preview, accept, decline
          LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                children: [
                  const Icon(Icons.link, color: Colors.white),
                  const SizedBox(width: 5),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: constraints.maxWidth -
                          140, // Subtract extra pixels from the remaining width
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        final linkElement = LinkableElement(
                            link, link); // Create a LinkableElement
                        await onOpen(context, linkElement);
                      },
                      child: Text(
                        link,
                        style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.blue,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const Spacer(), // Pushes the buttons to the end of the row
                  // Checkmark button
                  MaterialButton(
                    onPressed: () {
                      AdminCubit.get(context).acceptRequest(
                          (AdminCubit.get(context).requests![index].id!));
                    },
                    shape: const CircleBorder(), // Checkmark icon
                    minWidth: 0, // Reduce min width to make it smaller
                    padding: const EdgeInsets.all(8), // Circular button
                    child: Icon(
                      Icons.check,
                      color: Colors.green,
                    ), // Padding for icon
                  ),
                  // X button
                  MaterialButton(
                    onPressed: () {
                      AdminCubit.get(context).deleteMaterial(
                          AdminCubit.get(context).requests![index].id!);
                    },
                    shape: const CircleBorder(), // X icon
                    minWidth: 0, // Reduce min width to make it smaller
                    padding: const EdgeInsets.all(8), // Circular button
                    child: Icon(
                      Icons.close,
                      color: Colors.red,
                    ), // Padding for icon
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
