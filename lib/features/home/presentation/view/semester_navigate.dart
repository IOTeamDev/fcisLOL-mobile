import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit.dart';
import 'package:lol/core/utils/resources/theme_provider.dart';
import 'package:lol/core/utils/resources/values_manager.dart';
import 'package:lol/features/home/presentation/view/home.dart';
import 'package:lol/features/home/presentation/view/widgets/subject_item_build.dart';
import 'package:lol/main.dart';
import 'package:lol/features/home/data/models/semster_model.dart';
import 'package:lol/core/utils/components.dart';
import 'package:lol/core/utils/resources/constants_manager.dart';
import 'package:lol/core/utils/navigation.dart';
import 'package:provider/provider.dart';

class SemesterNavigate extends StatelessWidget {
  final String semester;
  const SemesterNavigate({super.key, required this.semester});

  @override
  Widget build(BuildContext context) {
    int semesterIndex = semsesterIndex(semester);
    return Scaffold(
      appBar: AppBar(
        title: Text('Semester $semester', style: Theme.of(context).textTheme.displayMedium,),
      ),
      body: Padding(
        padding: EdgeInsets.all(AppPaddings.p15),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 40,
              ),
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: AppSizes.s2, // Two items per row
                  crossAxisSpacing: AppSizesDouble.s10,
                  mainAxisSpacing: AppSizesDouble.s10,
                ),
                itemCount: semesters[semesterIndex].subjects.length,
                itemBuilder: (context, index) {
                  return SubjectItemBuild(
                    subject: semesters[semesterIndex].subjects[index],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
