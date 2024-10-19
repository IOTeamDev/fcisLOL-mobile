import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/admin/directory_v1.dart';
import 'package:linkify/linkify.dart';
import 'package:lol/layout/home/bloc/main_cubit.dart';
import 'package:lol/main.dart';
import 'package:lol/models/profile/profile_model.dart';
import 'package:lol/modules/auth/screens/login.dart';
import 'package:lol/shared/components/default_text_field.dart';
import 'package:lol/shared/network/endpoints.dart';
import 'package:lol/shared/styles/colors.dart';
import 'package:lol/shared/components/constants.dart';
import 'package:lol/modules/subject/cubit/subject_cubit.dart';
import 'package:lol/models/subjects/subject_model.dart';
import 'package:lol/shared/components/components.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

class SubjectDetails extends StatefulWidget {
  final String subjectName;
  const SubjectDetails({super.key, required this.subjectName});

  @override
  State<SubjectDetails> createState() => _MaterialDetailsState();
}

class _MaterialDetailsState extends State<SubjectDetails>
    with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabControllerOfShowingContent;
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _linkController = TextEditingController();

  @override
  void initState() {
    _tabControllerOfShowingContent = TabController(length: 2, vsync: this);

    SubjectCubit.get(context).getMaterials(subject: widget.subjectName);
    MainCubit.get(context).getProfileInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = SubjectCubit.get(context);

    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => MainCubit()),
        ],
        child: BlocListener<SubjectCubit, SubjectState>(
            listener: (context, state) {
              if (state is SaveMaterialSuccessUser) {
                showToastMessage(
                    message:
                        'The request has been sent to the Admin, and waiting for approval...',
                    states: ToastStates.SUCCESS);
              } else if (state is SaveMaterialSuccessAdmin) {
                showToastMessage(
                    message: 'Material Added Successfully',
                    states: ToastStates.SUCCESS);
              } else if (state is SaveMaterialError) {
                showToastMessage(
                    message: 'error while uploading Material',
                    states: ToastStates.ERROR);
              } else if (state is SaveMaterialLoading) {
                showToastMessage(
                    message: 'Uploading Material........',
                    states: ToastStates.WARNING);
              } else if (state is DeleteMaterialLoading) {
                showToastMessage(
                    message: 'Deleting Material........',
                    states: ToastStates.WARNING);
              } else if (state is DeleteMaterialSuccess) {
                showToastMessage(
                    message: 'Material Deleted', states: ToastStates.SUCCESS);
              } else if (state is DeleteMaterialError) {
                showToastMessage(
                    message: 'error while deleting material',
                    states: ToastStates.ERROR);
              }
            },
            child: Scaffold(
              floatingActionButton: buildFloatingActionButton(),
              key: scaffoldKey,
              backgroundColor: Color(0xff1B262C),
              body: Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      MaterialButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 30,
                          )),
                      SizedBox(
                        width: screenWidth(context) / 1.3,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Text(
                            widget.subjectName
                                .replaceAll('_', " ")
                                .replaceAll("and", "&"),
                            style: TextStyle(
                                color: a, fontSize: screenWidth(context) / 15),
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
                      style: TextStyle(color: Color(0xff1B262C), fontSize: 20),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                          fillColor: a,
                          filled: true,
                          prefixIcon: Icon(
                            Icons.search,
                            size: 25,
                            color: Color.fromRGBO(117, 117, 117, 1),
                          ),
                          contentPadding: const EdgeInsets.all(10.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          hintText: 'Search for Videos, Documents',
                          hintStyle: const TextStyle(
                            color: Color.fromRGBO(117, 117, 117, 1),
                            fontSize: 15,
                          )),
                    ),
                  ),
                  customTabBar(
                      tabController: _tabControllerOfShowingContent,
                      title1: 'Videos',
                      title2: 'Documents'),
                  // const Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 16),
                  //   child: Divider(
                  //       // color: Color.fromRGBO(255, 255, 255, 0.25),
                  //       ),
                  // ),
                  Expanded(child: customTabBarView()),
                ],
              ),
            )));
  }

  Widget buildFloatingActionButton() {
    return SizedBox(
      height: 70,
      width: 70,
      child: FloatingActionButton(
        onPressed: () {
          if (TOKEN == null) {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.info,
              animType: AnimType.rightSlide,
              // titleTextStyle: TextStyle(fontSize: 12),
              title: "Log in to continue adding material.",
              btnOkText: "Sign in",
              btnCancelText: "Maybe later",
              btnCancelOnPress: () {},
              btnOkOnPress: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                  (route) => false),
            ).show();
          } else {
            _titleController.text = '';
            _descriptionController.text = '';
            _linkController.text = '';
            showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) => buildBottomSheet());
          }
        },
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        backgroundColor: Color.fromRGBO(71, 100, 197, 1),
        child: Icon(
          Icons.add,
          color: a,
          size: 40,
        ),
      ),
    );
  }

  Widget customTabBarView() {
    return TabBarView(
      controller: _tabControllerOfShowingContent,
      children: [
        BlocBuilder<SubjectCubit, SubjectState>(
          builder: (context, state) {
            var cubit = SubjectCubit.get(context);
            return ConditionalBuilder(
                condition:
                    state is! GetMaterialLoading && cubit.videos!.isNotEmpty,
                builder: (context) => Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView.builder(
                        itemCount: cubit.videos!.length,
                        itemBuilder: (context, i) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 16.0),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(59, 59, 59, 1),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: gridTileWidget(video: cubit.videos![i]),
                          );
                        },
                      ),
                    ),
                fallback: (context) {
                  if (state is GetMaterialLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Center(
                      child: Text(
                        'Materials Appear here',
                        style: TextStyle(color: a),
                      ),
                    );
                  }
                });
          },
        ),
        BlocBuilder<SubjectCubit, SubjectState>(
          builder: (context, state) {
            var cubit = SubjectCubit.get(context);
            return ConditionalBuilder(
                condition:
                    state is! GetMaterialLoading && cubit.documents!.isNotEmpty,
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView.builder(
                      itemCount: cubit.documents!.length,
                      itemBuilder: (context, i) {
                        return documentsCard(document: cubit.documents![i]);
                      },
                    ),
                  );
                },
                fallback: (context) {
                  if (state is GetMaterialLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Center(
                      child: Text(
                        'Materials Appear here',
                        style: TextStyle(color: a),
                      ),
                    );
                  }
                });
          },
        ),
      ],
    );
  }

  Widget gridTileWidget({required MaterialModel video, rule}) {
    return InkWell(
        onTap: () async {
          final linkableElement = LinkableElement(video.link, video.link!);
          await onOpen(context, linkableElement);
        },
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: getYouTubeThumbnail(video.link!) != null
                        ? Image.network(
                            getYouTubeThumbnail(video.link!)!,
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            'https://www.buffalotech.com/images/made/images/remote/https_i.ytimg.com/vi/06wIw-NdHIw/sddefault_300_225_s.jpg',
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    video.title ?? '',
                    style: TextStyle(
                      fontSize: screenWidth(context) / 18,
                      color: a,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            if (MainCubit.get(context).profileModel?.role == 'ADMIN' &&
                TOKEN != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                    alignment: Alignment.topRight,
                    child: removeButton(material: video)),
              ),
          ],
        ));
  }

  Widget documentsCard({required MaterialModel document}) {
    return InkWell(
      onTap: () async {
        final linkElement = LinkableElement(document.link, document.link!);
        await onOpen(context, linkElement);
      },
      child: Card(
          color: const Color.fromRGBO(59, 59, 59, 1),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 10.0),
                  child: Icon(
                    Icons.folder_copy_sharp,
                    size: screenWidth(context) / 10,
                    color: a,
                  ),
                ),
                Expanded(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(maxWidth: screenWidth(context) - 180),
                    child: Text(
                      '${document.title}',
                      style: TextStyle(
                        color: a,
                        fontSize: screenWidth(context) / 20,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
                if (MainCubit.get(context).profileModel?.role == 'ADMIN' &&
                    TOKEN != null)
                  removeButton(material: document),
              ],
            ),
          )),
    );
  }

  Widget removeButton({required MaterialModel material}) {
    var cubit = SubjectCubit.get(context);
    return BlocBuilder<SubjectCubit, SubjectState>(
      buildWhen: (previous, current) =>
          current is DeleteMaterialError ||
          current is DeleteMaterialLoading ||
          current is DeleteMaterialSuccess,
      builder: (context, state) {
        return MaterialButton(
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          minWidth: 30,
          height: 50,
          color: a,
          onPressed: () {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.warning,
              animType: AnimType.rightSlide,
              title: 'Sure about deleting "${material.title}"?',
              btnOkText: "Delete",
              btnCancelOnPress: () {},
              btnOkOnPress: () {
                cubit.deleteMaterial(
                    id: material.id!, subjectName: material.subject!);
              },
            ).show();
          },
          child: Icon(
            Icons.delete,
            color: Color.fromRGBO(206, 58, 60, 1),
            size: 25,
          ),
        );
      },
    );
  }

  Widget customTabBar(
      {required TabController tabController,
      required String title1,
      required String title2}) {
    return TabBar(
      indicatorColor: a,
      indicatorWeight: 1.0,
      labelColor: a,
      dividerColor: Color.fromRGBO(96, 96, 96, 1),
      unselectedLabelColor: Color.fromRGBO(59, 59, 59, 1),
      controller: tabController,
      tabs: [tabForCustomTabBar(title1), tabForCustomTabBar(title2)],
    );
  }

  Widget tabForCustomTabBar(String title) {
    return Tab(
      child: Center(
        child: Text(
          title,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  Widget buildBottomSheet() {
    bool wannaProfileModel = true;
    var cubit = SubjectCubit.get(context);
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(59, 59, 59, 1),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(16),
          width: screenWidth(context),
          child: BlocBuilder<SubjectCubit, SubjectState>(
            buildWhen: (previous, current) => current is TypeChangedState,
            builder: (context, state) {
              if (wannaProfileModel) {
                MainCubit.get(context).getProfileInfo();
                wannaProfileModel = false;
              }

              return wannaProfileModel
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : SingleChildScrollView(
                      child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.text,
                                  controller: _titleController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'This field must not be Empty';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Title (e.g:chapter3)',
                                    hintStyle: TextStyle(
                                        fontSize: 20,
                                        color:
                                            Color.fromRGBO(132, 132, 132, 1)),
                                  ),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.multiline,
                                  controller: _descriptionController,
                                  decoration: InputDecoration(
                                    hintText: 'Description (Optional)',
                                    hintStyle: TextStyle(
                                        fontSize: 20,
                                        color:
                                            Color.fromRGBO(132, 132, 132, 1)),
                                  ),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: TextFormField(
                                  textInputAction: TextInputAction.done,
                                  keyboardType: TextInputType.url,
                                  controller: _linkController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'This field must not be Empty';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Material Link',
                                    hintStyle: TextStyle(
                                        fontSize: 20,
                                        color:
                                            Color.fromRGBO(132, 132, 132, 1)),
                                  ),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),

                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 0, top: 0, bottom: 0),
                                      padding: const EdgeInsets.all(10),
                                      width: screenWidth(context) / 4,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Color.fromRGBO(71, 100, 197, 1),
                                      ),
                                      child: Text(
                                        cubit.selectedType.toLowerCase(),
                                        style:
                                            TextStyle(color: a, fontSize: 16),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    PopupMenuButton(
                                        onSelected: (type) {
                                          cubit.changeType(type: type);
                                        },
                                        iconColor: a,
                                        itemBuilder: (context) {
                                          return [
                                            PopupMenuItem(
                                              value: cubit.item1,
                                              child: const Text('Video'),
                                            ),
                                            PopupMenuItem(
                                              value: cubit.item2,
                                              child: const Text(
                                                'Document',
                                              ),
                                            )
                                          ];
                                        }),
                                  ],
                                ),
                              ),
                              //Cancel and submit buttons
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  //Cancel Button
                                  MaterialButton(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    minWidth: screenWidth(context) / 3,
                                    shape: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    color: a,
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                          color: Color.fromRGBO(35, 37, 42, 1),
                                          fontSize: 20),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  //Submit Button
                                  if (TOKEN != null)
                                    MaterialButton(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      minWidth: screenWidth(context) / 3,
                                      shape: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      color: Color.fromRGBO(71, 100, 197, 1),
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          BlocProvider.of<SubjectCubit>(context)
                                              .addMaterial(
                                                  title: _titleController.text,
                                                  description:
                                                      _descriptionController
                                                          .text,
                                                  link: _linkController.text,
                                                  type: cubit.selectedType,
                                                  subjectName:
                                                      widget.subjectName,
                                                  semester:
                                                      MainCubit.get(context)
                                                          .profileModel!
                                                          .semester,
                                                  role: MainCubit.get(context)
                                                      .profileModel!
                                                      .role);
                                          Navigator.of(context).pop();
                                        }
                                      },
                                      child: Text(
                                        'Submit',
                                        style:
                                            TextStyle(color: a, fontSize: 20),
                                      ),
                                    ),
                                ],
                              )
                            ],
                          )),
                    );
            },
          )),
    );
  }

  // Widget addingMaterialForm() {
  //   bool wannaProfileModel = true;
  //   var cubit = SubjectCubit.get(context);
  //   return
  // }
}
