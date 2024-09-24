import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
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
  const AnnouncementDetail(
      {super.key,
      required this.title,
      required this.description,
      required this.date,
      required this.id,
      required this.selectedType});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCubit, AdminCubitStates>(
      listener: (context, state) {
        if (state is AdminDeleteAnnouncementSuccessState) {
          showToastMessage(
              message: 'Announcement Deleted Successfully!!',
              states: ToastStates.WARNING);
          Navigator.pop(context, 'refresh');
        }
      },
      builder: (context, state) {
        var cubit = AdminCubit.get(context).announcements![id];
        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(children: [
            backgroundEffects(),
            Container(
              margin: const EdgeInsetsDirectional.only(top: 50),
              width: double.infinity,
              child: Column(
                children: [
                  //Back Button
                  backButton(context),
                  adminTopTitleWithDrawerButton(
                      title: 'Announcement', size: 35, hasDrawer: false),
                  Container(
                    margin: const EdgeInsetsDirectional.symmetric(
                        horizontal: 15, vertical: 20),
                    padding: const EdgeInsets.all(15),
                    width: double.infinity,
                    height: screenHeight(context) / 1.45,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              HexColor('DA22FF').withOpacity(0.45),
                              HexColor('9B35F3').withOpacity(0.45)
                            ],
                            begin: Alignment.bottomRight,
                            end: Alignment.topLeft),
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 21,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: HexColor('D9D9D9').withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Linkify(
                                    onOpen: (link) => onOpen(context, link),
                                    text: description,
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
                                      'DeadLine: $date',
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ]),
        );
      },
    );
  }
}
