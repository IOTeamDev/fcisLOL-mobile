import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:lol/features/home/presentation/view_model/main_cubit/main_cubit.dart';
import 'package:lol/features/home/presentation/view_model/main_cubit/main_cubit_states.dart';
import 'package:lol/main.dart';
import 'package:lol/modules/admin/bloc/admin_cubit_states.dart';

import 'package:lol/shared/components/constants.dart';
import 'package:lol/shared/components/components.dart';
import '../../bloc/admin_cubit.dart';

class EditAnnouncement extends StatefulWidget {
  final int id;
  final String semester;
  final String title;
  final String content;
  final String date;
  final int index;
  //final String? selectedItem;
  final String? imageLink;

  const EditAnnouncement({
    super.key,
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    //this.selectedItem,
    required this.semester,
    this.imageLink,
    required this.index,
  });

  @override
  _EditAnnouncementState createState() => _EditAnnouncementState();
}

class _EditAnnouncementState extends State<EditAnnouncement> {
  // String? selectedItem;
  // final List<String> _items = ['Quiz', 'Assignment', 'Other'];

  late TextEditingController titleController;
  late TextEditingController contentController;
  late TextEditingController _dateController;
  late int id;
  String? dueDateFormatted;

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing values
    titleController = TextEditingController(text: widget.title);
    contentController = TextEditingController(text: widget.content);
    _dateController = TextEditingController(
        text: widget.date == 'No Due Date'
            ? 'Due Date'
            : DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.date)));
    //selectedItem = widget.selectedItem;
    id = widget.id;
    print('date controller: ${_dateController.text}');
    print('widget date: ${widget.date}');
    dueDateFormatted = widget.date;
    print('due Date: $dueDateFormatted');
  }

  @override
  void dispose() {
    // Dispose controllers when not needed
    titleController.dispose();
    contentController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => MainCubit()
              ..getProfileInfo()
              ..getAnnouncements(widget.semester)),
      ],
      child: BlocConsumer<MainCubit, MainCubitStates>(
        listener: (context, state) {
          // if(state is GetProfileSuccess)
          // {
          //   if(widget.imageLink != null)
          //   {
          //     MainCubit.get(context).imageName = 'Select Image';
          //     MainCubit.get(context).pickerIcon = Icons.clear;
          //   }
          //   else
          //   {
          //     MainCubit.get(context).imageName = 'Select Image';
          //     MainCubit.get(context).pickerIcon = Icons.image;
          //   }
          //   print(MainCubit.get(context).imageName);
          // }
          if (state is UpdateAnnouncementsSuccessState) {
            showToastMessage(
                message: 'Announcement Updated Successfully!!',
                states: ToastStates.SUCCESS);
            Navigator.pop(context, 'refresh');
          }
        },
        builder: (context, state) {
          double width = screenWidth(context);
          double height = screenHeight(context);
          var cubit = MainCubit.get(context);
          return Scaffold(
            //backgroundColor: HexColor('#23252A'),
            body: Container(
              margin:
                  EdgeInsetsDirectional.only(top: screenHeight(context) / 10),
              width: double.infinity,
              child: ConditionalBuilder(
                condition: MainCubit.get(context).profileModel != null &&
                    state is! AdminGetAnnouncementLoadingState,
                builder: (context) => SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back Button
                      Stack(
                        children: [
                          Positioned(
                            left: 0,
                            child: backButton(context),
                          ),
                          Center(
                              child: Text(
                            'Edit',
                            style: TextStyle(
                              fontSize: width / 10,
                            ),
                            textAlign: TextAlign.center,
                          )),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsetsDirectional.symmetric(
                            horizontal: 15, vertical: 20),
                        padding: const EdgeInsets.all(15),
                        height: screenHeight(context) / 1.45,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: isDark
                                ? HexColor('#3B3B3B')
                                : HexColor('#757575'),
                            borderRadius: BorderRadius.circular(20)),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title Text Input
                              TextFormField(
                                controller: titleController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Title must not be empty';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: 'Title',
                                  hintStyle: TextStyle(
                                      fontSize: 20, color: Colors.grey[400]),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: isDark
                                              ? HexColor('#848484')
                                              : HexColor('#FFFFFF'))),
                                ),
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 10),
                              // Description Text Input
                              TextFormField(
                                controller: contentController,
                                minLines: 5,
                                maxLines: 12,
                                decoration: InputDecoration(
                                  hintText: 'Description',
                                  hintStyle: TextStyle(
                                      fontSize: 20, color: Colors.grey[400]),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: isDark
                                              ? HexColor('#848484')
                                              : HexColor('#FFFFFF'))),
                                ),
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  // DatePicker Text Field
                                  GestureDetector(
                                    onTap: () => showDatePicker(
                                      context: context,
                                      initialDate:
                                          DateTime.now().add(Duration(days: 1)),
                                      firstDate:
                                          DateTime.now().add(Duration(days: 1)),
                                      lastDate: DateTime.parse('2027-11-30'),
                                    ).then((value) {
                                      if (value != null) {
                                        //print(DateFormat.YEAR_MONTH_DAY);
                                        setState(() {
                                          DateTime selectedDate = DateTime(
                                              value.year,
                                              value.month,
                                              value.day);
                                          dueDateFormatted = DateTime.utc(
                                                  selectedDate.year,
                                                  selectedDate.month,
                                                  selectedDate.day)
                                              .toIso8601String();
                                          print(dueDateFormatted);
                                          _dateController.text =
                                              DateFormat('dd/MM/yyyy')
                                                  .format(value);
                                        });
                                        // print(dueDateFormatted);
                                        // print(_dateController.text);
                                      }
                                    }),
                                    child: Container(
                                      width: width / 2.2,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      padding: EdgeInsetsDirectional.symmetric(
                                          horizontal: 10),
                                      child: AbsorbPointer(
                                        child: TextFormField(
                                          onTap: () {},
                                          controller: _dateController,
                                          keyboardType: TextInputType.none,
                                          decoration: InputDecoration(
                                            suffixIcon: Icon(
                                              Icons.date_range,
                                              color: Colors.black,
                                            ),
                                            hintText: 'Due Date',
                                            hintStyle: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black),
                                            border: InputBorder.none,
                                          ),
                                          style: TextStyle(
                                            color: Colors.black,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          maxLines: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Announcement Type Dropdown
                                  // DropdownButton<String>(
                                  //   hint: const Text(
                                  //     'Type',
                                  //     style: TextStyle(color: Colors.white),
                                  //   ),
                                  //   value: selectedItem,
                                  //   dropdownColor: Colors.white,
                                  //   iconEnabledColor: Colors.white,
                                  //   style: const TextStyle(color: Colors.white),
                                  //   items: _items.map((String item) {
                                  //     return DropdownMenuItem<String>(
                                  //       value: item,
                                  //       child: Text(
                                  //         item,
                                  //         style: const TextStyle(
                                  //             color: Colors.black),
                                  //       ),
                                  //     );
                                  //   }).toList(),
                                  //   onChanged: (String? newValue) {
                                  //     setState(() {
                                  //       selectedItem = newValue;
                                  //     });
                                  //   },
                                  //   selectedItemBuilder:
                                  //       (BuildContext context) {
                                  //     // Ensuring the selected item has the same padding and alignment as the menu items
                                  //     return _items.map((String item) {
                                  //       return DropdownMenuItem<String>(
                                  //         value: item,
                                  //         child: Text(
                                  //           item,
                                  //           style: const TextStyle(
                                  //             color: Colors
                                  //                 .white, // White color for the selected item displayed outside
                                  //           ),
                                  //         ),
                                  //       );
                                  //     }).toList();
                                  //   },
                                  // ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              //Upload Image button
                              // Container(
                              //     padding: EdgeInsetsDirectional.symmetric(horizontal: 15),
                              //     width: width / 2.1,
                              //     height: 50,
                              //     decoration: BoxDecoration(
                              //       color: Colors.white,
                              //       borderRadius: BorderRadius.circular(10),
                              //     ),
                              //     child: GestureDetector(
                              //       onTap: () {
                              //         if (cubit.AnnouncementImageFile == null) {
                              //           cubit.getAnnouncementImage();
                              //         }
                              //       },
                              //       child: Row(
                              //             children: [
                              //               ConstrainedBox(
                              //                   constraints: BoxConstraints(maxWidth: width / 4),
                              //                   child: Text(
                              //                     cubit.imageName!,
                              //                     style: TextStyle(color: Colors.black),
                              //                     overflow: TextOverflow.ellipsis,
                              //                     maxLines: 1,
                              //                   )),
                              //               SizedBox(
                              //                 width: 5,
                              //               ),
                              //               IconButton(
                              //                   icon: Icon(
                              //                     cubit.pickerIcon,
                              //                     color: Colors.black,
                              //                   ),
                              //                   onPressed: () {
                              //                     if (cubit.AnnouncementImageFile == null && widget.imageLink == null) {
                              //                       cubit.getAnnouncementImage();
                              //                     } else {
                              //                       setState(() {
                              //                         cubit.AnnouncementImageFile = null;
                              //                         cubit.pickerIcon = Icons.image;
                              //                         cubit.imageName = 'Select Image';
                              //                       });
                              //                     }
                              //                   }),
                              //             ],
                              //           ),
                              //     )
                              // ),
                              // SizedBox(height: 10,),
                              // ConstrainedBox(
                              //   constraints: BoxConstraints(maxWidth: width/1.1),
                              //   child: Text('keep it if you don\'t to change the photo!!', style: TextStyle(color: Colors.grey[400]),)
                              // ),
                              const Spacer(),
                              divider(),
                              // Cancel and Accept Buttons
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context, 'nigga');
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(13)),
                                        padding:
                                            EdgeInsetsDirectional.symmetric(
                                                horizontal: width / 11),
                                        backgroundColor: Colors.white,
                                        textStyle:
                                            TextStyle(fontSize: width / 17),
                                      ),
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                    const Spacer(),
                                    ElevatedButton(
                                        onPressed: () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            //print(dueDateFormatted);
                                            // await cubit.UploadPImage(isUserProfile: false, image: cubit.AnnouncementImageFile);
                                            cubit.updateAnnouncement(
                                              id,
                                              title: titleController.text,
                                              content: contentController.text,
                                              dueDate: dueDateFormatted ==
                                                      'No Due Date'
                                                  ? null
                                                  : dueDateFormatted,
                                              //type: selectedItem!,
                                              // image: cubit.AnnouncementImagePath??widget.imageLink??'',
                                              //currentSemester: widget.semester
                                            );
                                          } else {
                                            // Show error if validation fails
                                            showToastMessage(
                                              message:
                                                  'Please fill all fields correctly.',
                                              states: ToastStates.ERROR,
                                            );
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(13)),
                                          padding:
                                              EdgeInsetsDirectional.symmetric(
                                                  horizontal: width / 11),
                                          backgroundColor:
                                              Color.fromARGB(255, 20, 130, 220),
                                          foregroundColor: Colors.white,
                                          textStyle:
                                              TextStyle(fontSize: width / 17),
                                        ),
                                        child: const Text('Submit')),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                fallback: (context) => const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
