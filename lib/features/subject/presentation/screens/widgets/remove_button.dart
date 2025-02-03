import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/features/subject/data/models/material_model.dart';
import 'package:lol/features/subject/presentation/cubit/get_material_cubit/get_material_cubit_cubit.dart';
import 'package:lol/core/utils/components.dart';

class RemoveButton extends StatelessWidget {
  const RemoveButton({super.key, required this.material});
  final MaterialModel material;
  @override
  Widget build(BuildContext context) {
    var cubit = GetMaterialCubit.get(context);
    return BlocListener<GetMaterialCubit, GetMaterialState>(
      listener: (context, state) {
        if (state is DeleteMaterialSuccess) {
          showToastMessage(
              message: 'Material Deleted', states: ToastStates.SUCCESS);
        } else if (state is DeleteMaterialError) {
          showToastMessage(
              message: 'error while deleting material',
              states: ToastStates.ERROR);
        }
      },
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        minWidth: 30,
        height: 50,
        color: Colors.white,
        onPressed: () {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.warning,
            animType: AnimType.rightSlide,
            title: 'Sure about deleting "${material.title}"?',
            btnOkText: "Delete",
            btnCancelOnPress: () {},
            btnOkOnPress: () {
              cubit.deleteMaterial(
                  id: material.id!, subjectName: material.subject!);
            },
          ).show();
        },
        child: Icon(
          Icons.delete,
          color: Color.fromRGBO(206, 58, 60, 1),
          size: 25,
        ),
      ),
    );
  }
}
