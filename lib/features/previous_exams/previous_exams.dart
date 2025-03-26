import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lol/core/utils/resources/colors_manager.dart';
import 'package:lol/core/utils/resources/constants_manager.dart';
import 'package:lol/core/utils/resources/icons_manager.dart';
import 'package:lol/core/utils/resources/values_manager.dart';
import 'package:lol/features/home/data/models/semster_model.dart';
import '../../core/utils/resources/strings_manager.dart';

class PreviousExams extends StatefulWidget {
  PreviousExams({super.key});

  @override
  State<PreviousExams> createState() => _PreviousExamsState();
}

class _PreviousExamsState extends State<PreviousExams> {
  String? selectedSemester;
  String? selectedSubject;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringsManager.exams, style: Theme.of(context).textTheme.displayMedium,),
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
                      items: AppConstants.semesters.map(
                        (String item) => DropdownMenuItem(value: item, child: Text(item,  style: const TextStyle(color: ColorsManager.black),),)
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
                      onChanged: (value){
                        setState(() {
                          selectedSemester = value!;
                          selectedSubject = null;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(width: 15,),
                if(selectedSemester != null)
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
                      value: selectedSubject,
                      icon: Icon(IconsManager.dropdownIcon),
                      underline: SizedBox(),
                      hint: Text('Select Subject', style: TextStyle(color: ColorsManager.white)),
                      dropdownColor: ColorsManager.white, // Background color for the dropdown list
                      iconEnabledColor: ColorsManager.white, // Color of the dropdown icon
                      style: const TextStyle(color: ColorsManager.white), // Style for the selected item outside
                      items: semesters[semsesterIndex(selectedSemester!)].subjects.map((SubjectModel item) => DropdownMenuItem(
                        value: item.subjectName,
                        child: Text(item.subjectName.replaceAll(StringsManager.underScore, StringsManager.space),  style: const TextStyle(color: ColorsManager.black),),
                      )
                      ).toList(),
                      selectedItemBuilder: (BuildContext context) {
                        return semesters[semsesterIndex(selectedSemester!)].subjects.map((SubjectModel item) {
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
                      onChanged: (value){
                        setState(() {
                          selectedSubject = value;
                        });
                      },
                    ),
                  ),
                ),
                if(selectedSemester != null && selectedSubject != null)
                IconButton(
                    onPressed: (){
                      log('Semester: $selectedSemester and selected Subject: $selectedSubject');
                    },
                    icon: Icon(IconsManager.searchIcon)
                )
              ],
            ),
            SizedBox(height: 30,),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Theme.of(context).primaryColor,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [

                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
