import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:lol/layout/home/home.dart';
import 'package:lol/modules/admin/bloc/admin_cubit_states.dart';
import 'package:lol/modules/admin/screens/announcements/announcement_detail.dart';
import 'package:lol/modules/admin/screens/announcements/edit_announcement.dart';
import 'package:lol/shared/components/constants.dart';
import 'package:lol/modules/webview/webview_screen.dart';
import 'package:lol/shared/components/navigation.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

import '../../../../layout/home/bloc/main_cubit.dart';
import '../../../../shared/components/components.dart';
import '../../bloc/admin_cubit.dart';

class AddAnnouncement extends StatefulWidget {
  final String semester;
  const AddAnnouncement({super.key, required this.semester});

  @override
  State<AddAnnouncement> createState() => _AddAnnouncementState();
}

class _AddAnnouncementState extends State<AddAnnouncement> {
  double _height = 80;
  bool _isExpanded = false;
  bool _showContent = false;

  var _formKey = GlobalKey<FormState>();
  var _titleController = TextEditingController();
  var _dateController = TextEditingController();
  var _descriptionController = TextEditingController();
  String? _selectedItem;
  final List<String> _items = ['Assignment', 'Quiz', 'Other'];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MainCubit()..getProfileInfo(),
        ),
        BlocProvider(
          create: (context) => AdminCubit()..getAnnouncements(widget.semester),
        ),
      ],
      child: BlocConsumer<AdminCubit, AdminCubitStates>(
        listener: (context, state) {
          if (state is AdminSaveAnnouncementSuccessState) {
            showToastMessage(
                message: 'Announcement Added Successfully',
                states: ToastStates.SUCCESS);
          } else if (state is AdminSaveAnnouncementsErrorState) {
            showToastMessage(
                message: 'An Error Occurred: ${state.error}',
                states: ToastStates.ERROR);
          }

          if (state is AdminDeleteAnnouncementSuccessState) {
            showToastMessage(
                message: 'Announcement Deleted', states: ToastStates.WARNING);
          }
          if (state is AdminDeleteAnnouncementErrorState) {
            showToastMessage(
                message: 'Error Occurred: ${state.error}',
                states: ToastStates.ERROR);
          }
        },
        builder: (context, state) {
          var mainCubit = MainCubit.get(context);
          var cubit = AdminCubit.get(context);
          return Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                backgroundEffects(),
                Container(
                  margin: const EdgeInsetsDirectional.only(top: 50),
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        //back button
                        backButton(context),
                        adminTopTitleWithDrawerButton(
                            title: 'Announcements', size: 32, hasDrawer: false),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isExpanded = true; // Toggle the expansion
                              _height = 450;
                            });
                            Future.delayed(const Duration(milliseconds: 350),
                                () {
                              setState(() {
                                _showContent = true;
                              });
                            });
                          },
                          child: AnimatedContainer(
                            margin: const EdgeInsetsDirectional.symmetric(
                                vertical: 20, horizontal: 10),
                            duration: const Duration(milliseconds: 500),
                            width: double.infinity,
                            height: _height,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: HexColor('B8A8F9').withOpacity(0.20)),
                            curve: Curves.fastEaseInToSlowEaseOut,
                            child: _isExpanded && _showContent
                                ? Padding(
                                    padding:
                                        const EdgeInsetsDirectional.symmetric(
                                            horizontal: 10.0, vertical: 10),
                                    child: Form(
                                      key: _formKey,
                                      child: AnimatedOpacity(
                                        opacity: _isExpanded ? 1.0 : 0,
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.easeInOut,
                                        child: Column(children: [
                                          //Title Text Input
                                          TextFormField(
                                            controller: _titleController,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'This field must not be Empty';
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              hintText: 'Title',
                                              hintStyle: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.grey[400]),
                                              border: InputBorder.none,
                                            ),
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          divider(),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          //Description Input text Field
                                          TextFormField(
                                            controller: _descriptionController,
                                            minLines: 5,
                                            maxLines: 5,
                                            decoration: InputDecoration(
                                              hintText: 'Description',
                                              hintStyle: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.grey[400]),
                                              border: InputBorder.none,
                                            ),
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          divider(),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              //DatePicker Input text Field
                                              Expanded(
                                                child: TextFormField(
                                                  controller: _dateController,
                                                  keyboardType:
                                                      TextInputType.none,
                                                  onTap: () => showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime.now(),
                                                    lastDate: DateTime.parse('2027-12-31'),
                                                  ).then((value) {
                                                    if (value != null) {
                                                      //print(DateFormat.YEAR_MONTH_DAY);
                                                      _dateController.text = value.toUtc().toIso8601String();
                                                    }
                                                  }),
                                                  decoration: InputDecoration(
                                                    suffixIcon: const Icon(
                                                      Icons.date_range,
                                                      color: Colors.grey,
                                                    ),
                                                    hintText: 'Due Date',
                                                    hintStyle: TextStyle(
                                                        fontSize: 16,
                                                        color:
                                                            Colors.grey[400]),
                                                    border: InputBorder.none,
                                                  ),
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              //Announcement type Drop Down menu
                                              DropdownButton<String>(
                                                hint: const Text(
                                                  'Type',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                style: const TextStyle(
                                                    color: Colors.white),
                                                dropdownColor: Colors.black,
                                                value: _selectedItem,
                                                items:
                                                    _items.map((String item) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: item,
                                                    child: Text(
                                                      item,
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  );
                                                }).toList(),
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    _selectedItem = newValue;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                          //Upload Image button
                                          IconButton(
                                            onPressed: () {
                                              mainCubit.getAnnouncementImage();
                                            },
                                            icon: Icon(
                                              Icons.image,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const Spacer(),
                                          divider(),
                                          //Cancel and Submit buttons
                                          Padding(
                                            padding: const EdgeInsetsDirectional.symmetric(horizontal: 10.0, vertical: 10),
                                            child: Row(
                                              children: [
                                                //cancel button
                                                ElevatedButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      _titleController.clear();
                                                      _dateController.clear();
                                                      _descriptionController.clear();
                                                      _isExpanded = false; // Toggle the expansion
                                                      _height = 80;
                                                      _showContent = false;
                                                    });
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    padding:
                                                        const EdgeInsetsDirectional.symmetric(horizontal: 35),
                                                    backgroundColor:
                                                        HexColor('D9D9D9')
                                                            .withOpacity(0.2),
                                                    foregroundColor:
                                                        Colors.white,
                                                    textStyle: const TextStyle(
                                                        fontSize: 15),
                                                  ),
                                                  child: const Text('Cancel'),
                                                ),
                                                const Spacer(),
                                                //submit button
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    if (_formKey.currentState!.validate() && _selectedItem != null) {
                                                      setState(() {
                                                        _isExpanded = false;
                                                        _titleController.clear();
                                                        _descriptionController.clear();
                                                        _dateController.clear();
                                                        _showContent = false;
                                                        _selectedItem = null;
                                                        _height = 80;
                                                      });
                                                      await MainCubit.get(context).UploadPImage(image: MainCubit.get(context).AnnouncementImageFile, isUserProfile: false);
                                                      cubit.addAnnouncement(
                                                        title: _titleController.text,
                                                        dueDate: _dateController.text,
                                                        type: _selectedItem,
                                                        description: _descriptionController.text,
                                                        image: MainCubit.get(context).AnnouncementImagePath,
                                                        currentSemester: MainCubit.get(context).profileModel!.semester
                                                      );
                                                    }
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    padding: const EdgeInsetsDirectional.symmetric(horizontal: 40),
                                                    backgroundColor: HexColor('B8A8F9'),
                                                    foregroundColor: Colors.white,
                                                    textStyle: const TextStyle(fontSize: 15),
                                                  ),
                                                  child: const Text('Submit')
                                                ),
                                              ],
                                            ),
                                          ),
                                        ]),
                                      ),
                                    ))
                                : !_isExpanded
                                    ? const Padding(
                                        padding:
                                            EdgeInsetsDirectional.symmetric(
                                                vertical: 10, horizontal: 15),
                                        child: Row(
                                          children: [
                                            Text(
                                              'Add New',
                                              style: TextStyle(
                                                  fontSize: 30,
                                                  color: Colors.white),
                                            ),
                                            Spacer(),
                                            Icon(
                                              Icons.add,
                                              color: Colors.white,
                                              size: 40,
                                            ),
                                          ],
                                        ),
                                      )
                                    : null,
                          ),
                        ),
                        ConditionalBuilder(
                          condition:
                              state is! AdminGetAnnouncementLoadingState &&
                                  cubit.announcements != null &&
                                  cubit.announcements!.isNotEmpty,
                          builder: (context) => ListView.separated(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) =>
                                announcementBuilder(
                                  widget.semester,
                                    cubit.announcements![index].id.toString(),
                                    context,
                                    cubit.announcements![index].title,
                                    index,
                                    cubit.announcements![index].content,
                                    cubit.announcements![index].dueDate,
                                    cubit.announcements![index].type),
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              height: 10,
                            ),
                            itemCount: cubit.announcements!.length,
                          ),
                          fallback: (context) {
                            if (state is AdminGetAnnouncementLoadingState) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else {
                              return const Center(
                                child: Text(
                                  'You have no announcements yet!!!',
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget announcementBuilder(semester,
      String cubitId, context, title, ID, content, date, selectedItem) {
    var cubit = AdminCubit.get(context).announcements![ID];
    return GestureDetector(
      onTap: () async {
        String refresh = await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AnnouncementDetail(semester: semester,
            title: cubit.title!,
            description: cubit.content,
            date: cubit.dueDate,
            id: ID,
            selectedType: cubit.type,
          ),
        ));

        if (refresh == 'refresh') {
          AdminCubit.get(context).getAnnouncements(semester);
        }
      },
      child: Container(
        margin: const EdgeInsetsDirectional.symmetric(horizontal: 10),
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
        height: 80,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: HexColor('B8A8F9')),
        child: Row(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: screenWidth(context) - 140),
              child: Text(
                '$title',
                style: const TextStyle(fontSize: 20, color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Spacer(),
            //Edit button
            MaterialButton(
              onPressed: () async {
                print(cubit.id);
                String Refresh = await Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => EditAnnouncement(semester: semester,
                            title: cubit.title!,
                            content: cubit.content,
                            date: cubit.dueDate,
                            id: ID.toString(),
                            selectedItem: cubit.type,
                          )),
                );

                if (Refresh == 'refresh') {
                  AdminCubit.get(context).getAnnouncements(semester);
                }
              },
              shape: const CircleBorder(),
              minWidth: 0,
              padding: const EdgeInsets.all(5),
              child: const Icon(
                Icons.edit,
                color: Colors.green,
              ), // Padding for icon
            ),
            //Delete Icon
            MaterialButton(
              onPressed: () {
                AdminCubit.get(context).deleteAnnouncement(cubit.id,semester);
              },
              shape: const CircleBorder(),
              minWidth: 0,
              padding: const EdgeInsets.all(5),
              child: const Icon(
                Icons.delete_sharp,
                color: Colors.red,
              ), // Padding for icon
            ),
          ],
        ),
      ),
    );
  }
}
