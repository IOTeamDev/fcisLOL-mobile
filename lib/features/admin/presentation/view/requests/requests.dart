import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:googleapis/playintegrity/v1.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:linkify/linkify.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit_states.dart';
import 'package:lol/main.dart';
import 'package:lol/features/admin/presentation/view_model/admin_cubit/admin_cubit.dart';
import 'package:lol/features/admin/presentation/view_model/admin_cubit/admin_cubit_states.dart';
import 'package:lol/features/admin/presentation/view/announcements/announcement_detail.dart';
import 'package:lol/features/admin/presentation/view/requests/requests_details.dart';
import 'package:lol/core/utils/components.dart';
import 'package:lol/core/utils/navigation.dart';
import '../../../../../core/utils/resources/constants_manager.dart';

class Requests extends StatefulWidget {
  const Requests({super.key});

  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainCubitStates>(
      listener: (context, state) {
        if (state is GetProfileSuccess) {
          MainCubit.get(context).getRequests(
              semester: MainCubit.get(context).profileModel!.semester);
        }
      },
      builder: (context, mainState) {
        var cubit = MainCubit.get(context);

        return Scaffold(
          key: scaffoldKey,
          body: Stack(
            children: [
              Container(
                margin: EdgeInsetsDirectional.only(
                    top: AppQueries.screenHeight(context) / 10),
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
                          'Requests',
                          style: TextStyle(
                            fontSize: AppQueries.screenWidth(context) / 10,
                          ),
                          textAlign: TextAlign.center,
                        )),
                      ],
                    ),
                    Expanded(
                      child: ConditionalBuilder(
                          condition: cubit.requests != null &&
                              cubit.requests!.isNotEmpty &&
                              mainState is! GetRequestsLoadingState &&
                              mainState is! GetProfileLoading,
                          builder: (context) => ListView.separated(
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return requestedMaterialBuilder(
                                      index, context,
                                      title: cubit.requests![index].title,
                                      type: cubit.requests![index].type,
                                      pfp: cubit.requests![index].author?.photo,
                                      authorName:
                                          cubit.requests![index].author?.name,
                                      link: cubit.requests![index].link,
                                      subjectName: cubit.requests![index]
                                          .subject, // Use proper subject if available
                                      description:
                                          cubit.requests![index].description,
                                      semester: cubit.profileModel!.semester);
                                },
                                separatorBuilder: (context, index) =>
                                    const Padding(
                                  padding: EdgeInsetsDirectional.all(5),
                                ),
                                itemCount: cubit.requests!.length,
                              ),
                          fallback: (context) {
                            if (mainState is GetRequestsLoadingState) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              return const Center(
                                child: Text(
                                  'No requests available',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                ),
                              );
                            }
                          }),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget requestedMaterialBuilder(index, context,
      {title,
      link,
      type,
      authorName,
      pfp,
      subjectName,
      description,
      semester}) {
    return InkWell(
      onTap: () async {
        String refresh = await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => RequestsDetails(
                  authorName: authorName,
                  type: type,
                  description: description,
                  link: link,
                  subjectName: subjectName,
                  id: index,
                  title: title,
                  pfp: pfp,
                  semester: semester,
                )));
        if (refresh == 'refresh') {
          MainCubit.get(context).getRequests(
              semester: MainCubit.get(context).profileModel!.semester);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: MainCubit.get(context).isDark
              ? HexColor('#3B3B3B')
              : HexColor('#757575'),
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsetsDirectional.symmetric(horizontal: 10),
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
        height: 170,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.only(
                  bottom: 5, top: 10, start: 10, end: 10),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(pfp.toString()),
                    radius: 17,
                  ),
                  const SizedBox(width: 10),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: AppQueries.screenWidth(context) / 2),
                    child: Text(
                      authorName.toString(),
                      style: TextStyle(fontSize: 18, color: Colors.grey[300]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
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
              padding: const EdgeInsetsDirectional.only(
                  start: 10.0, end: 10, top: 0, bottom: 5),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 10.0),
              child: Text(
                type,
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
                      constraints:
                          BoxConstraints(maxWidth: constraints.maxWidth - 140),
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
                        MainCubit.get(context).acceptRequest(
                            MainCubit.get(context).requests![index].id!,
                            MainCubit.get(context).profileModel!.semester);
                      },
                      color: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      minWidth: 0,
                      padding: const EdgeInsets.all(8),
                      child: const Icon(Icons.check, color: Colors.white),
                    ),
                    MaterialButton(
                      onPressed: () {
                        AwesomeDialog(
                          context: context,
                          title: "Delete",
                          dialogType: DialogType.warning,
                          body: Text(
                            "Are you sure you want to Delete the request?",
                            style: TextStyle(fontSize: 17),
                          ),
                          animType: AnimType.rightSlide,
                          btnOkColor: Colors.red,
                          btnCancelOnPress: () {},
                          btnOkText: "Delete",
                          btnCancelColor: Colors.grey,

                          // titleTextStyle: TextStyle(fontSize: 22),
                          btnOkOnPress: () {
                            MainCubit.get(context).deleteMaterial(
                              MainCubit.get(context).requests![index].id!,
                              MainCubit.get(context).profileModel!.semester,
                            );
                          },
                        ).show();
                      },
                      color: Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      minWidth: 0,
                      padding: const EdgeInsets.all(8),
                      child: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
