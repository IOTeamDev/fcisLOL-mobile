import 'package:flutter/material.dart';
import 'package:lol/constants/colors.dart';
import 'package:lol/constants/constants.dart';
import 'package:lol/shared/components/components.dart';

class MaterialDetails extends StatefulWidget {
  const MaterialDetails({super.key});

  @override
  State<MaterialDetails> createState() => _MaterialDetailsState();
}

class _MaterialDetailsState extends State<MaterialDetails>
    with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  late TabController _tabControllerOfShowingContent;
  late TabController __tabControllerOfAddingContent;

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _linkController = TextEditingController();

  @override
  void initState() {
    _tabControllerOfShowingContent = TabController(length: 2, vsync: this);
    __tabControllerOfAddingContent = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SizedBox(
        height: 70,
        width: 70,
        child: FloatingActionButton(
          onPressed: () {
            _titleController.text = '';
            _descriptionController.text = '';
            _linkController.text = '';
            scaffoldKey.currentState!.showBottomSheet(
                backgroundColor: const Color.fromRGBO(25, 25, 25, 1),
                (context) => customBottomSheet());
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
      ),
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

  Widget customTabBarView({required TabController tabController}) {
    return TabBarView(
      controller: tabController,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.separated(
            itemCount: 10,
            separatorBuilder: (context, i) => const SizedBox(
              height: 30,
            ),
            itemBuilder: (context, i) {
              return Container(
                padding: const EdgeInsets.all(8),
                width: screenWidth(context),
                height: screenHeight(context) / 4,
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(217, 217, 217, 0.25),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'images/electronics.png',
                      height: screenHeight(context) / 5,
                      width: double.infinity,
                      fit: BoxFit.fill,
                    ),
                    Expanded(
                      child: Text(
                        'Chapter or lecture name',
                        style: TextStyle(
                          fontSize: screenWidth(context) / 20,
                          color: a,
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.separated(
            itemCount: 10,
            separatorBuilder: (context, i) => const SizedBox(
              height: 10,
            ),
            itemBuilder: (context, i) {
              return GestureDetector(
                onTap: () {},
                child: Container(
                    padding: const EdgeInsets.all(8),
                    width: screenWidth(context),
                    height: screenHeight(context) / 10,
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(217, 217, 217, 0.25),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        Icon(
                          Icons.folder_outlined,
                          size: 50,
                          color: a,
                        ),
                        const Spacer(),
                        Text(
                          'chapter ${i + 1}',
                          style: TextStyle(
                              color: a, fontSize: screenWidth(context) / 15),
                        ),
                        const Spacer(
                          flex: 4,
                        )
                      ],
                    )),
              );
            },
          ),
        ),
      ],
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
        Tab(
          child: Container(
            width: double.infinity,
            // padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: tabController.index == 0 ? additional2 : null,
            ),
            child: Center(
              child: Text(
                title1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: a, fontSize: 20),
              ),
            ),
          ),
        ),
        Tab(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            // padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: tabController.index == 1 ? additional2 : null,
            ),
            child: Center(
              child: Text(
                title2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: a, fontSize: 20),
              ),
            ),
          ),
        ),
      ],
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

  Widget customBottomSheet() {
    return Container(
      margin: const EdgeInsets.all(20),
      height: screenHeight(context) / 2,
      width: screenWidth(context),
      child: Form(
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
                        tabController: __tabControllerOfAddingContent,
                        title1: 'Video',
                        title2: 'Document')),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
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
                    MaterialButton(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      minWidth: screenWidth(context) / 3,
                      shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                      color: additional2,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          print('will do something here');
                          Future.delayed(
                              const Duration(seconds: 1, milliseconds: 100),
                              () {
                            showToastMessage(
                                message: 'Material Added successfully',
                                states: ToastStates.SUCCESS);
                          });
                          setState(() {
                            Navigator.of(context).pop();
                          });
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
          )),
    );
  }
}
