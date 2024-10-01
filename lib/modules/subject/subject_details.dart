import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkify/linkify.dart';
import 'package:lol/layout/home/bloc/main_cubit.dart';
import 'package:lol/layout/home/bloc/main_cubit_states.dart';
import 'package:lol/layout/home/home.dart';
import 'package:lol/models/profile/profile_model.dart';
import 'package:lol/shared/components/default_text_field.dart';
import 'package:lol/shared/components/navigation.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MainCubit()..getProfileInfo(),
        ),
        BlocProvider(create: (context) => SubjectCubit()..getMaterials())
      ],
      child: BlocConsumer<SubjectCubit, SubjectState>(
        listener: (context, state) {
          if (state is SaveMaterialSuccess) {
            showToastMessage(
                message: 'تم عرض الطلب على مسؤول التطبيق وفى انتظار الموافقة  ',
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
        builder: (context, state) {
          var cubit = SubjectCubit.get(context);
          if (MainCubit.get(context).profileModel != null)
            print(MainCubit.get(context).profileModel!.name);
          //   TOKEN = null;
          // MainCubit.get(context).profileModel = null;
          return Scaffold(
            // appBar: AppBar(),

            floatingActionButton: MainCubit.get(context).profileModel == null
                ? null
                : buildFloatingActionButton(),
            key: scaffoldKey,
            backgroundColor: Colors.black,
            body: MainCubit.get(context).profileModel == null
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Stack(
                    children: [
                      backgroundEffects(),
                      MainCubit.get(context).profileModel == null
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Column(
                              children: [
                                const SizedBox(
                                  height: 30,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(bottom: 8.0),
                                  alignment: Alignment.topLeft,
                                  child: MaterialButton(
                                      onPressed: () {
                                        navigatReplace(context, Home());
                                      },
                                      child: const Icon(
                                        Icons.arrow_back,
                                        color: Colors.white,
                                        size: 30,
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, right: 16.0, bottom: 5.0),
                                  child: TextField(
                                    onChanged: (query) {
                                      cubit.runFilter(query: query);
                                    },
                                    style: TextStyle(color: a, fontSize: 20),
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.search,
                                    decoration: InputDecoration(
                                        suffixIcon: Icon(
                                          Icons.search,
                                          size: 30,
                                          color: a,
                                        ),
                                        contentPadding:
                                            const EdgeInsets.all(8.0),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        hintText: 'Search',
                                        hintStyle: const TextStyle(
                                          color: Color.fromRGBO(
                                              255, 255, 255, 0.48),
                                          fontSize: 15,
                                        )),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 20, top: 10, bottom: 10),
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        widget.subjectName,
                                        style: GoogleFonts.montserrat(
                                            color: Colors.white,
                                            fontSize: 30,
                                            fontWeight: FontWeight.w500),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      )),
                                ),

                                // adminTopTitleWithDrawerButton(
                                //     scaffoldKey: scaffoldKey,
                                //     title: widget.subjectName,
                                //     size: 32,
                                //     hasDrawer: true),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: divider(),
                                ),
                                Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0),
                                    decoration: BoxDecoration(
                                        color: const Color.fromRGBO(
                                            217, 217, 217, 0.25),
                                        borderRadius:
                                            BorderRadius.circular(40)),
                                    width: screenWidth(context) / 1.2,
                                    child: customTabBar(
                                        tabController:
                                            _tabControllerOfShowingContent,
                                        title1: 'Videos',
                                        title2: 'Documents')),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Divider(
                                    color: Color.fromRGBO(255, 255, 255, 0.25),
                                  ),
                                ),
                                Expanded(child: customTabBarView()),
                              ],
                            )
                    ],
                  ),
          );
        },
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
    return BlocConsumer<SubjectCubit, SubjectState>(
      builder: (context, state) {
        bool ok = true;
        var cubit = SubjectCubit.get(context);
        var documents = cubit.documents;
        if (cubit.documents != null) print(cubit.documents![1].title);
        return cubit.videos == null || cubit.documents == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : TabBarView(
                controller: _tabControllerOfShowingContent,
                children: [
                  Padding(
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
                                    color: const Color.fromRGBO(
                                        217, 217, 217, 0.1),
                                    borderRadius: BorderRadius.circular(15)),
                                child: gridTileWidget(video: cubit.videos![i]));
                          })),
                  if (documents != null && documents.isNotEmpty)
                    Builder(builder: (context) {
                      if (ok) {
                        print(cubit.documents![1].subject);
                        MainCubit.get(context).getProfileInfo();
                        ok = false;
                        print(cubit.documents![1].subject! + "suusuus");
                      }
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ListView.builder(
                          itemCount: documents!.length,
                          itemBuilder: (context, i) {
                            return documentsCard(document: documents[i]);
                          },
                        ),
                      );
                    })
                  else if (documents == null)
                    Center(child: CircularProgressIndicator())
                  else
                    Center(child: Text("No documents available")),
                ],
              );
      },
      listener: (context, state) {},
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
                      builder: (context) => SizedBox(
                          height: 40, child: removeButton(material: video)),
                      fallback: null)
                  : Container(),
            ],
          ),
        ),

        child: getYouTubeThumbnail(video.link!) != null? Image.network(
          getYouTubeThumbnail(video.link!)!,
          fit: BoxFit.cover,
        ) : Image.network(fit: BoxFit.cover, 'https://www.buffalotech.com/images/made/images/remote/https_i.ytimg.com/vi/06wIw-NdHIw/sddefault_300_225_s.jpg',),
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
                        condition: MainCubit.get(context).profileModel!.role ==
                            'ADMIN',
                        builder: (context) => SizedBox(
                            height: 40,
                            child: removeButton(material: document)),
                        fallback: null)
                    : Container(),
              ],
            ),
          )),
    );
  }

  Widget removeButton({required MaterialModel material}) {
    var cubit = MainCubit.get(context);
    return ElevatedButton(
        onPressed: () {
          cubit.deleteMaterial(material.id!, material.semester);
        },
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
    return BlocConsumer<SubjectCubit, SubjectState>(
      builder: (context, state) => TabBar(
        dividerHeight: 0,
        indicator: const BoxDecoration(),
        controller: tabController,
        tabs: [
          tabForCustomTabBar(title1, cubit.selectedTabIndex == 0),
          tabForCustomTabBar(title2, cubit.selectedTabIndex == 1)
        ],
        onTap: (index) {
          // _tabControllerOfShowingContent.animateTo(index);

          cubit.changeTap(index: index);
        },
      ),
      listener: (context, state) {},
    );
  }

  Widget tabForCustomTabBar(String title, bool isSelected) {
    bool ok = true;
    if (ok) {
      MainCubit.get(context).getProfileInfo();
      ok = false;
    }

    print('$isSelected tabindex $title');
    print(
        "Current selected index: ${SubjectCubit.get(context).selectedTabIndex}");

    return BlocConsumer<SubjectCubit, SubjectState>(
      builder: (context, state) => Tab(
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
      ),
      listener: (context, state) {},
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
    bool ok = true;
    return BlocConsumer<MainCubit, MainCubitStates>(
      listener: (context, state) {},
      builder: (context, state) {
        if (ok) {
          MainCubit.get(context).getProfileInfo();
          ok = false;
        }
        // var cubit = SubjectCubit.get(context);
        if (MainCubit.get(context).profileModel != null)
          print(MainCubit.get(context).profileModel!.email);
        else
          print("null modek ");
        return SingleChildScrollView(
          controller: scrollController,
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: customTextFormField(
                        title: 'Title (e.g:chapter3)',
                        controller: _titleController,
                        keyboardtype: TextInputType.name),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: customTextFormField(
                        title: 'Description (Optional)',
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
                              SubjectCubit.get(context)
                                  .selectedType
                                  .toLowerCase(),
                              style: TextStyle(color: a, fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          PopupMenuButton(
                              onSelected: (type) {
                                SubjectCubit.get(context)
                                    .changeType(type: type);
                              },
                              iconColor: a,
                              itemBuilder: (context) {
                                return [
                                  PopupMenuItem(
                                    value: SubjectCubit.get(context).item1,
                                    child: const Text('Video'),
                                  ),
                                  PopupMenuItem(
                                    value: SubjectCubit.get(context).item2,
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
                                type: SubjectCubit.get(context).selectedType,
                                // subjectName: widget.subjectName,
                                semester: MainCubit.get(context)
                                    .profileModel!
                                    .semester);

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
