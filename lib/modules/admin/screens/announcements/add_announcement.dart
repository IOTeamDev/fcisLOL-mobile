import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:lol/layout/home/bloc/main_cubit_states.dart';
import 'package:lol/layout/home/home.dart';
import 'package:lol/modules/admin/bloc/admin_cubit_states.dart';
import 'package:lol/modules/admin/screens/announcements/announcement_detail.dart';
import 'package:lol/modules/admin/screens/announcements/edit_announcement.dart';
import 'package:lol/shared/components/constants.dart';
import 'package:lol/modules/webview/webview_screen.dart';
import 'package:lol/shared/components/navigation.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:lol/shared/styles/colors.dart';

import '../../../../layout/home/bloc/main_cubit.dart';
import '../../../../main.dart';
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

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _dateController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? dueDateFormatted;
  String? _selectedItem;
  final List<String> _items = ['Assignment', 'Quiz', 'Other'];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdminCubit()
        ..getAnnouncements(widget.semester)
        ..getFcmTokens(),
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
          double width = screenWidth(context);
          double height = screenHeight(context);
          var cubit = AdminCubit.get(context);
          return Scaffold(
            //backgroundColor: HexColor('#23252A'),
            body: Container(
              padding: EdgeInsets.all(5),
              margin: const EdgeInsetsDirectional.only(top: 90),
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //back button
                    Stack(
                      children: [
                        Positioned(
                          left: 0,
                          child: backButton(context),
                        ),
                        Center(
                            child: Text(
                          'Announcements',
                          style: TextStyle(
                            fontSize: width / 13,
                          ),
                          textAlign: TextAlign.center,
                        )),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isExpanded = true; // Toggle the expansion
                          _height = 430;
                        });
                        Future.delayed(const Duration(milliseconds: 350), () {
                          setState(() {
                            _showContent = true;
                          });
                        });
                      },
                      child: AnimatedContainer(
                        margin: const EdgeInsetsDirectional.only(
                            top: 50, start: 10, end: 10),
                        duration: const Duration(milliseconds: 500),
                        width: double.infinity,
                        height: _height,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: isDark
                                ? HexColor('#3B3B3B')
                                : HexColor('#757575')),
                        curve: Curves.fastEaseInToSlowEaseOut,
                        child: _isExpanded && _showContent
                            ? Padding(
                                padding: const EdgeInsetsDirectional.symmetric(
                                    horizontal: 10.0, vertical: 10),
                                child: Form(
                                  key: _formKey,
                                  child: AnimatedOpacity(
                                    opacity: _isExpanded ? 1.0 : 0,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
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
                                                  color: isDark
                                                      ? Colors.grey[400]
                                                      : Colors.grey[100]),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: isDark
                                                              ? HexColor(
                                                                  '#848484')
                                                              : HexColor(
                                                                  '#FFFFFF'))),
                                            ),
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
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
                                                  color: isDark
                                                      ? Colors.grey[400]
                                                      : Colors.grey[100]),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: isDark
                                                              ? HexColor(
                                                                  '#848484')
                                                              : HexColor(
                                                                  '#FFFFFF'))),
                                            ),
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              //DatePicker Input text Field
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () => showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now()
                                                        .add(Duration(days: 1)),
                                                    firstDate: DateTime.now()
                                                        .add(Duration(days: 1)),
                                                    lastDate: DateTime.parse(
                                                        '2027-12-31'),
                                                  ).then((value) {
                                                    if (value != null) {
                                                      //print(DateFormat.YEAR_MONTH_DAY);
                                                      _dateController.text =
                                                          value
                                                              .toUtc()
                                                              .toIso8601String();
                                                      dueDateFormatted =
                                                          _dateController.text;
                                                      _dateController.text =
                                                          DateFormat(
                                                                  'dd/MM/yyyy')
                                                              .format(value);
                                                      print(dueDateFormatted);
                                                      print(
                                                          _dateController.text);
                                                    }
                                                  }),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .symmetric(
                                                                horizontal: 20),
                                                    child: AbsorbPointer(
                                                      child: TextFormField(
                                                        controller:
                                                            _dateController,
                                                        keyboardType:
                                                            TextInputType.none,
                                                        decoration:
                                                            InputDecoration(
                                                          suffixIcon:
                                                              const Icon(
                                                            Icons.date_range,
                                                            color: Colors.black,
                                                          ),
                                                          hintText: 'Due Date',
                                                          hintStyle: TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.black),
                                                          border:
                                                              InputBorder.none,
                                                        ),
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: width / 10,
                                              ),
                                              //Announcement type Drop Down menu
                                              DropdownButton<String>(
                                                hint: const Text(
                                                  'Type',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                value: _selectedItem,
                                                dropdownColor: Colors
                                                    .white, // Background color for the dropdown list
                                                iconEnabledColor: Colors
                                                    .white, // Color of the dropdown icon
                                                style: const TextStyle(
                                                    color: Colors
                                                        .white), // Style for the selected item outside the list
                                                items:
                                                    _items.map((String item) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: item,
                                                    child: Text(
                                                      item,
                                                      style: const TextStyle(
                                                          color: Colors
                                                              .black), // Always black for the list items
                                                    ),
                                                  );
                                                }).toList(),
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    _selectedItem = newValue;
                                                  });
                                                },
                                                selectedItemBuilder:
                                                    (BuildContext context) {
                                                  // Ensuring the selected item has the same padding and alignment as the menu items
                                                  return _items
                                                      .map((String item) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: item,
                                                      child: Text(
                                                        item,
                                                        style: const TextStyle(
                                                          color: Colors
                                                              .white, // White color for the selected item displayed outside
                                                        ),
                                                      ),
                                                    );
                                                  }).toList();
                                                },
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          //Upload Image button
                                          Container(
                                              padding: EdgeInsetsDirectional
                                                  .symmetric(horizontal: 15),
                                              width: width / 2,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: GestureDetector(
                                                onTap: () {
                                                  if (cubit
                                                          .AnnouncementImageFile ==
                                                      null) {
                                                    cubit
                                                        .getAnnouncementImage();
                                                  }
                                                },
                                                child: Row(
                                                  children: [
                                                    ConstrainedBox(
                                                        constraints:
                                                            BoxConstraints(
                                                                maxWidth:
                                                                    width / 4),
                                                        child: Text(
                                                          cubit.imageName,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                        )),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    IconButton(
                                                        icon: Icon(
                                                          cubit.pickerIcon,
                                                          color: Colors.black,
                                                        ),
                                                        onPressed: () {
                                                          if (cubit
                                                                  .AnnouncementImageFile ==
                                                              null) {
                                                            cubit
                                                                .getAnnouncementImage();
                                                            showToastMessage(
                                                              message:
                                                                  'Be careful when You choose image because it cna\'t be changed',
                                                              states:
                                                                  ToastStates
                                                                      .WARNING,
                                                            );
                                                          } else {
                                                            setState(() {
                                                              cubit.AnnouncementImageFile =
                                                                  null;
                                                              cubit.pickerIcon =
                                                                  Icons.image;
                                                              cubit.imageName =
                                                                  'Select Image';
                                                            });
                                                          }
                                                        }),
                                                  ],
                                                ),
                                              )),
                                          const Spacer(),
                                          divider(),
                                          //Cancel and Submit buttons
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .symmetric(
                                                horizontal: 10.0, vertical: 10),
                                            child: Row(
                                              children: [
                                                //cancel button
                                                ElevatedButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      _titleController.clear();
                                                      _dateController.clear();
                                                      _descriptionController
                                                          .clear();
                                                      _isExpanded =
                                                          false; // Toggle the expansion
                                                      _height = 80;
                                                      _showContent = false;
                                                      dueDateFormatted = null;
                                                      cubit.AnnouncementImageFile =
                                                          null;
                                                      cubit.imageName =
                                                          'Select Image';
                                                      cubit.pickerIcon =
                                                          Icons.image;
                                                    });
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        13)),
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .symmetric(
                                                                horizontal:
                                                                    width / 10),
                                                    backgroundColor:
                                                        Colors.white,
                                                    textStyle: TextStyle(
                                                        fontSize: width / 17),
                                                  ),
                                                  child: const Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                                const Spacer(),
                                                //submit button
                                                ElevatedButton(
                                                    onPressed: () async {
                                                      if (_formKey.currentState!
                                                              .validate() 
                                                          ) {
                                                                if(_selectedItem ==
                                                              null)
                                                        showToastMessage(textColor: Colors.black,
                                                            message:
                                                                "Please select the announcement type",
                                                            states: ToastStates
                                                                .WARNING);
else{
                                                        setState(() {
                                                          _isExpanded = false;
                                                          _showContent = false;
                                                          _height = 80;
                                                        });

                                                        print(_selectedItem);
                                                        //print("${MainCubit.get(context).profileModel!.semester}sdsdaffsdkljkjkljkljklhjklhjk00");
                                                        await AdminCubit.get(
                                                                context)
                                                            .UploadPImage(
                                                                image: cubit
                                                                    .AnnouncementImageFile);
                                                        cubit.addAnnouncement(
                                                            title:
                                                                _titleController
                                                                    .text,
                                                            dueDate:
                                                                dueDateFormatted,
                                                            type: _selectedItem,
                                                            description:
                                                                _descriptionController
                                                                    .text,
                                                            image: AdminCubit.get(
                                                                        context)
                                                                    .AnnouncementImagePath ??
                                                                "https://firebasestorage.googleapis.com/v0/b/fcis-da7f4.appspot.com/o/140.jpg?alt=media&token=3e5a4144-20ca-44ce-ba14-57432e49914f",
                                                            currentSemester:
                                                                widget
                                                                    .semester);
                                                        setState(() {
                                                          _titleController
                                                              .clear();
                                                          _descriptionController
                                                              .clear();
                                                          _dateController
                                                              .clear();
                                                          _selectedItem = null;
                                                          dueDateFormatted =
                                                              null;
                                                          cubit.AnnouncementImageFile =
                                                              null;
                                                          cubit.imageName =
                                                              'Select Image';
                                                          cubit.pickerIcon =
                                                              Icons.image;
                                                        });
                                                      }
                                                    }
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          13)),
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .symmetric(
                                                                  horizontal:
                                                                      width /
                                                                          10),
                                                      backgroundColor:
                                                          HexColor('#4764C5'),
                                                      foregroundColor:
                                                          Colors.white,
                                                      textStyle: TextStyle(
                                                          fontSize: width / 17),
                                                    ),
                                                    child:
                                                        const Text('Submit')),
                                              ],
                                            ),
                                          ),
                                        ]),
                                  ),
                                ))
                            : !_isExpanded
                                ? const Padding(
                                    padding: EdgeInsetsDirectional.symmetric(
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
                      condition: state is! AdminGetAnnouncementLoadingState &&
                          cubit.announcements != null &&
                          cubit.announcements!.isNotEmpty,
                      builder: (context) => ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => announcementBuilder(
                            widget.semester,
                            cubit.announcements![index].id.toString(),
                            context,
                            cubit.announcements![index].title,
                            index,
                            cubit.announcements![index].content,
                            cubit.announcements![index].dueDate,
                            cubit.announcements![index].type),
                        separatorBuilder: (context, index) => const SizedBox(
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
          );
        },
      ),
    );
  }

  Widget announcementBuilder(semester, String cubitId, context, title, ID,
      content, date, selectedItem) {
    var cubit = AdminCubit.get(context).announcements![ID];
    return GestureDetector(
      onTap: () {
        navigate(
            context,
            AnnouncementDetail(
              semester: semester,
              title: cubit.title,
              description: cubit.content,
              date: cubit.dueDate,
              id: ID,
              selectedType: cubit.type,
            ));
      },
      child: Container(
        margin: const EdgeInsetsDirectional.symmetric(horizontal: 10),
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
        height: 80,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: HexColor('#4764C5')),
        child: Row(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: screenWidth(context) - 150),
              child: Text(
                title,
                style: const TextStyle(fontSize: 18, color: Colors.white),
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
                      builder: (context) => EditAnnouncement(
                            semester: semester,
                            title: cubit.title,
                            content: cubit.content,
                            date: cubit.dueDate,
                            id: ID.toString(),
                            selectedItem: cubit.type,
                            imageLink: cubit.image,
                          )),
                );

                if (Refresh == 'refresh') {
                  AdminCubit.get(context).getAnnouncements(semester);
                }
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: Colors.white,
              minWidth: 10,
              padding: const EdgeInsets.all(6),
              child: const Icon(
                Icons.edit_outlined,
                color: Colors.black,
              ), // Padding for icon
            ),
            //Delete Icon
            MaterialButton(
              onPressed: () {
                AdminCubit.get(context).deleteAnnouncement(cubit.id, semester);
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              minWidth: 10,
              color: Colors.white,
              padding: const EdgeInsets.all(6),
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
