import 'dart:math';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:lol/features/admin/presentation/view_model/admin_cubit/admin_cubit.dart';
import 'package:lol/features/admin/presentation/view_model/admin_cubit/admin_cubit_states.dart';
import 'package:lol/features/admin/presentation/view/announcements/announcement_detail.dart';
import 'package:lol/shared/components/components.dart';
import 'package:lol/shared/components/navigation.dart';
import 'package:lol/shared/styles/colors.dart';

import '../../../../../shared/components/constants.dart';

class AnnouncementsList extends StatelessWidget {
  final String semester;
  const AnnouncementsList({super.key, required this.semester});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdminCubit()..getAnnouncements(semester),
      child: BlocConsumer<AdminCubit, AdminCubitStates>(
        listener: (context, state) {},
        builder: (context, state) {
          double width = screenWidth(context);
          double height = screenHeight(context);
          var cubit = AdminCubit.get(context);
          return Scaffold(
            //backgroundColor: HexColor('#23252A'),
            body: Container(
              margin:
                  EdgeInsetsDirectional.only(top: screenHeight(context) / 10),
              width: double.infinity,
              child: SingleChildScrollView(
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
                          'Announcements',
                          style: TextStyle(
                            fontSize: width / 12,
                          ),
                          textAlign: TextAlign.center,
                        )),
                      ],
                    ),
                    ConditionalBuilder(
                      condition: state is! AdminGetAnnouncementLoadingState &&
                          cubit.announcements != null &&
                          cubit.announcements!.isNotEmpty,
                      builder: (context) => ListView.separated(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) => announcementBuilder(
                            cubit.announcements![index].id,
                            context,
                            cubit.announcements![index].title,
                            index,
                            cubit.announcements![index].content,
                            cubit.announcements![index].dueDate,
                            cubit.announcements![index].type),
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 10,
                        ),
                        itemCount: cubit.announcements!.length,
                        //cubit.announcements!.length
                      ),
                      fallback: (context) {
                        if (state is AdminGetAnnouncementLoadingState) {
                          return SizedBox(
                            height: height / 1.3,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        } else {
                          return SizedBox(
                            height: height / 1.3,
                            child: Center(
                              child: Text(
                                'You have no announcements yet!!!',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget announcementBuilder(int id, BuildContext context, String title,
      int index, String content, dueDate, type) {
    var random = Random();
    int rand = random.nextInt(announcementsColorList.length);
    return GestureDetector(
      onTap: () {
        navigate(
            context,
            AnnouncementDetail(
              semester: semester, //
              title: title,
              description: content,
              date: dueDate,
              // id: id,
            ));
      },
      child: Container(
        margin: EdgeInsetsDirectional.symmetric(horizontal: 10),
        padding: EdgeInsetsDirectional.symmetric(horizontal: 20, vertical: 15),
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: announcementsColorList[rand]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              content,
              style: TextStyle(color: Colors.grey[300], fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  dueDate == 'No Due Date'
                      ? dueDate
                      : DateFormat('dd/MM/yyyy')
                          .format(DateTime.parse(dueDate))
                          .toString(),
                  style: TextStyle(color: Colors.white, fontSize: 14),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
