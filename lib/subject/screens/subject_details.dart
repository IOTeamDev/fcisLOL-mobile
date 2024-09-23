import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/constants/colors.dart';
import 'package:lol/constants/constants.dart';
import 'package:lol/subject/cubit/subject_cubit.dart';
import 'package:lol/subject/model/subject_model.dart';
import 'package:lol/shared/components/components.dart';

class SubjectDetails extends StatefulWidget {
  const SubjectDetails({super.key});

  @override
  State<SubjectDetails> createState() => _MaterialDetailsState();
}

class _MaterialDetailsState extends State<SubjectDetails>
    with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  late TabController _tabControllerOfShowingContent;
  late TabController _tabControllerOfAddingContent;

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _linkController = TextEditingController();

  @override
  void initState() {
    _tabControllerOfShowingContent = TabController(length: 2, vsync: this);
    _tabControllerOfAddingContent = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Expanded(
                  child: customTabBarView(
                      tabController: _tabControllerOfShowingContent))
            ],
          )
        ],
      ),
    );
  }

  Widget buildFloatingActionButton() {
    return SizedBox(
      height: 70,
      width: 70,
      child: FloatingActionButton(
        onPressed: () {
          _titleController.text = '';
          _descriptionController.text = '';
          _linkController.text = '';
          showModalBottomSheet(
              backgroundColor: const Color.fromRGBO(25, 25, 25, 1),
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) => buildBottomSheet());
        },
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        backgroundColor: additional2,
        child: Icon(
          Icons.add,
          color: a,
          size: 40,
        ),
      ),
    );
  }

  Widget customTabBarView({required TabController tabController}) {
    var cubit = SubjectCubit.get(context);
    return TabBarView(
      controller: tabController,
      children: [
        BlocBuilder<SubjectCubit, SubjectState>(
          builder: (context, state) {
            return ConditionalBuilder
            (
              condition: state is! GetMaterialLoading && cubit.documents!.isNotEmpty  && cubit.documents != null,
              builder: (context) {

                return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GridView.builder(
                        itemCount: cubit.videos!.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                        }
                    )
                );
              },
              fallback: (context) {
                if(state is GetMaterialLoading) {
                  return const Center(child: CircularProgressIndicator(),);
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
              condition: state is! GetMaterialLoading && cubit.videos != null && cubit.videos!.isNotEmpty,
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
                if(state is GetMaterialLoading){
                  return const Center(child: CircularProgressIndicator(),);
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

  Widget gridTileWidget({required SubjectModel video}) {
    return GridTile(
      footer: Container(
        padding: const EdgeInsets.all(5),
        color: Colors.black,
        child: Row(
          children: [
            Text(
              '${video.title}',
              style: TextStyle(
                fontSize: screenWidth(context) / 20,
                color: a,
              ),
            ),
            const Spacer(),
            editAndRemoveButtons()
          ],
        ),
      ),
      child: Image.network(
        getYouTubeThumbnail(video.link!),
        fit: BoxFit.cover,
      ),
    );
  }

  Widget documentsCard({required SubjectModel document}) {
    return Card(
      color: const Color.fromRGBO(217, 217, 217, 0.25),
      child: ListTile(
        leading: Icon(
          Icons.folder_outlined,
          size: 50,
          color: a,
        ),
        title: Text(
          document.title ?? 'No Title',
          style: TextStyle(color: a, fontSize: 20),
        ),
        subtitle: Text(
          document.description ?? '',
          style: TextStyle(color: a, fontSize: 15),
        ),
        trailing: editAndRemoveButtons(),
        onTap: () {},
      ),
    );
  }

  Widget editAndRemoveButtons() {
    return SizedBox(
      width: screenWidth(context) / 4,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.edit,
                color: Colors.red,
              )),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ))
        ],
      ),
    );
  }

  Widget customTabBar(
      {required TabController tabController,
      required String title1,
      required String title2}) {
    return TabBar(
      onTap: (value) {
        setState(() {});
      },
      dividerHeight: 0,
      indicator: const BoxDecoration(),
      controller: tabController,
      tabs: [
        tabForCustomTabBar(title1, tabController, 0),
        tabForCustomTabBar(title2, tabController, 1)
      ],
    );
  }

  Widget tabForCustomTabBar(
      String title, TabController tabController, int index) {
    return Tab(
      child: Container(
        width: double.infinity,
        // padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: tabController.index == index ? additional2 : null,
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
      {required String title, required TextEditingController controller}) {
    return TextFormField(
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
    return Container(
        margin: const EdgeInsets.all(20),
        height: screenHeight(context) / 2,
        width: screenWidth(context),
        child: addingMaterialForm());
  }

  Widget addingMaterialForm() {
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: customTextFormField(
                    title: 'Title', controller: _titleController),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: customTextFormField(
                    title: 'Description(e.g:chapter3)',
                    controller: _descriptionController),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: customTextFormField(
                    title: 'Link', controller: _linkController),
              ),
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(217, 217, 217, 0.25),
                      borderRadius: BorderRadius.circular(40)),
                  width: screenWidth(context) / 1.2,
                  child: customTabBar(
                      tabController: _tabControllerOfAddingContent,
                      title1: 'Video',
                      title2: 'Document')),
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
                        String selectedType =
                            _tabControllerOfAddingContent.index == 0
                                ? 'VIDEO'
                                : 'DOCUMENT';
                        BlocProvider.of<SubjectCubit>(context).addMaterial(
                            title: _titleController.text,
                            description: _descriptionController.text,
                            link: _linkController.text,
                            type: selectedType);

                        BlocListener<SubjectCubit, SubjectState>(
                          listener: (context, state) {
                            if (state is SaveMaterialSuccess) {
                              showToastMessage(
                                  message:
                                      'تم عرض الطلب على مسؤول التطبيق وفى انتظار المرافقة  ',
                                  states: ToastStates.SUCCESS);
                            } else if (state is SaveMaterialError) {
                              showToastMessage(
                                  message: 'error while uploading file',
                                  states: ToastStates.ERROR);
                            }
                          },
                        );
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
          ),
        ));
  }
}
