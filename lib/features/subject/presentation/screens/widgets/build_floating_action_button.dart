import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lol/main.dart';
import 'package:lol/modules/admin/bloc/admin_cubit.dart';
import 'package:lol/modules/auth/screens/login.dart';
import 'package:lol/features/subject/presentation/cubit/add_material_cubit/add_material_cubit.dart';
import 'package:lol/features/subject/presentation/cubit/get_material_cubit/get_material_cubit_cubit.dart';
import 'package:lol/features/subject/presentation/screens/widgets/build_bottom_sheet.dart';
import 'package:lol/shared/components/constants.dart';
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
          if (TOKEN == null) {
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
                Provider.of<ThemeProvide>(context, listen: false)
                    .changeMode(dontWannaDark: true);
                Provider.of<ThemeProvide>(context, listen: false)
                    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                    .notifyListeners();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                    (route) => false);
              },
            ).show();
          } else {
            _titleController.text = '';
            _descriptionController.text = '';
            _linkController.text = '';
            showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) => MultiBlocProvider(
                      providers: [
                        BlocProvider(
                          create: (context) => AddMaterialCubit(AdminCubit()),
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
                            subjectName: widget.subjectName),
                      ),
                    ));
          }
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        backgroundColor:
            isDark ? Color.fromRGBO(71, 100, 197, 1) : HexColor('#757575'),
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }
}
