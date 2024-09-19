import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:lol/admin/bloc/admin_cubit.dart';
import 'package:lol/admin/bloc/admin_cubit_states.dart';
import 'package:lol/admin/screens/announcements/announcement_detail.dart';
import 'package:lol/constants/constants.dart';
import 'package:lol/main/screens/webview_screen.dart';
import 'package:lol/utilities/navigation.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

import '../../../shared/components/components.dart';

class AddAnouncment extends StatefulWidget {
  @override
  State<AddAnouncment> createState() => _AddAnouncmentState();
}

class _AddAnouncmentState extends State<AddAnouncment> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  double _height = 80;
  bool isExpanded = false;
  bool showContent = false;

  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var descriptionController = TextEditingController();
  String? selectedItem;
  final List<String> _items = ['Assignment', 'Quiz', 'Other'];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AdminCubit()..getAnnouncements(),
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
          var cubit = AdminCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            drawer: drawerBuilder(context),
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
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: [
                              MaterialButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                padding: EdgeInsets.zero,
                              ),
                            ],
                          ),
                        ),
                        adminTopTitleWithDrawerButton(
                            scaffoldKey: scaffoldKey,
                            title: 'Announcements',
                            size: 32,
                            hasDrawer: true),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isExpanded = true; // Toggle the expansion
                              _height = 400;
                            });
                            Future.delayed(const Duration(milliseconds: 200),
                                () {
                              setState(() {
                                showContent = true;
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
                            child: isExpanded && showContent
                                ? Padding(
                                    padding:
                                        const EdgeInsetsDirectional.symmetric(
                                            horizontal: 10.0, vertical: 10),
                                    child: Form(
                                      key: formKey,
                                      child: AnimatedOpacity(
                                        opacity: isExpanded ? 1.0 : 0,
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.easeInOut,
                                        child: Column(children: [
                                          //Title Text Input
                                          TextFormField(
                                            controller: titleController,
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
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          divider(),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          //Description Input text Field
                                          TextFormField(
                                            controller: descriptionController,
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
                                                  controller: dateController,
                                                  keyboardType:
                                                      TextInputType.datetime,
                                                  onTap: () => showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime.now(),
                                                    lastDate: DateTime.parse(
                                                        '2027-12-31'),
                                                  ).then((value) {
                                                    if (value != null) {
                                                      //print(DateFormat.YEAR_MONTH_DAY);
                                                      dateController.text =
                                                          DateFormat.yMMMd()
                                                              .format(value);
                                                    }
                                                  }),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Date must not be EMPTY!!';
                                                    }
                                                    return null;
                                                  },
                                                  decoration: InputDecoration(
                                                    suffixIcon: Icon(
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
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              //Announcement type Drop Down menu
                                              DropdownButton<String>(
                                                hint: Text(
                                                  'Type',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                style: TextStyle(
                                                    color: Colors.white),
                                                dropdownColor: Colors.black,
                                                value: selectedItem,
                                                items:
                                                    _items.map((String item) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: item,
                                                    child: Text(
                                                      item,
                                                      style: TextStyle(
                                                          color: Colors.white),
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
                                          divider(),
                                          const Spacer(),
                                          //Cancel and Submit buttons
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .symmetric(horizontal: 10.0),
                                            child: Row(
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      titleController.text = '';
                                                      dateController.text = '';
                                                      descriptionController
                                                          .text = '';
                                                      isExpanded =
                                                          false; // Toggle the expansion
                                                      _height = 80;
                                                      showContent = false;
                                                    });
                                                  },
                                                  child: const Text('Canel'),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .symmetric(
                                                            horizontal: 35),
                                                    backgroundColor:
                                                        HexColor('D9D9D9')
                                                            .withOpacity(0.2),
                                                    foregroundColor:
                                                        Colors.white,
                                                    textStyle:
                                                        TextStyle(fontSize: 15),
                                                  ),
                                                ),
                                                const Spacer(),
                                                ElevatedButton(
                                                    onPressed: () {
                                                      if (formKey.currentState!
                                                              .validate() &&
                                                          selectedItem !=
                                                              null) {
                                                        cubit.addAnnouncement(
                                                          title: titleController
                                                              .text,
                                                          dueDate:
                                                              dateController
                                                                  .text,
                                                          type: selectedItem,
                                                          description:
                                                              descriptionController
                                                                  .text,
                                                        );
                                                      }
                                                      setState(() {
                                                        isExpanded = false;
                                                        titleController.text =
                                                            '';
                                                        descriptionController
                                                            .text = '';
                                                        dateController.text =
                                                            '';
                                                        showContent = false;
                                                        selectedItem = null;
                                                        _height = 80;
                                                      });
                                                    },
                                                    child: const Text('Submit'),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .symmetric(
                                                              horizontal: 40),
                                                      backgroundColor:
                                                          HexColor('B8A8F9'),
                                                      foregroundColor:
                                                          Colors.white,
                                                      textStyle: TextStyle(
                                                          fontSize: 15),
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ]),
                                      ),
                                    ))
                                : !isExpanded
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
                              state is! AdminGetAnnouncementLoadingState && cubit.announcements != null && cubit.announcements!.isNotEmpty,
                          builder: (context) => ListView.separated(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) =>
                                announcementBuilder(context, cubit.announcements![index].title, index, ),
                            separatorBuilder: (context, index) => const SizedBox(height: 10,),
                            itemCount: cubit.announcements!.length,
                          ),
                          fallback: (context) {
                            if (state is AdminGetAnnouncementLoadingState) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            else {
                              return const Center(
                                child: Text(
                                  'You have no announcements yet!!!',
                                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
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

  Widget announcementBuilder(context, title, ID,) {
    int id = ID;
    return GestureDetector(
      onTap: () {
        navigate(
          context,
          AnnouncementDetail(
            AdminCubit
                .get(context)
                .announcements![id].title,
            AdminCubit
                .get(context)
                .announcements![id].content,
            AdminCubit
                .get(context)
                .announcements![id].dueDate,
            id,
            onDelete: () {
              AdminCubit.get(context).getAnnouncements();
            },
          ),
        );
      },
      child: Container(
        margin: const EdgeInsetsDirectional.symmetric(horizontal: 10),
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
        height: 80,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: HexColor('B8A8F9')
        ),
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
            MaterialButton(
              onPressed: () {
                //edit button
              },
              shape: const CircleBorder(),
              // X icon
              minWidth: 0,
              // Reduce min width to make it smaller
              padding: const EdgeInsets.all(5),
              // Circular button
              child: const Icon(
                Icons.edit,
                color: Colors.green,
              ), // Padding for icon
            ),
            MaterialButton(
              onPressed: () {
                AdminCubit.get(context).deleteAnnouncement(AdminCubit
                    .get(context)
                    .announcements![id].id);
              },
              shape: const CircleBorder(),
              // X icon
              minWidth: 0,
              // Reduce min width to make it smaller
              padding: const EdgeInsets.all(5),
              // Circular button
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
