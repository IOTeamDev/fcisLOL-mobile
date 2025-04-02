import 'dart:developer';
import 'dart:ui';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:googleapis/container/v1.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit_states.dart';
import 'package:lol/core/utils/components.dart';
import 'package:lol/core/utils/resources/colors_manager.dart';
import 'package:lol/core/utils/resources/constants_manager.dart';
import 'package:lol/core/utils/resources/icons_manager.dart';
import 'package:lol/core/utils/resources/values_manager.dart';
import 'package:lol/features/home/data/models/semster_model.dart';
import 'package:lol/features/previous_exams/presentation/view/widgets/final_exams.dart';
import 'package:lol/features/previous_exams/presentation/view/widgets/mid_exams.dart';
import 'package:lol/features/previous_exams/presentation/view/widgets/other_exams.dart';
import '../../../../core/cubits/main_cubit/main_cubit.dart';
import '../../../../core/utils/resources/strings_manager.dart';

class PreviousExams extends StatefulWidget {
  PreviousExams({super.key});

  @override
  State<PreviousExams> createState() => _PreviousExamsState();
}

class _PreviousExamsState extends State<PreviousExams> {
  String? selectedSemester;
  String? selectedSubject;

  String? selectedExamType;
  String? bottomSheetSelectedSemester;
  String? bottomSheetSelectedSubject;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _LinkController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> examsType = ['Final', 'Mid', 'Other'];

  @override
  void initState() {
    if (AppConstants.previousExamsSelectedSemester != null) {
      selectedSemester = AppConstants.previousExamsSelectedSemester;
    }
    if (AppConstants.previousExamsSelectedSubject != null) {
      selectedSubject = AppConstants.previousExamsSelectedSubject;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainCubitStates>(
      listener: (context, state) {},
      builder: (context, state) {
        MainCubit cubit = MainCubit.get(context);
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text(
              StringsManager.exams,
              style: Theme.of(context).textTheme.displayMedium,
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: ColorsManager.lightPrimary,
                            borderRadius:
                                BorderRadius.circular(AppPaddings.p40)),
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          icon: Icon(IconsManager.dropdownIcon),
                          value: selectedSemester,
                          underline: SizedBox(),
                          hint: Text('Select Semester',
                              style: TextStyle(color: ColorsManager.white)),
                          dropdownColor: ColorsManager
                              .white, // Background color for the dropdown list
                          iconEnabledColor:
                              ColorsManager.white, // Color of the dropdown icon
                          style: const TextStyle(
                              color: ColorsManager
                                  .white), // Style for the selected item outside
                          items: AppConstants.semesters
                              .map((String item) => DropdownMenuItem(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                          color: ColorsManager.black),
                                    ),
                                  ))
                              .toList(),
                          selectedItemBuilder: (BuildContext context) {
                            return AppConstants.semesters.map((String item) {
                              return DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    color: ColorsManager.white,
                                  ),
                                ),
                              );
                            }).toList();
                          },
                          onChanged: (value) {
                            setState(() {
                              selectedSemester = value!;
                              AppConstants.previousExamsSelectedSemester =
                                  selectedSemester;
                              selectedSubject = null;
                              AppConstants.previousExamsSelectedSubject = null;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    if (selectedSemester != null)
                      Expanded(
                        flex: 2,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: ColorsManager.lightPrimary,
                              borderRadius:
                                  BorderRadius.circular(AppPaddings.p40)),
                          padding: EdgeInsets.symmetric(
                            horizontal: 15,
                          ),
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: selectedSubject,
                            icon: Icon(IconsManager.dropdownIcon),
                            underline: SizedBox(),
                            hint: Text('Select Subject',
                                style: TextStyle(color: ColorsManager.white)),
                            dropdownColor: ColorsManager
                                .white, // Background color for the dropdown list
                            iconEnabledColor: ColorsManager
                                .white, // Color of the dropdown icon
                            style: const TextStyle(
                                color: ColorsManager
                                    .white), // Style for the selected item outside
                            items: semesters[semsesterIndex(selectedSemester!)]
                                .subjects
                                .map((SubjectModel item) => DropdownMenuItem(
                                      value: item.subjectName,
                                      child: Text(
                                        item.subjectName.replaceAll(
                                            StringsManager.underScore,
                                            StringsManager.space),
                                        style: const TextStyle(
                                            color: ColorsManager.black),
                                      ),
                                    ))
                                .toList(),
                            selectedItemBuilder: (BuildContext context) {
                              return semesters[
                                      semsesterIndex(selectedSemester!)]
                                  .subjects
                                  .map((SubjectModel item) {
                                return DropdownMenuItem<String>(
                                  value: item.subjectName,
                                  child: Text(
                                    item.subjectName.replaceAll(
                                        StringsManager.underScore,
                                        StringsManager.space),
                                    style: const TextStyle(
                                      color: ColorsManager.white,
                                    ),
                                  ),
                                );
                              }).toList();
                            },
                            onChanged: (value) {
                              setState(() {
                                selectedSubject = value;
                                AppConstants.previousExamsSelectedSubject =
                                    selectedSubject;
                              });
                            },
                          ),
                        ),
                      ),
                    if (selectedSemester != null && selectedSubject != null)
                      IconButton(
                          onPressed: () {
                            cubit.getPreviousExams(selectedSubject);
                          },
                          icon: Icon(IconsManager.searchIcon))
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Theme.of(context).primaryColor,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                    child: ConditionalBuilder(
                      condition: state is! GetPreviousExamsLoadingState,
                      fallback: (context) {
                        return Center(
                            child: CircularProgressIndicator(
                          color: ColorsManager.white,
                        ));
                      },
                      builder: (context) => SingleChildScrollView(
                        child: Column(
                          children: [
                            if (cubit.previousExamsFinal.isNotEmpty)
                              FinalExams(),
                            if (cubit.previousExamsMid.isNotEmpty) MidExams(),
                            if (cubit.previousExamsOther.isNotEmpty)
                              OtherExams(),
                            if (cubit.previousExamsMid.isEmpty &&
                                cubit.previousExamsOther.isEmpty &&
                                cubit.previousExamsFinal.isEmpty)
                              Text(
                                'There are no Exams Yet',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      color: ColorsManager.white,
                                    ),
                              )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (!cubit.isBottomSheetShown) {
                cubit.changeBottomSheetState(true);
                _scaffoldKey.currentState!
                    .showBottomSheet(
                        sheetAnimationStyle: AnimationStyle(
                            curve: Curves.fastEaseInToSlowEaseOut,
                            duration: Duration(milliseconds: 650),
                            reverseCurve: Curves.fastOutSlowIn,
                            reverseDuration: Duration(milliseconds: 600)),
                        (context) => StatefulBuilder(
                              builder: (context, setState) => BackdropFilter(
                                filter: ImageFilter.blur(sigmaY: 3, sigmaX: 3),
                                child: IntrinsicHeight(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 30, horizontal: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: ColorsManager.darkPrimary,
                                    ),
                                    constraints: BoxConstraints(
                                      maxHeight:
                                          (AppQueries.screenHeight(context) /
                                                  1.7) +
                                              100,
                                      minHeight:
                                          AppQueries.screenHeight(context) /
                                              1.7,
                                    ),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Add Exam',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineLarge,
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Form(
                                            key: _formKey,
                                            child: Column(
                                              children: [
                                                TextFormField(
                                                  controller: _titleController,
                                                  maxLines: 1,
                                                  decoration: InputDecoration(
                                                      hintText: 'Exam Title',
                                                      focusedBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: ColorsManager
                                                                  .lightPrimary))),
                                                  keyboardType:
                                                      TextInputType.text,
                                                  cursorColor: ColorsManager
                                                      .lightPrimary,
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return StringsManager
                                                          .emptyFieldWarning;
                                                    }
                                                    return null;
                                                  },
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                TextFormField(
                                                  controller: _LinkController,
                                                  maxLines: 1,
                                                  decoration: InputDecoration(
                                                      hintText: 'Exam Link',
                                                      focusedBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: ColorsManager
                                                                  .lightPrimary))),
                                                  keyboardType:
                                                      TextInputType.text,
                                                  cursorColor: ColorsManager
                                                      .lightPrimary,
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return StringsManager
                                                          .emptyFieldWarning;
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            'Subject:',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge!
                                                .copyWith(
                                                    color: ColorsManager.white),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      color: ColorsManager
                                                          .lightPrimary,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              AppPaddings.p40)),
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 15,
                                                  ),
                                                  child: DropdownButton<String>(
                                                    isExpanded: true,
                                                    icon: Icon(IconsManager
                                                        .dropdownIcon),
                                                    value:
                                                        bottomSheetSelectedSemester,
                                                    underline: SizedBox(),
                                                    hint: Text(
                                                        'Select Semester',
                                                        style: TextStyle(
                                                            color: ColorsManager
                                                                .white)),
                                                    dropdownColor: ColorsManager
                                                        .white, // Background color for the dropdown list
                                                    iconEnabledColor: ColorsManager
                                                        .white, // Color of the dropdown icon
                                                    style: const TextStyle(
                                                        color: ColorsManager
                                                            .white), // Style for the selected item outside
                                                    items: AppConstants
                                                        .semesters
                                                        .map((String item) =>
                                                            DropdownMenuItem(
                                                              value: item,
                                                              child: Text(
                                                                item,
                                                                style: const TextStyle(
                                                                    color: ColorsManager
                                                                        .black),
                                                              ),
                                                            ))
                                                        .toList(),
                                                    selectedItemBuilder:
                                                        (BuildContext context) {
                                                      return AppConstants
                                                          .semesters
                                                          .map((String item) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: item,
                                                          child: Text(
                                                            item,
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  ColorsManager
                                                                      .white,
                                                            ),
                                                          ),
                                                        );
                                                      }).toList();
                                                    },
                                                    onChanged: (value) {
                                                      setState(() {
                                                        bottomSheetSelectedSemester =
                                                            value;
                                                        bottomSheetSelectedSubject =
                                                            null;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 15,
                                              ),
                                              if (bottomSheetSelectedSemester !=
                                                  null)
                                                Expanded(
                                                  flex: 2,
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                        color: ColorsManager
                                                            .lightPrimary,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    AppPaddings
                                                                        .p40)),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                    ),
                                                    child:
                                                        DropdownButton<String>(
                                                      isExpanded: true,
                                                      value:
                                                          bottomSheetSelectedSubject,
                                                      icon: Icon(IconsManager
                                                          .dropdownIcon),
                                                      underline: SizedBox(),
                                                      hint: Text(
                                                          'Select Subject',
                                                          style: TextStyle(
                                                              color:
                                                                  ColorsManager
                                                                      .white)),
                                                      dropdownColor: ColorsManager
                                                          .white, // Background color for the dropdown list
                                                      iconEnabledColor:
                                                          ColorsManager
                                                              .white, // Color of the dropdown icon
                                                      style: const TextStyle(
                                                          color: ColorsManager
                                                              .white), // Style for the selected item outside
                                                      items: semesters[
                                                              semsesterIndex(
                                                                  bottomSheetSelectedSemester!)]
                                                          .subjects
                                                          .map((SubjectModel
                                                                  item) =>
                                                              DropdownMenuItem(
                                                                value: item
                                                                    .subjectName,
                                                                child: Text(
                                                                  item.subjectName.replaceAll(
                                                                      StringsManager
                                                                          .underScore,
                                                                      StringsManager
                                                                          .space),
                                                                  style: const TextStyle(
                                                                      color: ColorsManager
                                                                          .black),
                                                                ),
                                                              ))
                                                          .toList(),
                                                      selectedItemBuilder:
                                                          (BuildContext
                                                              context) {
                                                        return semesters[
                                                                semsesterIndex(
                                                                    bottomSheetSelectedSemester!)]
                                                            .subjects
                                                            .map((SubjectModel
                                                                item) {
                                                          return DropdownMenuItem<
                                                              String>(
                                                            value: item
                                                                .subjectName,
                                                            child: Text(
                                                              item.subjectName.replaceAll(
                                                                  StringsManager
                                                                      .underScore,
                                                                  StringsManager
                                                                      .space),
                                                              style:
                                                                  const TextStyle(
                                                                color:
                                                                    ColorsManager
                                                                        .white,
                                                              ),
                                                            ),
                                                          );
                                                        }).toList();
                                                      },
                                                      onChanged: (value) {
                                                        setState(() {
                                                          bottomSheetSelectedSubject =
                                                              value;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          SizedBox(
                                            width: AppQueries.screenWidth(
                                                    context) /
                                                2,
                                            child: Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  color: ColorsManager.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          AppPaddings.p40)),
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 15,
                                              ),
                                              child: DropdownButton<String>(
                                                isExpanded: true,
                                                icon: Icon(
                                                  IconsManager.dropdownIcon,
                                                  color: ColorsManager.black,
                                                ),
                                                value: selectedExamType,
                                                underline: SizedBox(),
                                                hint: Text('Select Exam Type',
                                                    style: TextStyle(
                                                        color: ColorsManager
                                                            .black)),
                                                dropdownColor: ColorsManager
                                                    .white, // Background color for the dropdown list
                                                iconEnabledColor: ColorsManager
                                                    .white, // Color of the dropdown icon
                                                style: const TextStyle(
                                                    color: ColorsManager
                                                        .black), // Style for the selected item outside
                                                items: examsType
                                                    .map((String item) =>
                                                        DropdownMenuItem(
                                                          value: item,
                                                          child: Text(
                                                            item,
                                                            style: const TextStyle(
                                                                color:
                                                                    ColorsManager
                                                                        .black),
                                                          ),
                                                        ))
                                                    .toList(),
                                                selectedItemBuilder:
                                                    (BuildContext context) {
                                                  return examsType
                                                      .map((String item) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: item,
                                                      child: Text(
                                                        item,
                                                        style: const TextStyle(
                                                          color: ColorsManager
                                                              .black,
                                                        ),
                                                      ),
                                                    );
                                                  }).toList();
                                                },
                                                onChanged: (value) {
                                                  setState(() {
                                                    selectedExamType = value;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                  child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              backgroundColor:
                                                                  ColorsManager
                                                                      .white),
                                                      onPressed: () {
                                                        cubit
                                                            .changeBottomSheetState(
                                                                false);
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text(
                                                        StringsManager.cancel,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleLarge!
                                                            .copyWith(
                                                                color:
                                                                    ColorsManager
                                                                        .black),
                                                      ))),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Expanded(
                                                  child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              backgroundColor:
                                                                  ColorsManager
                                                                      .lightPrimary),
                                                      onPressed: () {
                                                        if (bottomSheetSelectedSubject !=
                                                                null &&
                                                            selectedExamType !=
                                                                null) {
                                                          if (_formKey
                                                              .currentState!
                                                              .validate()) {
                                                            cubit.addPreviousExam(
                                                                _titleController
                                                                    .text,
                                                                _LinkController
                                                                    .text,
                                                                bottomSheetSelectedSemester!,
                                                                bottomSheetSelectedSubject!,
                                                                selectedSemester!,
                                                                selectedExamType!);
                                                            cubit
                                                                .changeBottomSheetState(
                                                                    false);
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          }
                                                        } else {
                                                          if (bottomSheetSelectedSubject ==
                                                                  null &&
                                                              selectedExamType ==
                                                                  null) {
                                                            showToastMessage(
                                                                message:
                                                                    'Please Select Subject and Exam Type',
                                                                states:
                                                                    ToastStates
                                                                        .WARNING,
                                                                textColor:
                                                                    ColorsManager
                                                                        .black,
                                                                toastLength: 3);
                                                          } else if (bottomSheetSelectedSubject ==
                                                              null) {
                                                            showToastMessage(
                                                                message:
                                                                    'Please Select Subject',
                                                                states:
                                                                    ToastStates
                                                                        .WARNING);
                                                          } else {
                                                            showToastMessage(
                                                                message:
                                                                    'Please Select Exam Type',
                                                                states:
                                                                    ToastStates
                                                                        .WARNING);
                                                          }
                                                        }
                                                      },
                                                      child: Text(
                                                        StringsManager.submit,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleLarge!
                                                            .copyWith(
                                                                color:
                                                                    ColorsManager
                                                                        .white),
                                                      ))),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ))
                    .closed
                    .then((value) {
                  _LinkController.clear();
                  _titleController.clear();
                  bottomSheetSelectedSubject = null;
                  bottomSheetSelectedSemester = null;
                  selectedExamType = null;
                  cubit.changeBottomSheetState(false);
                });
              }
            },
            shape: OvalBorder(),
            backgroundColor: ColorsManager.lightPrimary,
            child: Icon(
              IconsManager.addIcon,
              color: ColorsManager.white,
            ),
          ),
        );
      },
    );
  }
}
