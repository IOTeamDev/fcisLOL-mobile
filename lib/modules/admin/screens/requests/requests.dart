import 'dart:math';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:linkify/linkify.dart';
import 'package:lol/layout/home/bloc/main_cubit.dart';
import 'package:lol/layout/home/bloc/main_cubit_states.dart';
import 'package:lol/modules/admin/bloc/admin_cubit.dart';
import 'package:lol/modules/admin/bloc/admin_cubit_states.dart';
import 'package:lol/modules/admin/screens/announcements/announcement_detail.dart';
import 'package:lol/shared/components/components.dart';
import 'package:lol/shared/components/navigation.dart';
import 'package:lol/shared/components/constants.dart';

class Requests extends StatelessWidget {
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => MainCubit()..getProfileInfo()),
      ],
      child: BlocConsumer<MainCubit, MainCubitStates>(
          listener: (context, state) {
            if(state is GetProfileSuccess )
              {
                MainCubit.get(context).getRequests(semester: MainCubit.get(context).profileModel!.semester);
              }
          },
        builder: (context, mainState) {
          var cubit = MainCubit.get(context);

          return Scaffold(
            key: scaffoldKey,
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                backgroundEffects(),
                Container(
                  margin: const EdgeInsetsDirectional.only(top: 50),
                  width: double.infinity,
                  child: Column(
                      children: [
                        backButton(context),
                        adminTopTitleWithDrawerButton(title: 'Requests', size: 40, hasDrawer: false),
                        Expanded(
                          child: ConditionalBuilder(
                            condition: cubit.requests != null && cubit.requests!.isNotEmpty && mainState is! GetRequestsLoadingState && mainState is! GetProfileLoading,
                            builder: (context) => ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return requestedMaterialBuilder(
                                  backgroundColor, index, context,
                                  title: cubit.requests![index].title,
                                  type: cubit.requests![index].type,
                                  pfp: cubit.requests![index].author?.photo,
                                  authorName: cubit.requests![index].author?.name,
                                  link: cubit.requests![index].link,
                                  subjectName: 'Calculus1', // Use proper subject if available
                                  description: cubit.requests![index].description,
                                );
                              },
                              separatorBuilder: (context, index) => const Padding(
                                padding: EdgeInsetsDirectional.all(5),
                              ),
                              itemCount: cubit.requests!.length,
                            ),
                            fallback: (context) {
                              if (mainState is GetRequestsLoadingState)
                                return const Center(child: CircularProgressIndicator(),);
                              else
                                return const Center(
                                  child: Text(
                                    'No requests available',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                            }
                          ),
                        )
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget requestedMaterialBuilder(List<String> colorText, index, context, {title, link, type, authorName, pfp, subjectName, description}) {
    var random = Random();
    int randomNum = random.nextInt(10);

    return Container(
      decoration: BoxDecoration(
        color: HexColor(colorText[randomNum]).withOpacity(0.45),
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsetsDirectional.symmetric(horizontal: 10),
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
      height: 170,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(bottom: 5, top: 10, start: 10, end: 10),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(pfp.toString()),
                  radius: 17,
                ),
                const SizedBox(width: 10),
                Text(
                  authorName.toString(),
                  style: TextStyle(fontSize: 18, color: Colors.grey[300]),
                ),
                const Spacer(),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 100),
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
            padding: const EdgeInsetsDirectional.only(start: 10.0, end: 10, top: 0, bottom: 5),
            child: Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                Text(
                  type,
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 10.0),
            child: Text(
              description,
              style: TextStyle(fontSize: 13, color: Colors.grey[300]),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                children: [
                  const Icon(Icons.link, color: Colors.white),
                  const SizedBox(width: 5),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: constraints.maxWidth - 140),
                    child: GestureDetector(
                      onTap: () async {
                        final linkElement = LinkableElement(link, link);
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
                  const Spacer(),
                  MaterialButton(
                    onPressed: () {
                      MainCubit.get(context).acceptRequest(MainCubit.get(context).requests![index].id!,MainCubit.get(context).profileModel!.semester);
                    },
                    shape: const CircleBorder(),
                    minWidth: 0,
                    padding: const EdgeInsets.all(8),
                    child: const Icon(Icons.check, color: Colors.green),
                  ),
                  MaterialButton(
                    onPressed: () {
                      MainCubit.get(context).deleteMaterial(
                        MainCubit.get(context).requests![index].id!,
                        MainCubit.get(context).profileModel!.semester,
                      );
                    },
                    shape: const CircleBorder(),
                    minWidth: 0,
                    padding: const EdgeInsets.all(8),
                    child: const Icon(Icons.close, color: Colors.red),
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

