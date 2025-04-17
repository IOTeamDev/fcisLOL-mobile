import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit.dart';
import 'package:lol/features/previous_exams/data/previous_exams_model.dart';

import '../../../../../core/utils/components.dart';
import '../../../../../core/utils/resources/colors_manager.dart';
import '../../../../../core/utils/resources/constants_manager.dart';
import '../../../../../core/utils/resources/icons_manager.dart';
import '../../../../../core/utils/resources/strings_manager.dart';
import '../../../../../core/utils/resources/values_manager.dart';
import '../../../data/models/semster_model.dart';

class EditExamPopup extends StatefulWidget {
  final PreviousExamModel exam;
  final String semester;
  const EditExamPopup({super.key, required this.exam, required this.semester});

  @override
  State<EditExamPopup> createState() => _EditExamPopupState();
}

class _EditExamPopupState extends State<EditExamPopup> {
  String? selectedSemester;
  String? selectedSubject;
  String? selectedExamType;
  late final TextEditingController _titleController;
  late final TextEditingController _LinkController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<String> examsType = [
    'Final',
    'Mid',
    'Other'
  ];

  @override
  void initState() {
    _titleController = TextEditingController(text: widget.exam.title);
    _LinkController = TextEditingController(text: widget.exam.link);
    selectedExamType = widget.exam.type;
    selectedSemester = widget.semester;
    selectedSubject = widget.exam.subject;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MainCubit cubit = MainCubit.get(context);
    return AlertDialog(
      backgroundColor: ColorsManager.darkPrimary,
      actionsAlignment: MainAxisAlignment.center,
      scrollable: true,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Edit Exam', style: Theme.of(context).textTheme.headlineLarge,),
          SizedBox(height: 15,),
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
                      borderSide: BorderSide(color: ColorsManager.lightPrimary)
                    )
                  ),
                  keyboardType: TextInputType.text,
                  cursorColor: ColorsManager.lightPrimary,
                  validator: (value){
                    if(value!.isEmpty){
                      return StringsManager.emptyFieldWarning;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15,),
                TextFormField(
                  controller: _LinkController,
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: 'Exam Link',
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: ColorsManager.lightPrimary)
                    )
                  ),
                  keyboardType: TextInputType.text,
                  cursorColor: ColorsManager.lightPrimary,
                  validator: (value){
                    if(value!.isEmpty){
                      return StringsManager.emptyFieldWarning;
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 20,),
          Text('Subject:', style: Theme.of(context).textTheme.titleLarge!.copyWith(color: ColorsManager.white),),
          SizedBox(height: 10,),
          Row(
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: ColorsManager.lightPrimary,
                      borderRadius: BorderRadius.circular(AppPaddings.p40)
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15,),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    icon: Icon(IconsManager.dropdownIcon),
                    value: selectedSemester,
                    underline: SizedBox(),
                    hint: Text('Select Semester', style: TextStyle(color: ColorsManager.white)),
                    dropdownColor: ColorsManager.white, // Background color for the dropdown list
                    iconEnabledColor: ColorsManager.white, // Color of the dropdown icon
                    style: const TextStyle(color: ColorsManager.white), // Style for the selected item outside
                    items: AppConstants.semesters.map((String item) => DropdownMenuItem(value: item, child: Text(item,  style: const TextStyle(color: ColorsManager.black),),)
                    ).toList(),
                    selectedItemBuilder: (BuildContext context) {
                      return AppConstants.semesters.map((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(
                              color:
                              ColorsManager.white,
                            ),
                          ),
                        );
                      }).toList();
                    },
                    onChanged: (value) {
                      setState((){
                        selectedSemester = value;
                        selectedSubject = null;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(width: 15,),
              if(selectedSubject != null)
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: ColorsManager.lightPrimary,
                        borderRadius: BorderRadius.circular(AppPaddings.p40)
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 15,),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: selectedSubject,
                      icon: Icon(IconsManager.dropdownIcon),
                      underline: SizedBox(),
                      hint: Text('Select Subject', style: TextStyle(color: ColorsManager.white)),
                      dropdownColor: ColorsManager.white, // Background color for the dropdown list
                      iconEnabledColor: ColorsManager.white, // Color of the dropdown icon
                      style: const TextStyle(color: ColorsManager.white), // Style for the selected item outside
                      items: semesters[getSemesterIndex(selectedSemester!)].subjects.map((SubjectModel item) => DropdownMenuItem(
                        value: item.subjectName,
                        child: Text(item.subjectName.replaceAll(StringsManager.underScore, StringsManager.space),  style: const TextStyle(color: ColorsManager.black),),
                      )
                      ).toList(),
                      selectedItemBuilder: (BuildContext context) {
                        return semesters[getSemesterIndex(selectedSemester!)].subjects.map((SubjectModel item) {
                          return DropdownMenuItem<String>(
                            value: item.subjectName,
                            child: Text(
                              item.subjectName.replaceAll(StringsManager.underScore, StringsManager.space),
                              style: const TextStyle(
                                color:
                                ColorsManager.white,
                              ),
                            ),
                          );
                        }).toList();
                      },
                      onChanged: (value) {
                        setState((){
                          selectedSubject = value;
                        });
                      },
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 10,),
          SizedBox(
            width: AppQueries.screenWidth(context)/2,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: ColorsManager.white,
                borderRadius: BorderRadius.circular(AppPaddings.p40)
              ),
              padding: EdgeInsets.symmetric(horizontal: 15,),
              child: DropdownButton<String>(
                isExpanded: true,
                icon: Icon(IconsManager.dropdownIcon, color: ColorsManager.black,),
                value: selectedExamType,
                underline: SizedBox(),
                hint: Text('Select Exam Type', style: TextStyle(color: ColorsManager.black)),
                dropdownColor: ColorsManager.white, // Background color for the dropdown list
                iconEnabledColor: ColorsManager.white, // Color of the dropdown icon
                style: const TextStyle(color: ColorsManager.black), // Style for the selected item outside
                items: examsType.map((String item) => DropdownMenuItem(value: item, child: Text(item,  style: const TextStyle(color: ColorsManager.black),),)
                ).toList(),
                selectedItemBuilder: (BuildContext context) {
                  return examsType.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(
                          color:
                          ColorsManager.black,
                        ),
                      ),
                    );
                  }).toList();
                },
                onChanged: (value) {
                  setState((){
                    selectedExamType = value;
                  });
                },
              ),
            ),
          ),
          SizedBox(height: 20,),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsManager.white
                  ),
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: Text(StringsManager.cancel, style: Theme.of(context).textTheme.titleLarge!.copyWith(color: ColorsManager.black),)
                )
              ),
              SizedBox(width: 20,),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsManager.lightPrimary
                  ),
                  onPressed: (){
                    if(selectedSubject != null && selectedExamType != null){
                      if(_formKey.currentState!.validate()){
                          showToastMessage(message: 'Editing Exam.....', states: ToastStates.INFO, textColor: ColorsManager.black, toastLength: Toast.LENGTH_SHORT);
                          cubit.editPreviousExam(
                            widget.exam.id,
                            _titleController.text,
                            _LinkController.text,
                            selectedSemester!,
                            selectedSubject!,
                            selectedExamType!
                          );
                          Navigator.of(context).pop();
                      }
                    } else {
                      if(selectedSubject == null && selectedExamType == null){
                        showToastMessage(message: 'Please Select Subject and Exam Type', states: ToastStates.WARNING, textColor: ColorsManager.black, toastLength: Toast.LENGTH_LONG);
                      }
                      else if(selectedSubject == null){
                        showToastMessage(message: 'Please Select Subject', states: ToastStates.WARNING, textColor: ColorsManager.black, toastLength: Toast.LENGTH_LONG);
                      }else{
                        showToastMessage(message: 'Please Select Exam Type', states: ToastStates.WARNING, textColor: ColorsManager.black, toastLength: Toast.LENGTH_LONG );
                      }
                    }
                  },
                  child: Text(StringsManager.submit, style: Theme.of(context).textTheme.titleLarge!.copyWith(color: ColorsManager.white),)
                )
              ),
            ],
          ),
        ],
      ),
      // actions: [
      //   ElevatedButton(
      //     style: ElevatedButton.styleFrom(
      //         backgroundColor: ColorsManager.white
      //     ),
      //     onPressed: (){
      //       Navigator.of(context).pop();
      //     },
      //     child: Text(StringsManager.cancel, style: Theme.of(context).textTheme.titleLarge!.copyWith(color: ColorsManager.black),)
      //   ),
      //   ElevatedButton(
      //     style: ElevatedButton.styleFrom(
      //         backgroundColor: ColorsManager.lightPrimary
      //     ),
      //     onPressed: (){
      //       if(selectedSubject != null && selectedExamType != null){
      //         if(_formKey.currentState!.validate()){
      //           cubit.editPreviousExam(
      //               _titleController.text,
      //               _LinkController.text,
      //               selectedSemester!,
      //               selectedSubject!,
      //               selectedSemester!,
      //               selectedExamType!
      //           );
      //           Navigator.of(context).pop();
      //         }
      //       } else {
      //         if(selectedSubject == null && selectedExamType == null){
      //           showToastMessage(message: 'Please Select Subject and Exam Type', states: ToastStates.WARNING, textColor: ColorsManager.black, toastLength: 3);
      //         }
      //         else if(selectedSubject == null){
      //           showToastMessage(message: 'Please Select Subject', states: ToastStates.WARNING);
      //         }else{
      //           showToastMessage(message: 'Please Select Exam Type', states: ToastStates.WARNING);
      //         }
      //       }
      //     },
      //     child: Text(StringsManager.submit, style: Theme.of(context).textTheme.titleLarge!.copyWith(color: ColorsManager.white),)
      //   )
      // ],
    );
  }
}
