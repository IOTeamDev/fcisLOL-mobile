import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:linkify/linkify.dart';
import 'package:lol/main.dart';
import 'package:lol/features/admin/presentation/view_model/admin_cubit/admin_cubit_states.dart';
import 'package:lol/features/admin/presentation/view/announcements/announcement_detail.dart';
import 'package:lol/core/utils/constants.dart';
import 'package:lol/core/utils/components.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:lol/core/utils/navigation.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:lol/core/utils/webview_screen.dart';
import '../../view_model/admin_cubit/admin_cubit.dart';

class AnnouncementDetail extends StatelessWidget {
  // final int id;
  final String title;
  final String description;
  final dynamic date;

  final String semester;

  const AnnouncementDetail(
      {super.key,
      required this.title,
      required this.description,
      required this.date,
      // required this.id,
      required this.semester});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdminCubit()..getAnnouncements(semester),
      child: BlocConsumer<AdminCubit, AdminCubitStates>(
        listener: (context, state) {
          if (state is AdminDeleteAnnouncementSuccessState) {
            showToastMessage(
                message: 'Announcement Deleted Successfully!!',
                states: ToastStates.WARNING);
            Navigator.pop(context, 'refresh');
          }
        },
        builder: (context, state) {
          double width = screenWidth(context);
          double height = screenHeight(context);
          return Scaffold(
            //backgroundColor: HexColor('#23252A'),
            body: Container(
              margin:
                  EdgeInsetsDirectional.only(top: screenHeight(context) / 10),
              width: double.infinity,
              child: Column(
                children: [
                  //Back Button
                  Stack(
                    children: [
                      Positioned(
                        left: 0,
                        child: backButton(context),
                      ),
                      Center(
                          child: Text(
                        'Announcement',
                        style: TextStyle(
                          fontSize: width / 12,
                        ),
                        textAlign: TextAlign.center,
                      )),
                    ],
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: screenHeight(context) / 1.4,
                    ),
                    child: Container(
                      margin: const EdgeInsetsDirectional.only(
                          start: 15, end: 15, top: 20),
                      padding: const EdgeInsets.all(18),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: isDark
                              ? HexColor('#3B3B3B')
                              : HexColor('#4764C5'),
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: width / 13,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            width: double.infinity,
                            height: 2,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Linkify(
                                    onOpen: (link) => onOpen(context, link),
                                    text:
                                        'content:\n${description == '' ? 'No content' : description}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                    linkStyle:
                                        const TextStyle(color: Colors.blue),
                                    linkifiers: const [
                                      UrlLinkifier(),
                                      EmailLinkifier(),
                                      PhoneNumberLinkifier(),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                        top: 40.0),
                                    child: Text(
                                      'DeadLine: ${date == 'No Due Date' ? date : DateFormat('dd/MM/yyyy').format(DateTime.parse(date)).toString()}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
