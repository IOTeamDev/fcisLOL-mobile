import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lol/layout/home/bloc/main_cubit.dart';
import 'package:lol/layout/home/home.dart';
import 'package:lol/main.dart';
import 'package:lol/models/subjects/semster_model.dart';
import 'package:lol/shared/components/components.dart';
import 'package:lol/shared/components/constants.dart';
import 'package:lol/shared/components/navigation.dart';

class SemesterNavigate extends StatelessWidget {
  final String semester;
  const SemesterNavigate({super.key, required this.semester});

  @override
  Widget build(BuildContext context) {
    int semesterIndex = semsesterIndex(semester);
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    MaterialButton(
                        minWidth: 0,
                        padding: EdgeInsets.zero,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onPressed: () => Navigator.pop(context),
                        child: Icon(
                          Icons.arrow_back,
                          size: 25,
                        )),
                    Expanded(
                      child: GestureDetector(
                          onTap: () => navigatReplace(context, const Home()),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(width: 15),
                              Image.asset(
                                                                                    color: isDark?Colors.white:null,

                                "images/l.png",
                                width: 45,
                                height: 45,
                              ),
                              Text(
                                "UniNotes",
                                style: GoogleFonts.abel(
                                    fontSize: 28, fontWeight: FontWeight.w500),
                              ),
                            ],
                          )),
                    ),
                    SizedBox(
                      width: 25,
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 5),
                  child: Text(
                    "Semester $semester",
                    style: GoogleFonts.montserrat(
                        fontSize: 30,
                        color: isDark ? Color(0xff4763C4) : Colors.black, //
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Two items per row
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount:
                      // semesters[semesterIndex!].subjects.length,
                      semesters[semesterIndex].subjects.length,
                  itemBuilder: (context, index) {
                    return

                        // subjectItemBuild(
                        //     semesters[semesterIndex!]
                        //         .subjects[index],context);
                        subjectItemBuild(
                            semesters[semesterIndex].subjects[index], context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
