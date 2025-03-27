import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit.dart';
import 'package:lol/core/network/local/shared_preference.dart';
import 'package:lol/core/utils/resources/colors_manager.dart';
import 'package:lol/core/utils/resources/strings_manager.dart';
import 'package:lol/core/utils/resources/theme_provider.dart';
import 'package:lol/features/auth/presentation/view/registration_layout.dart';
import 'package:lol/main.dart';
import 'package:lol/features/admin/presentation/view_model/admin_cubit/admin_cubit.dart';
import 'package:lol/features/auth/presentation/view/login.dart';
import 'package:lol/features/subject/presentation/cubit/add_material_cubit/add_material_cubit.dart';
import 'package:lol/features/subject/presentation/cubit/get_material_cubit/get_material_cubit.dart';
import 'package:lol/features/subject/presentation/screens/widgets/build_bottom_sheet.dart';
import 'package:lol/core/utils/resources/constants_manager.dart';
import 'package:provider/provider.dart';

class BuildFloatingActionButton extends StatefulWidget {
  const BuildFloatingActionButton({
    super.key,
    required this.subjectName,
    required this.getMaterialCubit,
  });
  final String subjectName;
  final GetMaterialCubit getMaterialCubit;

  @override
  State<BuildFloatingActionButton> createState() =>
      _BuildFloatingActionButtonState();
}

class _BuildFloatingActionButtonState extends State<BuildFloatingActionButton> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _linkController;
  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _linkController = TextEditingController();
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
    return SizedBox(
      height: 70,
      width: 70,
      child: FloatingActionButton(
        onPressed: () {
          if (AppConstants.TOKEN == null) {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.info,
              animType: AnimType.rightSlide,
              // titleTextStyle: TextStyle(fontSize: 12),
              title: "Log in to continue adding material.",
              btnOkText: "Sign in",
              btnCancelText: "Maybe later",
              btnCancelOnPress: () {},
              btnOkOnPress: () {
                Cache.writeData(key: KeysManager.isDark, value: false);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegistrationLayout(),
                    ),
                    (route) => false);
              },
            ).show();
          } else {
            _titleController.text = '';
            _descriptionController.text = '';
            _linkController.text = '';
            showModalBottomSheet(
              sheetAnimationStyle: AnimationStyle(curve: Curves.easeInOut,duration: Duration(milliseconds: 650), reverseCurve: Curves.fastOutSlowIn, reverseDuration: Duration(milliseconds: 600)),
              isScrollControlled: true,
              context: context,
              builder: (context) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => AddMaterialCubit(),
                  ),
                  BlocProvider.value(value: widget.getMaterialCubit),
                ],
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: BuildBottomSheet(
                    titleController: _titleController,
                    descriptionController: _descriptionController,
                    linkController: _linkController,
                    subjectName: widget.subjectName
                  ),
                ),
              )
            );
          }
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        backgroundColor: Provider.of<ThemeProvider>(context).isDark
            ? ColorsManager.lightPrimary
            : ColorsManager.lightGrey,
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }
}
