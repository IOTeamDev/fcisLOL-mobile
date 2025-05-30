import 'dart:developer' as dev;
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit.dart';
import 'package:lol/core/utils/resources/colors_manager.dart';
import 'package:lol/core/utils/resources/theme_provider.dart';
import 'package:lol/features/admin/presentation/view_model/admin_cubit/admin_cubit.dart';
import 'package:lol/features/subject/presentation/screens/widgets/bottom_sheet_button.dart';
import 'package:lol/main.dart';
import 'package:lol/features/subject/data/models/author_model.dart';
import 'package:lol/features/subject/data/models/material_model.dart';
import 'package:lol/features/subject/presentation/view_model/add_material_cubit/add_material_cubit.dart';
import 'package:lol/features/subject/presentation/view_model/get_material_cubit/get_material_cubit.dart';
import 'package:lol/features/subject/presentation/screens/widgets/build_text_form_field.dart';
import 'package:lol/core/utils/components.dart';
import 'package:lol/core/utils/resources/constants_manager.dart';
import 'package:provider/provider.dart';

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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var cubit = AddMaterialCubit.get(context);
    return BlocListener<AddMaterialCubit, AddMaterialState>(
      listener: (context, state) async {
        if (state is AddMaterialSuccessUser) {
          showToastMessage(
              message:
                  'The request has been sent to the Admin, and waiting for approval...',
              states: ToastStates.SUCCESS);
          AdminCubit.get(context).sendNotificationToUsers(
              sendToAdmin: true,
              semester: MainCubit.get(context).profileModel!.semester,
              title: cubit.notificationsMaterialTitle[
                  Random().nextInt(cubit.notificationsMaterialTitle.length)],
              body:
                  "${MainCubit.get(context).profileModel!.name} wants to add a material in ${widget.subjectName.replaceAll('_', " ").replaceAll("and", "&")} !");
          Navigator.of(context).pop();
        }
        if (state is AddMaterialSuccessAdmin) {
          await context.read<MainCubit>().acceptRequest(
              state.materialId!,
              context.read<MainCubit>().profileModel!.semester,
              context.read<MainCubit>().profileModel!.role);
          await _getMaterials(context);
          showToastMessage(
              message: 'Material Added Successfully',
              states: ToastStates.SUCCESS);
          Navigator.of(context).pop();
        }
        if (state is AddMaterialFailed) {
          showToastMessage(
              message: 'Error while uploading Material',
              states: ToastStates.ERROR);
          Navigator.of(context).pop();
        }
        if (state is AddMaterialLoading) {
          showToastMessage(
              message: 'Uploading Material........',
              states: ToastStates.WARNING);
          await AdminCubit.get(context).getFcmTokens();
        }
      },
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaY: 3, sigmaX: 3),
        child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
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
                              margin: const EdgeInsets.only(
                                  left: 0, top: 0, bottom: 0),
                              padding: const EdgeInsets.all(10),
                              width: AppQueries.screenWidth(context) / 3,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Color.fromRGBO(71, 100, 197, 1),
                              ),
                              child: Text(
                                cubit.selectedType.toLowerCase(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            PopupMenuButton(
                                color:
                                    Provider.of<ThemeProvider>(context).isDark
                                        ? ColorsManager.darkPrimary
                                        : Colors.white,
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
                            text: 'Submit',
                            color: ColorsManager.lightPrimary,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                AuthorModel author = AuthorModel(
                                    authorId:
                                        MainCubit.get(context).profileModel?.id,
                                    authorName: MainCubit.get(context)
                                        .profileModel
                                        ?.name,
                                    authorPhoto: MainCubit.get(context)
                                        .profileModel
                                        ?.photo);
                                BlocProvider.of<AddMaterialCubit>(context)
                                    .addMaterial(
                                        title: widget.titleController.text,
                                        description:
                                            widget.descriptionController.text,
                                        link: widget.linkController.text,
                                        type: cubit.selectedType,
                                        subjectName: widget.subjectName,
                                        semester: AppConstants
                                                        .navigatedSemester !=
                                                    MainCubit.get(context)
                                                        .profileModel!
                                                        .semester &&
                                                AppConstants
                                                        .navigatedSemester !=
                                                    null
                                            ? AppConstants.navigatedSemester!
                                            : MainCubit
                                                    .get(context)
                                                .profileModel!
                                                .semester,
                                        role: MainCubit.get(context)
                                            .profileModel!
                                            .role,
                                        author: author);
                              }
                            },
                          ),
                        ],
                      )
                    ],
                  )),
            )),
      ),
    );
  }

  Future<void> _getMaterials(BuildContext context) async {
    try {
      await context
          .read<GetMaterialCubit>()
          .getMaterials(subject: widget.subjectName);
      dev.log('get materials from addMaterialCubit');
    } catch (e) {
      debugPrint('error while getting materials from addMaterialCubit $e');
    }
  }
}
