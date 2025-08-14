import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/core/resources/theme/colors_manager.dart';
import 'package:lol/features/subject/data/models/material_model.dart';
import 'package:lol/features/subject/presentation/view_model/add_material_cubit/add_material_cubit.dart';
import 'package:lol/features/subject/presentation/view_model/get_material_cubit/get_material_cubit.dart';
import 'package:lol/features/subject/presentation/screens/widgets/build_bottom_sheet.dart';
import 'package:lol/features/subject/presentation/screens/widgets/edit_material_bottom_sheet.dart';

import '../../../../../core/resources/theme/values/values_manager.dart';

class EditButton extends StatelessWidget {
  const EditButton(
      {super.key, required this.material, required this.getMaterialCubit});
  final MaterialModel material;
  final GetMaterialCubit getMaterialCubit;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      minWidth: 20,
      height: 40,
      color: ColorsManager.white,
      onPressed: () {
        showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) => AddMaterialCubit(),
                    ),
                    BlocProvider.value(value: getMaterialCubit),
                  ],
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: EditMaterialBottomSheet(
                      title: material.title!,
                      description: material.description!,
                      link: material.link!,
                      id: material.id!,
                      subjectName: material.subject!,
                    ),
                  ),
                ));
      },
      child: Icon(
        Icons.edit_outlined,
        color: ColorsManager.black,
        size: 25,
      ),
      padding: EdgeInsets.symmetric(horizontal: AppPaddings.p10),
    );
  }
}
