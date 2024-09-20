import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:lol/admin/bloc/admin_cubit_states.dart';

import '../../../constants/constants.dart';
import '../../../shared/components/components.dart';
import '../../bloc/admin_cubit.dart';

class EditAnnouncement extends StatefulWidget {
  final String id;
  final String title;
  final String content;
  final String date;
  final String? selectedItem;

  EditAnnouncement({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    this.selectedItem,
  });

  @override
  _EditAnnouncementState createState() => _EditAnnouncementState();
}

class _EditAnnouncementState extends State<EditAnnouncement> {
  String? selectedItem;
  final List<String> _items = ['Quiz', 'Assignment', 'Other'];

  late TextEditingController titleController;
  late TextEditingController contentController;
  late TextEditingController dateController;
  late String id;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing values
    titleController = TextEditingController(text: widget.title);
    contentController = TextEditingController(text: widget.content);
    dateController = TextEditingController(text: widget.date);
    selectedItem = widget.selectedItem;
    id = widget.id;
  }

  @override
  void dispose() {
    // Dispose controllers when not needed
    titleController.dispose();
    contentController.dispose();
    dateController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context){
    return BlocProvider(
      create: (context) => AdminCubit()..getAnnouncements(),
      child: BlocConsumer<AdminCubit, AdminCubitStates> (
        listener: (context, state){
          if(state is AdminUpdateAnnouncementSuccessState)
          {
            showToastMessage(message: 'Material Updated Successfully!!', states: ToastStates.SUCCESS);
            Navigator.pop(context, 'refresh');
          }
        },
        builder:(context, state) {
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
                      // Back Button
                      backButton(context),
                      adminTopTitleWithDrawerButton(
                          title: 'Edit Announcement',
                          size: 32,
                          hasDrawer: false),
                      Container(
                        margin: const EdgeInsetsDirectional.symmetric(horizontal: 15, vertical: 20),
                        padding: const EdgeInsets.all(15),
                        height: screenHeight(context) / 1.45,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              HexColor('B8A8F9').withOpacity(0.45),
                              HexColor('2F2B3E').withOpacity(0.45)
                            ], begin: Alignment.bottomRight, end: Alignment.topLeft),
                            borderRadius: BorderRadius.circular(20)),
                        child: Form(
                          key: _formKey,
                          child: Column(
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
                                  hintStyle:
                                  TextStyle(fontSize: 20, color: Colors.grey[400]),
                                  border: InputBorder.none,
                                ),
                                style: const TextStyle(color: Colors.white),
                              ),
                              divider(),
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
                                  hintStyle:
                                  TextStyle(fontSize: 20, color: Colors.grey[400]),
                                  border: InputBorder.none,
                                ),
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 10),
                              divider(),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  // DatePicker Text Field
                                  Expanded(
                                    child: TextFormField(
                                      controller: dateController,
                                      keyboardType: TextInputType.datetime,
                                      onTap: () => showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.parse('2027-12-31'),
                                      ).then((value) {
                                        if (value != null) {
                                          setState(() {
                                            dateController.text = DateFormat.yMMMd().format(value);
                                          });
                                        }
                                      }),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Date must not be empty';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        suffixIcon: const Icon(
                                          Icons.date_range,
                                          color: Colors.grey,
                                        ),
                                        hintText: 'Due Date',
                                        hintStyle: TextStyle(
                                            fontSize: 16, color: Colors.grey[400]),
                                        border: InputBorder.none,
                                      ),
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  // Announcement Type Dropdown
                                  DropdownButton<String>(
                                    hint: const Text(
                                      'Type',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: const TextStyle(color: Colors.white),
                                    dropdownColor: Colors.black,
                                    value: selectedItem,
                                    items: _items.map((String item) {
                                      return DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style:
                                          const TextStyle(color: Colors.white),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedItem = newValue;
                                      });
                                    },
                                  ),
                                ],
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
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsetsDirectional.symmetric(
                                            horizontal: 25),
                                        backgroundColor:
                                        HexColor('D9D9D9').withOpacity(0.2),
                                        foregroundColor: Colors.white,
                                        textStyle: const TextStyle(fontSize: 15),
                                      ),
                                    ),
                                    const Spacer(),
                                    ElevatedButton(
                                      onPressed: (){
                                        if (_formKey.currentState!.validate() && selectedItem != null) {

                                          print(id);
                                          print(titleController.text);
                                          print(contentController.text);
                                          print(dateController.text);
                                          print(selectedItem);
                                          AdminCubit.get(context).updateAnnouncement(
                                            AdminCubit.get(context).announcements![int.parse(id)].id.toString(),
                                            title: titleController.text,
                                            content: contentController.text,
                                            dueDate: dateController.text,
                                            type: selectedItem!,
                                          );
                                        } else {
                                          // Show error if validation fails
                                          showToastMessage(
                                            message: 'Please fill all fields correctly.',
                                            states: ToastStates.ERROR,
                                          );
                                        }
                                      },
                                      child: const Text(
                                        'Accept',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                          padding:
                                          const EdgeInsetsDirectional.symmetric(
                                              horizontal: 30),
                                          backgroundColor:
                                          HexColor('AB29E8').withOpacity(0.5),
                                          foregroundColor: Colors.white,
                                          textStyle:
                                          TextStyle(fontSize: 15)),
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
              ),
            ],
          ),
        );
        },
      ),
    );
  }
}
