import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/models/subjects/subject_model.dart';
import 'package:lol/modules/subject/presentation/cubit/subject_cubit.dart';

class RemoveButton extends StatelessWidget {
  const RemoveButton({super.key, required this.material});
  final MaterialModel material;
  @override
  Widget build(BuildContext context) {
    var cubit = SubjectCubit.get(context);
    return BlocBuilder<SubjectCubit, SubjectState>(
      buildWhen: (previous, current) =>
          current is DeleteMaterialError ||
          current is DeleteMaterialLoading ||
          current is DeleteMaterialSuccess,
      builder: (context, state) {
        return MaterialButton(
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
        );
      },
    );
  }
}
