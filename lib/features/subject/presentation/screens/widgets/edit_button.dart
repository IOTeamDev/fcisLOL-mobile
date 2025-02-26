import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/core/utils/resources/colors_manager.dart';
import 'package:lol/features/subject/data/models/material_model.dart';
import 'package:lol/features/subject/presentation/cubit/add_material_cubit/add_material_cubit.dart';
import 'package:lol/features/subject/presentation/cubit/get_material_cubit/get_material_cubit_cubit.dart';
import 'package:lol/features/subject/presentation/screens/widgets/build_bottom_sheet.dart';
import 'package:lol/features/subject/presentation/screens/widgets/edit_material_bottom_sheet.dart';

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
      minWidth: 30,
      height: 50,
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
                        link: material.link!),
                  ),
                ));
      },
      child: Icon(
        Icons.edit_outlined,
        color: Color(0xffCE3A3C),
        size: 25,
      ),
    );
  }
}
