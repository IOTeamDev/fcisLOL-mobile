import 'package:flutter/material.dart';
import 'package:lol/core/utils/resources/colors_manager.dart';
import 'package:lol/core/utils/resources/constants_manager.dart';
import 'package:lol/core/utils/resources/theme_provider.dart';
import 'package:lol/features/subject/presentation/screens/widgets/bottom_sheet_button.dart';
import 'package:lol/features/subject/presentation/screens/widgets/build_text_form_field.dart';
import 'package:provider/provider.dart';

class EditMaterialBottomSheet extends StatefulWidget {
  const EditMaterialBottomSheet(
      {super.key,
      required this.title,
      required this.description,
      required this.link});
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
    return Container(
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
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {}
                        },
                      ),
                    ],
                  )
                ],
              )),
        ));
  }
}
