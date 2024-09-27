import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkify/linkify.dart';
import 'package:lol/layout/home/bloc/main_cubit.dart';
import 'package:lol/shared/styles/colors.dart';
import 'package:lol/shared/components/constants.dart';
import 'package:lol/modules/subject/cubit/subject_cubit.dart';
import 'package:lol/models/subjects/subject_model.dart';
import 'package:lol/shared/components/components.dart';

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
    _tabControllerOfShowingContent.animation?.addListener(() {
      int newIndex = _tabControllerOfShowingContent.animation!.value.round();
      if (newIndex != SubjectCubit.get(context).selectedTabIndex) {
        SubjectCubit.get(context).changeTap(index: newIndex);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SubjectCubit, SubjectState>(
      listener: (context, state) {
        if (state is SaveMaterialSuccess) {
          showToastMessage(
              message: 'تم عرض الطلب على مسؤول التطبيق وفى انتظار الموافقة  ',
              states: ToastStates.SUCCESS
          );
        } else if (state is SaveMaterialError) {
          showToastMessage(
              message: 'error while uploading file', states: ToastStates.ERROR);
        } else if (state is SaveMaterialLoading) {
          showToastMessage(
              message: 'Uploading file........', states: ToastStates.WARNING);
        }
      },
      child: Scaffold(
        floatingActionButton: buildFloatingActionButton(),
        key: scaffoldKey,
        drawer: drawerBuilder(context),
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            backgroundEffects(),
            Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 8.0),
                  alignment: Alignment.topLeft,
                  child: MaterialButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 30,
                      )),
                ),
                adminTopTitleWithDrawerButton(
                    scaffoldKey: scaffoldKey,
                    title: 'Material Name',
                    size: 32,
                    hasDrawer: true),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: divider(),
                ),
                Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(217, 217, 217, 0.25),
                        borderRadius: BorderRadius.circular(40)),
                    width: screenWidth(context) / 1.2,
                    child: customTabBar(
                        tabController: _tabControllerOfShowingContent,
                        title1: 'Videos',
                        title2: 'Documents')),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(
                    color: Color.fromRGBO(255, 255, 255, 0.25),
                  ),
                ),
                Expanded(child: customTabBarView())
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildFloatingActionButton() {
    return SizedBox(
      height: 60,
      width: 60,
      child: FloatingActionButton(
        onPressed: () {
          _titleController.text = '';
          _descriptionController.text = '';
          _linkController.text = '';
          showModalBottomSheet(
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              context: context,
              builder: (context) => buildBottomSheet());
        },
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        backgroundColor: additional2,
        child: Icon(
          Icons.add,
          color: a,
          size: 30,
        ),
      ),
    );
  }

  Widget customTabBarView() {
    var cubit = SubjectCubit.get(context);

    return TabBarView(
      controller: _tabControllerOfShowingContent,
      children: [
        BlocBuilder<SubjectCubit, SubjectState>(
          builder: (context, state) {
            return ConditionalBuilder(
              condition: state is! GetMaterialLoading &&
                  cubit.documents!.isNotEmpty &&
                  cubit.documents != null,
              builder: (context) {
                return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GridView.builder(
                        itemCount: cubit.videos!.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                mainAxisSpacing: 20,
                                childAspectRatio: 1.5),
                        itemBuilder: (context, i) {
                          return Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromRGBO(217, 217, 217, 0.1),
                                  borderRadius: BorderRadius.circular(15)),
                              child: gridTileWidget(video: cubit.videos![i]));
                        }));
              },
              fallback: (context) {
                if (state is GetMaterialLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Center(
                  child: Text(
                    'No Materials Available',
                    style: TextStyle(color: a),
                  ),
                );
              },
            );
          },
        ),
        BlocBuilder<SubjectCubit, SubjectState>(
          builder: (context, state) {
            return ConditionalBuilder(
              condition: state is! GetMaterialLoading &&
                  cubit.videos != null &&
                  cubit.videos!.isNotEmpty,
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
                }
                return Center(
                  child: Text(
                    'No Materials Available',
                    style: TextStyle(color: a),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget gridTileWidget({required MaterialModel video}) {
    return InkWell(
      onTap: () async {
        final linkELement = LinkableElement(video.link, video.link!);
        await onOpen(context, linkELement);
      },
      child: GridTile(
        footer: Container(
          padding: const EdgeInsets.all(5),
          color: Colors.black,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${video.title}',
                style: TextStyle(
                  fontSize: screenWidth(context) / 20,
                  color: a,
                ),
              ),
              TOKEN != null
                  ? ConditionalBuilder(
                      condition: MainCubit.get(context).profileModel != null &&
                          MainCubit.get(context).profileModel!.role == 'ADMIN',
                      builder: (context) =>
                          SizedBox(height: 40, child: removeButton()),
                      fallback: null)
                  : Container(),
            ],
          ),
        ),
        child: Image.network(
          getYouTubeThumbnail(video.link!),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget documentsCard({required MaterialModel document}) {
    return InkWell(
      onTap: () async {
        final linkELement = LinkableElement(document.link, document.link!);
        await onOpen(context, linkELement);
      },
      child: Card(
          color: const Color.fromRGBO(217, 217, 217, 0.25),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 10.0),
                  child: Icon(
                    Icons.folder_outlined,
                    size: screenWidth(context) / 10,
                    color: a,
                  ),
                ),
                Expanded(
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
                TOKEN != null
                    ? ConditionalBuilder(
                        condition:
                            MainCubit.get(context).profileModel != null &&
                                MainCubit.get(context).profileModel!.role ==
                                    'ADMIN',
                        builder: (context) =>
                            SizedBox(height: 40, child: removeButton()),
                        fallback: null)
                    : Container(),
              ],
            ),
          )),
    );
  }

  Widget removeButton() {
    return ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
            backgroundColor: remove,
            padding: const EdgeInsetsDirectional.symmetric(
                horizontal: 15, vertical: 0)),
        child: Text(
          'Remove',
          style: TextStyle(color: a, fontSize: screenWidth(context) / 24),
        ));
  }

  Widget customTabBar(
      {required TabController tabController,
      required String title1,
      required String title2}) {
    var cubit = SubjectCubit.get(context);
    return BlocBuilder<SubjectCubit, SubjectState>(
      builder: (context, state) {
        return TabBar(
          dividerHeight: 0,
          indicator: const BoxDecoration(),
          controller: tabController,
          tabs: [
            tabForCustomTabBar(title1, cubit.selectedTabIndex == 0),
            tabForCustomTabBar(title2, cubit.selectedTabIndex == 1)
          ],
          onTap: (index) {
            cubit.changeTap(index: index);
          },
        );
      },
    );
  }

  Widget tabForCustomTabBar(String title, bool isSelected) {
    return Tab(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isSelected ? additional2 : Colors.transparent,
        ),
        child: Center(
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: a, fontSize: 20),
          ),
        ),
      ),
    );
  }

  Widget customTextFormField(
      {required String title,
      required TextEditingController controller,
      required TextInputType keyboardtype}) {
    return TextFormField(
      keyboardType: keyboardtype,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field must not be Empty';
        }
        return null;
      },
      style: TextStyle(color: a, fontSize: 20),
      controller: controller,
      decoration: InputDecoration(
          fillColor: const Color.fromRGBO(217, 217, 217, 0.25),
          filled: true,
          contentPadding: const EdgeInsets.all(20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          hintText: title,
          hintStyle: const TextStyle(
            color: Color.fromRGBO(255, 255, 255, 0.48),
            fontSize: 22,
          )),
    );
  }

  Widget buildBottomSheet() {
    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      maxChildSize: 0.55,
      builder: (context, scrollController) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: const Color.fromRGBO(25, 25, 25, 1),
          body: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: const EdgeInsets.all(16),
              width: screenWidth(context),
              child: addingMaterialForm(scrollController)),
        );
      },
    );
  }

  Widget addingMaterialForm(ScrollController scrollController) {
    var cubit = SubjectCubit.get(context);
    return BlocBuilder<SubjectCubit, SubjectState>(
      builder: (context, state) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: customTextFormField(
                        title: 'Title',
                        controller: _titleController,
                        keyboardtype: TextInputType.name),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: customTextFormField(
                        title: 'Description(e.g:chapter3)',
                        controller: _descriptionController,
                        keyboardtype: TextInputType.text),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: customTextFormField(
                        title: 'Link',
                        controller: _linkController,
                        keyboardtype: TextInputType.url),
                  ),
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(217, 217, 217, 0.25),
                          borderRadius: BorderRadius.circular(40)),
                      width: screenWidth(context) / 1.2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                                left: 0, top: 0, bottom: 0),
                            padding: const EdgeInsets.all(10),
                            width: screenWidth(context) / 4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: additional2,
                            ),
                            child: Text(
                              cubit.selectedType.toLowerCase(),
                              style: TextStyle(color: a, fontSize: 16),
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
                      )),
                  //Cancel and submit buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      //Cancel Button
                      MaterialButton(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        minWidth: screenWidth(context) / 3,
                        shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)),
                        color: const Color.fromRGBO(70, 70, 70, 0.36),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: additional1, fontSize: 20),
                        ),
                      ),
                      //Submit Button
                      MaterialButton(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        minWidth: screenWidth(context) / 3,
                        shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)),
                        color: additional2,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            BlocProvider.of<SubjectCubit>(context).addMaterial(
                                title: _titleController.text,
                                description: _descriptionController.text,
                                link: _linkController.text,
                                type: cubit.selectedType);

                            Navigator.of(context).pop();
                          }
                        },
                        child: Text(
                          'Submit',
                          style: TextStyle(color: a, fontSize: 20),
                        ),
                      ),
                    ],
                  )
                ],
              )),
        );
      },
    );
  }
}
