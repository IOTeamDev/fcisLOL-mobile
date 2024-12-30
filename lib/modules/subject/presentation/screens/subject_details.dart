import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/admin/directory_v1.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:linkify/linkify.dart';
import 'package:lol/layout/home/bloc/main_cubit.dart';
import 'package:lol/layout/profile/other_profile.dart';
import 'package:lol/main.dart';
import 'package:lol/models/profile/profile_model.dart';
import 'package:lol/modules/admin/bloc/admin_cubit.dart';
import 'package:lol/modules/auth/screens/login.dart';
import 'package:lol/modules/subject/data/repos/subject_repo_imp.dart';
import 'package:lol/modules/subject/presentation/cubit/get_material_cubit/get_material_cubit_cubit.dart';
import 'package:lol/modules/subject/presentation/screens/widgets/build_floating_action_button.dart';
import 'package:lol/modules/subject/presentation/screens/widgets/custom_tab_bar.dart';
import 'package:lol/modules/subject/presentation/screens/widgets/custom_tab_bar_view.dart';
import 'package:lol/shared/components/default_text_field.dart';
import 'package:lol/shared/components/navigation.dart';
import 'package:lol/shared/dependencies/subject_repo_dependency.dart';
import 'package:lol/shared/network/endpoints.dart';
import 'package:lol/shared/styles/colors.dart';
import 'package:lol/shared/components/constants.dart';
import 'package:lol/models/subjects/subject_model.dart';
import 'package:lol/shared/components/components.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';

class SubjectDetails extends StatefulWidget {
  final String subjectName;
  final bool navigate;
  const SubjectDetails(
      {super.key, required this.subjectName, required this.navigate});

  @override
  State<SubjectDetails> createState() => _MaterialDetailsState();
}

class _MaterialDetailsState extends State<SubjectDetails>
    with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabControllerOfShowingContent;

  @override
  void initState() {
    _tabControllerOfShowingContent = TabController(length: 2, vsync: this);

    GetMaterialCubit.get(context).getMaterials(subject: widget.subjectName);
    MainCubit.get(context).getProfileInfo();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    _tabControllerOfShowingContent.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = GetMaterialCubit.get(context);

    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => MainCubit()),
        ],
        child: Scaffold(
          floatingActionButton:
              BuildFloatingActionButton(subjectName: widget.subjectName),
          key: scaffoldKey,
          //backgroundColor: isDark ? HexColor('#23252A') : Colors.white,
          body: Container(
            margin: EdgeInsetsDirectional.only(top: screenHeight(context) / 15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: isDark ? Colors.white : Colors.black,
                          size: 30,
                        )),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Text(
                          widget.subjectName
                              .replaceAll('_', " ")
                              .replaceAll("and", "&"),
                          style: TextStyle(
                              color: isDark ? Colors.white : Colors.black,
                              fontSize: screenWidth(context) / 15),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10),
                  child: TextField(
                    onChanged: (query) {
                      cubit.runFilter(query: query);
                    },
                    style: TextStyle(
                        color: isDark ? Color(0xff1B262C) : HexColor('#757575'),
                        fontSize: 20),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                        fillColor: HexColor('#CDCDCD'),
                        filled: true,
                        prefixIcon: Icon(
                          Icons.search,
                          size: 25,
                          color: HexColor('#757575'),
                        ),
                        contentPadding: const EdgeInsets.all(10.0),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        hintText: 'Search for Videos, Documents',
                        hintStyle: TextStyle(
                          color: HexColor('#757575'),
                          fontSize: 15,
                        )),
                  ),
                ),
                CustomTabBar(
                    tabController: _tabControllerOfShowingContent,
                    title1: 'Videos',
                    title2: 'Documents'),
                Expanded(
                    child: CustomTabBarView(
                        controller: _tabControllerOfShowingContent)),
              ],
            ),
          ),
        ));
  }
}


// if (state is SaveMaterialSuccessUser) {
//                 showToastMessage(
//                     message:
//                         'The request has been sent to the Admin, and waiting for approval...',
//                     states: ToastStates.SUCCESS);
//               } else if (state is SaveMaterialSuccessAdmin) {
//                 showToastMessage(
//                     message: 'Material Added Successfully',
//                     states: ToastStates.SUCCESS);
//               } else if (state is SaveMaterialError) {
//                 showToastMessage(
//                     message: 'error while uploading Material',
//                     states: ToastStates.ERROR);
//               } else if (state is SaveMaterialLoading) {
//                 showToastMessage(
//                     message: 'Uploading Material........',
//                     states: ToastStates.WARNING);
//               } else if (state is DeleteMaterialLoading) {
//                 showToastMessage(
//                     message: 'Deleting Material........',
//                     states: ToastStates.WARNING);
//               } else if (state is DeleteMaterialSuccess) {
//                 showToastMessage(
//                     message: 'Material Deleted', states: ToastStates.SUCCESS);
//               } else if (state is DeleteMaterialError) {
//                 showToastMessage(
//                     message: 'error while deleting material',
//                     states: ToastStates.ERROR);
//               }