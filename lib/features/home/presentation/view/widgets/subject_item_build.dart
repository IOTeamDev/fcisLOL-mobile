import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/core/utils/dependencies_helper.dart';
import 'package:lol/core/utils/navigation.dart';
import 'package:lol/core/utils/resources/colors_manager.dart';
import 'package:lol/core/utils/resources/fonts_manager.dart';
import 'package:lol/core/utils/resources/strings_manager.dart';
import 'package:lol/core/utils/resources/theme_provider.dart';
import 'package:lol/core/utils/resources/values_manager.dart';
import 'package:lol/features/subject/data/repos/subject_repo_imp.dart';
import 'package:lol/features/subject/presentation/view_model/get_material_cubit/get_material_cubit.dart';
import 'package:lol/features/subject/presentation/screens/subject_details.dart';
import 'package:provider/provider.dart';

import '../../../data/models/semster_model.dart';

class SubjectItemBuild extends StatelessWidget {
  const SubjectItemBuild({super.key, required this.subject});
  final SubjectModel subject;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigate(
            context,
            BlocProvider(
              create: (context) =>
                  GetMaterialCubit(getIt.get<SubjectRepoImp>()),
              child: SubjectDetails(
                subjectName: subject.subjectName,
              ),
            ));
      },
      child: Card(
        elevation: AppSizesDouble.s12, // More elevation for depth
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizesDouble.s16),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Container(
          padding: EdgeInsets.all(AppPaddings.p5),
          decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(subject.subjectImage,
                  height: AppSizesDouble.s70, color: Colors.white),
              SizedBox(
                height: AppSizesDouble.s10,
              ),
              Text(
                textAlign: TextAlign.center,
                subject.subjectName
                    .replaceAll(StringsManager.underScore, StringsManager.space)
                    .replaceAll(
                        StringsManager.andWord, StringsManager.andSymbol),
                maxLines: AppSizes.s2,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeightManager.semiBold,
                    color: ColorsManager.white),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
