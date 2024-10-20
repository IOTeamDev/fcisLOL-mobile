import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:linkify/linkify.dart';
import 'package:lol/modules/admin/bloc/admin_cubit_states.dart';
import 'package:lol/modules/admin/screens/announcements/announcement_detail.dart';
import 'package:lol/shared/components/constants.dart';
import 'package:lol/shared/components/components.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:lol/shared/components/navigation.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:lol/modules/webview/webview_screen.dart';
import '../../bloc/admin_cubit.dart';

class AnnouncementDetail extends StatelessWidget {
  final int id;
  final String title;
  final String description;
  final dynamic date;
  final String selectedType;
  final String semester;

  const AnnouncementDetail(
      {super.key,
      required this.title,
      required this.description,
      required this.date,
      required this.id,
      required this.selectedType,
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
            backgroundColor: HexColor('#23252A'),
            body: Container(
              margin: const EdgeInsetsDirectional.only(top: 90),
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
                            fontSize: width / 12, color: Colors.white),
                        textAlign: TextAlign.center,
                      )),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsetsDirectional.symmetric(
                        horizontal: 15, vertical: 20),
                    padding: const EdgeInsets.all(18),
                    width: double.infinity,
                    height: screenHeight(context) / 1.4,
                    decoration: BoxDecoration(
                        color: HexColor('#3B3B3B'),
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
                                  padding:
                                      const EdgeInsetsDirectional.symmetric(
                                          vertical: 25.0),
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
