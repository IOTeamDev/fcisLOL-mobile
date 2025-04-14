import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/core/utils/components.dart';
import 'package:lol/core/utils/resources/colors_manager.dart';
import 'package:lol/core/utils/resources/constants_manager.dart';
import 'package:lol/core/utils/resources/theme_provider.dart';
import 'package:lol/features/subject/presentation/view_model/add_material_cubit/add_material_cubit.dart';
import 'package:lol/features/subject/presentation/view_model/get_material_cubit/get_material_cubit.dart';
import 'package:lol/features/subject/presentation/screens/widgets/bottom_sheet_button.dart';
import 'package:lol/features/subject/presentation/screens/widgets/build_text_form_field.dart';
import 'package:provider/provider.dart';

class EditMaterialBottomSheet extends StatefulWidget {
  const EditMaterialBottomSheet(
      {super.key,
      required this.title,
      required this.description,
      required this.link,
      required this.id,
      required this.subjectName});
  final String subjectName;
  final int id;
  final String title;
  final String description;
  final String link;

  @override
  State<EditMaterialBottomSheet> createState() =>
      _EditMaterialBottomSheetState();
}

class _EditMaterialBottomSheetState extends State<EditMaterialBottomSheet> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _linkController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _linkController = TextEditingController();
    _titleController.text = widget.title;
    _descriptionController.text = widget.description;
    _linkController.text = widget.link;
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _linkController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('material id=>>>>>>>>>>>>>>>${widget.id}');
    print('material id=>>>>>>>>>>>>>>>${widget.subjectName}');
    print('material id=>>>>>>>>>>>>>>>${widget.title}');
    print('material id=>>>>>>>>>>>>>>>${widget.description}');
    print('material id=>>>>>>>>>>>>>>>${widget.link}');
    return BlocListener<AddMaterialCubit, AddMaterialState>(
      listener: (context, state) {
        if (state is EditMaterialLoading) {
          showToastMessage(
              message: 'Editting Material', states: ToastStates.WARNING);
        }
        if (state is EditMaterialSuccess) {
          Navigator.of(context).pop();
          showToastMessage(
              message: 'Changes Saved Successfully',
              states: ToastStates.SUCCESS);
          _getMaterials(context);
        }
        if (state is EditMaterialFailed) {
          showToastMessage(
              message: 'Something Went Wrong', states: ToastStates.ERROR);
          Navigator.of(context).pop();
        }
      },
      child: Container(
          decoration: BoxDecoration(
            color: Provider.of<ThemeProvider>(context).isDark
                ? ColorsManager.darkPrimary
                : ColorsManager.lightGrey,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(16),
          width: AppQueries.screenWidth(context),
          child: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: BuildTextFormField(
                        controller: _titleController,
                        hintText: 'Title (e.g:chapter3)',
                        canBeEmpty: false,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: BuildTextFormField(
                        controller: _descriptionController,
                        hintText: 'Description (Optional)',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: BuildTextFormField(
                        controller: _linkController,
                        hintText: 'Material Link',
                        canBeEmpty: false,
                        textInputAction: TextInputAction.done,
                        textInputType: TextInputType.url,
                      ),
                    ),
                    //Cancel and submit buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //Cancel Button
                        BottomSheetButton(
                          text: 'Cancel',
                          color: ColorsManager.white,
                          textStyle: TextStyle(
                              color: ColorsManager.darkGrey, fontSize: 20),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        //Submit Button
                        BottomSheetButton(
                          text: 'Save',
                          color: ColorsManager.lightPrimary,
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await AddMaterialCubit.get(context).editMaterial(
                                  id: widget.id,
                                  title: _titleController.text,
                                  description: _descriptionController.text,
                                  link: _linkController.text);
                            }
                          },
                        ),
                      ],
                    )
                  ],
                )),
          )),
    );
  }

  void _getMaterials(BuildContext context) async {
    try {
      await context
          .read<GetMaterialCubit>()
          .getMaterials(subject: widget.subjectName);
    } catch (e) {
      print('error while getting materials from addMaterialCubit $e');
    }
  }
}
