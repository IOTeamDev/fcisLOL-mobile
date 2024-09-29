import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lol/layout/home/bloc/main_cubit.dart';
import 'package:lol/layout/home/home.dart';
import 'package:lol/models/subjects/semster_model.dart';
import 'package:lol/shared/components/components.dart';
import 'package:lol/shared/components/navigation.dart';

class SemesterNavigate extends StatelessWidget {
  final String semester;
  const SemesterNavigate({super.key, required this.semester});

  @override
  Widget build(BuildContext context) {
    int semesterIndex = semsesterIndex(semester);
    return Scaffold(
      backgroundColor: const Color(0xff1B262C),
      appBar: AppBar(
        title: InkWell(
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text("Home")],
          ),
          onTap: () => navigatReplace(context, const Home()),
        ),
        backgroundColor: const Color(0xff0F4C75),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 5),
                child: Text(
                  "Semester $semester",
                  style: GoogleFonts.montserrat(
                      fontSize: 30,
                      color: Colors.red, //
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
                  childAspectRatio: 1.3, // Control the height and width ratio
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
    );
  }
}
