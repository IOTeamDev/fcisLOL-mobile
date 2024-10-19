import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:lol/layout/home/bloc/main_cubit.dart';
import 'package:lol/layout/home/bloc/main_cubit_states.dart';
import 'package:lol/modules/admin/bloc/admin_cubit_states.dart';

import 'package:lol/shared/components/constants.dart';
import 'package:lol/shared/components/components.dart';
import '../../bloc/admin_cubit.dart';

class EditAnnouncement extends StatefulWidget {
  final String id;
  final String semester;
  final String title;
  final String content;
  final String date;
  final String? selectedItem;
  final String? imageName;
  final String? imageLink;

  const EditAnnouncement({
    super.key,
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    this.selectedItem,
    required this.semester,
    this.imageName,
    this.imageLink,
  });

  @override
  _EditAnnouncementState createState() => _EditAnnouncementState();
}

class _EditAnnouncementState extends State<EditAnnouncement> {
  String? selectedItem;
  final List<String> _items = ['Quiz', 'Assignment', 'Other'];

  late TextEditingController titleController;
  late TextEditingController contentController;
  late TextEditingController _dateController;
  late String id;
  String? dueDateFormatted;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing values
    titleController = TextEditingController(text: widget.title);
    contentController = TextEditingController(text: widget.content);
    _dateController = TextEditingController(text: widget.date == 'No Due Date'? 'Due Date': widget.date );
    selectedItem = widget.selectedItem;
    id = widget.id;
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
        BlocProvider(create: (context) => MainCubit()..getProfileInfo()..getAnnouncements(widget.semester)),
      ],
      child: BlocConsumer<MainCubit, MainCubitStates>(
        listener: (context, state) {
          if(state is GetAnnouncementImageSuccess)
            {
              setState(() {
                MainCubit.get(context).imageName = 'Select Image';
                MainCubit.get(context).AnnouncementImageFile = null;
                MainCubit.get(context).pickerIcon = Icons.image;
              });
            }
          if (state is AdminUpdateAnnouncementSuccessState) {
            showToastMessage(
                message: 'Material Updated Successfully!!',
                states: ToastStates.SUCCESS);
            Navigator.pop(context, 'refresh');
          }
        },
        builder: (context, state) {
          double width = screenWidth(context);
          double height = screenHeight(context);
          var cubit = MainCubit.get(context);
          return Scaffold(
            backgroundColor: HexColor('#23252A'),
            body: Container(
              margin: const EdgeInsetsDirectional.only(top: 90),
              width: double.infinity,
              child: ConditionalBuilder(
                condition: MainCubit.get(context).profileModel != null && state is! AdminGetAnnouncementLoadingState,
                builder: (context) => SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back Button
                      Stack(
                        children: [
                          Positioned(child: backButton(context), left: 0,),
                          Center(child: Text('Edit' , style: TextStyle(fontSize: width/10, color: Colors.white), textAlign: TextAlign.center,)),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsetsDirectional.symmetric(horizontal: 15, vertical: 20),
                        padding: const EdgeInsets.all(15),
                        height: screenHeight(context) / 1.45,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: HexColor('#3B3B3B'),
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
                                      fontSize: 20, color: Colors.grey[400]
                                  ),
                                ),
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 10),
                              // Description Text Input
                              TextFormField(
                                controller: contentController,
                                minLines: 5,
                                maxLines: 12,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Description must not be empty';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: 'Description',
                                  hintStyle: TextStyle(
                                      fontSize: 20, color: Colors.grey[400]),
                                ),
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  // DatePicker Text Field
                                  Expanded(
                                    // child: TextFormField(
                                    //   controller: dateController,
                                    //   keyboardType: TextInputType.datetime,
                                    //   onTap: () => showDatePicker(
                                    //     context: context,
                                    //     initialDate: DateTime.now(),
                                    //     firstDate: DateTime.now(),
                                    //     lastDate:
                                    //         DateTime.parse('2027-12-31'),
                                    //   ).then((value) {
                                    //     if (value != null) {
                                    //       setState(() {
                                    //         dateController.text = value.toIso8601String();
                                    //       });
                                    //     }
                                    //   }),
                                    //   decoration: InputDecoration(
                                    //     suffixIcon: const Icon(
                                    //       Icons.date_range,
                                    //       color: Colors.grey,
                                    //     ),
                                    //     hintText: 'Due Date',
                                    //     hintStyle: TextStyle(
                                    //         fontSize: 16,
                                    //         color: Colors.grey[400]),
                                    //     border: InputBorder.none,
                                    //   ),
                                    //   style: const TextStyle(
                                    //       color: Colors.white),
                                    // ),
                                    child: GestureDetector(
                                      onTap: () => showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.parse('2027-11-31'),
                                      ).then((value) {
                                        if (value != null) {
                                          //print(DateFormat.YEAR_MONTH_DAY);
                                          _dateController.text = value.toUtc().toIso8601String();
                                          dueDateFormatted = _dateController.text;
                                          _dateController.text = DateFormat('dd/MM/yyyy').format(value);
                                          print(dueDateFormatted);
                                          print(_dateController.text);
                                        }
                                      }),
                                      child: Container(
                                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                                        padding: EdgeInsetsDirectional.symmetric(horizontal: 20),
                                        child: AbsorbPointer(
                                          child: TextFormField(
                                            controller: _dateController,
                                            keyboardType: TextInputType.none,
                                            decoration: InputDecoration(
                                              suffixIcon: const Icon(
                                                Icons.date_range,
                                                color: Colors.black,
                                              ),
                                              hintText: 'Due Date',
                                              hintStyle: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black),
                                              border: InputBorder.none,
                                            ),
                                            style: TextStyle(color: Colors.black,  overflow: TextOverflow.ellipsis,),
                                            maxLines: 1,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: width/10,),
                                  // Announcement Type Dropdown
                                  DropdownButton<String>(
                                    hint: const Text(
                                      'Type',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    value: selectedItem,
                                    dropdownColor: Colors.white,
                                    iconEnabledColor: Colors.white,
                                    style: const TextStyle(color: Colors.white),
                                    items: _items.map((String item) {
                                      return DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedItem = newValue;
                                      });
                                    },
                                    selectedItemBuilder: (BuildContext context) {
                                        // Ensuring the selected item has the same padding and alignment as the menu items
                                        return _items.map((String item) {
                                          return DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(
                                              item,
                                              style: const TextStyle(
                                                color: Colors.white, // White color for the selected item displayed outside
                                              ),
                                            ),
                                          );
                                        }).toList();
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 10,),
                              //Upload Image button
                              Container(
                                  padding: EdgeInsetsDirectional.symmetric(horizontal: 15),
                                  width: width / 2,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      if(cubit.AnnouncementImageFile == null)
                                        cubit.getAnnouncementImage();
                                    },
                                    child:ConditionalBuilder(
                                      condition: cubit.AnnouncementImageFile != null,
                                      builder: (context) => Row(
                                        children: [
                                          ConstrainedBox(constraints: BoxConstraints(maxWidth: width/4) ,child: Text(cubit.imageName, style: TextStyle(color: Colors.black), overflow: TextOverflow.ellipsis, maxLines: 1,)),
                                          SizedBox(width: 5,),
                                          IconButton(icon: Icon(cubit.pickerIcon, color: Colors.black,), onPressed: (){
                                            if(cubit.AnnouncementImageFile == null) {
                                              cubit.getAnnouncementImage();
                                            }
                                            else
                                            {
                                              setState(() {
                                                cubit.AnnouncementImageFile = null;
                                                cubit.pickerIcon = Icons.image;
                                                cubit.imageName = 'Select Image';
                                              });
                                            }
                                          }),
                                        ],
                                      ),
                                      fallback: (context) =>Row(
                                          children: [
                                      ConstrainedBox(constraints: BoxConstraints(maxWidth: width/4) ,child: Text('Select Image', style: TextStyle(color: Colors.black), overflow: TextOverflow.ellipsis, maxLines: 1,)),
                                      SizedBox(width: 5,),
                                      IconButton(icon: Icon(Icons.image, color: Colors.black,), onPressed: (){}),
                                      ],
                                    )
                                    ),
                                  )
                              ),
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
                                        padding: const EdgeInsetsDirectional
                                            .symmetric(horizontal: 25),
                                        backgroundColor: HexColor('D9D9D9')
                                            .withOpacity(0.2),
                                        foregroundColor: Colors.white,
                                        textStyle:
                                            const TextStyle(fontSize: 15),
                                      ),
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const Spacer(),
                                    ElevatedButton(
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate() && selectedItem != null) {
                                          await cubit.UploadPImage(isUserProfile: false, image: cubit.AnnouncementImageFile);
                                          cubit.updateAnnouncement(
                                            cubit.announcements![int.parse(id)].id.toString(),
                                            title: titleController.text,
                                            content: contentController.text,
                                            dueDate: _dateController.text,
                                            type: selectedItem!,
                                            image: cubit.AnnouncementImagePath,
                                            currentSemester: widget.semester
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
                                          padding: const EdgeInsetsDirectional
                                              .symmetric(horizontal: 30),
                                          backgroundColor: HexColor('AB29E8')
                                              .withOpacity(0.5),
                                          foregroundColor: Colors.white,
                                          textStyle:
                                              const TextStyle(fontSize: 15)),
                                      child: const Text(
                                        'Accept',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
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
                fallback: (context) => const Center(child: CircularProgressIndicator(),),
              ),
            ),
          );
        },
      ),
    );
  }
}
