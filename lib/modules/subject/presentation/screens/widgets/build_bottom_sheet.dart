import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lol/layout/home/bloc/main_cubit.dart';
import 'package:lol/main.dart';
import 'package:lol/models/subjects/subject_model.dart';
import 'package:lol/modules/subject/presentation/cubit/subject_cubit.dart';
import 'package:lol/modules/subject/presentation/screens/widgets/build_text_form_field.dart';
import 'package:lol/shared/components/constants.dart';

class BuildBottomSheet extends StatefulWidget {
  const BuildBottomSheet(
      {super.key,
      required this.titleController,
      required this.descriptionController,
      required this.linkController,
      required this.subjectName});
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController linkController;
  final String subjectName;

  @override
  State<BuildBottomSheet> createState() => _BuildBottomSheetState();
}

class _BuildBottomSheetState extends State<BuildBottomSheet> {
  bool wannaProfileModel = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var cubit = SubjectCubit.get(context);
    return Container(
        decoration: BoxDecoration(
          color: isDark ? Color.fromRGBO(59, 59, 59, 1) : HexColor('#757575'),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(16),
        width: screenWidth(context),
        child: SingleChildScrollView(
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: BuildTextFormField(
                      controller: widget.titleController,
                      hintText: 'Title (e.g:chapter3)',
                      canBeEmpty: false,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: BuildTextFormField(
                      controller: widget.descriptionController,
                      hintText: 'Description (Optional)',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: BuildTextFormField(
                      controller: widget.linkController,
                      hintText: 'Material Link',
                      canBeEmpty: false,
                      textInputAction: TextInputAction.done,
                      textInputType: TextInputType.url,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin:
                              const EdgeInsets.only(left: 0, top: 0, bottom: 0),
                          padding: const EdgeInsets.all(10),
                          width: screenWidth(context) / 3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color.fromRGBO(71, 100, 197, 1),
                          ),
                          child: Text(
                            cubit.selectedType.toLowerCase(),
                            style: TextStyle(color: Colors.white, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        PopupMenuButton(
                            onSelected: (type) {
                              cubit.changeType(type: type);
                            },
                            iconColor: Colors.white,
                            itemBuilder: (context) {
                              return [
                                PopupMenuItem(
                                  value: cubit.item1,
                                  child: const Text('Video'),
                                ),
                                PopupMenuItem(
                                  value: cubit.item2,
                                  child: const Text(
                                    'Document',
                                  ),
                                )
                              ];
                            }),
                      ],
                    ),
                  ),
                  //Cancel and submit buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Cancel Button
                      MaterialButton(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        minWidth: screenWidth(context) / 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        color: Colors.white,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                              color: Color.fromRGBO(35, 37, 42, 1),
                              fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      //Submit Button
                      if (TOKEN != null)
                        MaterialButton(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          minWidth: screenWidth(context) / 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          color: Color.fromRGBO(71, 100, 197, 1),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              AuthorModel author = AuthorModel(
                                  authorName:
                                      MainCubit.get(context).profileModel?.name,
                                  authorPhoto: MainCubit.get(context)
                                      .profileModel
                                      ?.photo);
                              BlocProvider.of<SubjectCubit>(context)
                                  .addMaterial(
                                      title: widget.titleController.text,
                                      description:
                                          widget.descriptionController.text,
                                      link: widget.linkController.text,
                                      type: cubit.selectedType,
                                      subjectName: widget.subjectName,
                                      semester: MainCubit.get(context)
                                          .profileModel!
                                          .semester,
                                      role: MainCubit.get(context)
                                          .profileModel!
                                          .role,
                                      author: author);
                              Navigator.of(context).pop();
                            }
                          },
                          child: Text(
                            'Submit',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                    ],
                  )
                ],
              )),
        ));
  }
}
