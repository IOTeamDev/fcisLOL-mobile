import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart' as intl;
import 'package:lol/core/cubits/main_cubit/main_cubit.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit_states.dart';
import 'package:lol/core/utils/resources/strings_manager.dart';
import 'package:lol/core/utils/resources/theme_provider.dart';
import 'package:lol/main.dart';
import 'package:lol/features/admin/presentation/view_model/admin_cubit/admin_cubit_states.dart';
import 'package:lol/core/utils/resources/constants_manager.dart';
import 'package:lol/core/utils/components.dart';
import 'package:provider/provider.dart';

import '../../../../../core/utils/resources/colors_manager.dart';

class EditAnnouncement extends StatefulWidget {
  final int id;
  final String semester;
  final String title;
  final String content;
  final String date;
  final int index;
  final String? imageLink;

  const EditAnnouncement({
    super.key,
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.semester,
    this.imageLink,
    required this.index,
  });

  @override
  _EditAnnouncementState createState() => _EditAnnouncementState();
}

class _EditAnnouncementState extends State<EditAnnouncement> {
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
            : intl.DateFormat('dd/MM/yyyy')
                .format(DateTime.parse(widget.date)));
    //selectedItem = widget.selectedItem;
    id = widget.id;
    // print('date controller: ${_dateController.text}');
    // print('widget date: ${widget.date}');
    // dueDateFormatted = widget.date;
    // print('due Date: $dueDateFormatted');
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
    final content =
        widget.content.isEmpty ? StringsManager.noContent : widget.content;
    final isContentRtl = intl.Bidi.detectRtlDirectionality(content);
    final textDirection = widget.content.isEmpty
        ? (isArabicLanguage(context) ? TextDirection.rtl : TextDirection.ltr)
        : (isContentRtl ? TextDirection.rtl : TextDirection.ltr);

    return BlocConsumer<MainCubit, MainCubitStates>(
      listener: (context, state) {
        if (state is UpdateAnnouncementsSuccessState) {
          showToastMessage(
              message: 'Announcement Updated Successfully!!',
              states: ToastStates.SUCCESS);
          Navigator.pop(context, StringsManager.refresh);
        }
      },
      builder: (context, state) {
        var cubit = MainCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              StringsManager.announcements,
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsetsDirectional.symmetric(
                      horizontal: 15, vertical: 40),
                  padding: const EdgeInsets.all(15),
                  height: AppQueries.screenHeight(context) / 1.45,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Provider.of<ThemeProvider>(context).isDark
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
                          textDirection: isArabicLanguage(context)
                              ? TextDirection.rtl
                              : TextDirection.ltr,
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
                                    color: Provider.of<ThemeProvider>(context)
                                            .isDark
                                        ? HexColor('#848484')
                                        : HexColor('#FFFFFF'))),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        // Description Text Input
                        TextFormField(
                          textDirection: textDirection,
                          controller: contentController,
                          minLines: 5,
                          maxLines: 12,
                          decoration: InputDecoration(
                            hintText: StringsManager.description,
                            hintStyle: TextStyle(
                                fontSize: 20, color: Colors.grey[400]),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Provider.of<ThemeProvider>(context)
                                            .isDark
                                        ? ColorsManager.grey
                                        : ColorsManager.white)),
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
                                  setState(() {
                                    DateTime selectedDate = DateTime(
                                        value.year, value.month, value.day);
                                    dueDateFormatted = DateTime.utc(
                                            selectedDate.year,
                                            selectedDate.month,
                                            selectedDate.day)
                                        .toIso8601String();
                                    print(dueDateFormatted);
                                    _dateController.text =
                                        intl.DateFormat('dd/MM/yyyy')
                                            .format(value);
                                  });
                                  // print(dueDateFormatted);
                                  // print(_dateController.text);
                                }
                              }),
                              child: Container(
                                width: AppQueries.screenWidth(context) / 2.2,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
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
                                          fontSize: 14, color: Colors.black),
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
                                      borderRadius: BorderRadius.circular(13)),
                                  padding: EdgeInsetsDirectional.symmetric(
                                      horizontal:
                                          AppQueries.screenWidth(context) / 11),
                                  backgroundColor: Colors.white,
                                  textStyle: TextStyle(
                                      fontSize:
                                          AppQueries.screenWidth(context) / 17),
                                ),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              const Spacer(),
                              ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      cubit.updateAnnouncement(
                                        id,
                                        title: titleController.text,
                                        content: contentController.text,
                                        dueDate:
                                            dueDateFormatted == 'No Due Date'
                                                ? null
                                                : dueDateFormatted,
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
                                    padding: EdgeInsetsDirectional.symmetric(
                                        horizontal:
                                            AppQueries.screenWidth(context) /
                                                11),
                                    backgroundColor: ColorsManager.lightPrimary,
                                    foregroundColor: ColorsManager.white,
                                    textStyle: TextStyle(
                                        fontSize:
                                            AppQueries.screenWidth(context) /
                                                17),
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
        );
      },
    );
  }

  bool isArabicLanguage(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ar';
  }
}
