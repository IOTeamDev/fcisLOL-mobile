import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;
import 'package:lol/core/cubits/main_cubit/main_cubit.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit_states.dart';
import 'package:lol/core/utils/resources/icons_manager.dart';
import 'package:lol/core/utils/resources/strings_manager.dart';
import 'package:lol/core/utils/resources/theme_provider.dart';
import 'package:lol/features/admin/presentation/view_model/admin_cubit/admin_cubit.dart';
import 'package:lol/main.dart';
import 'package:lol/features/admin/presentation/view_model/admin_cubit/admin_cubit_states.dart';
import 'package:lol/core/utils/resources/constants_manager.dart';
import 'package:lol/core/utils/components.dart';
import 'package:provider/provider.dart';
import '../../../../../core/utils/resources/colors_manager.dart';
import '../../../../../core/utils/resources/values_manager.dart';

class EditAnnouncement extends StatefulWidget {
  final int id;
  final String semester;
  final String title;
  final String content;
  final String date;
  final int index;
  final String? imageLink;

  const EditAnnouncement({
    super.key,
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.semester,
    this.imageLink,
    required this.index,
  });

  @override
  _EditAnnouncementState createState() => _EditAnnouncementState();
}

class _EditAnnouncementState extends State<EditAnnouncement> {
  late TextEditingController titleController;
  late TextEditingController contentController;
  late TextEditingController _dateController;
  late IconData datePickerIcon;
  late int id;
  String? dueDateFormatted;
  String dueDateWord = StringsManager.dueDate.split(StringsManager.underScore).join(StringsManager.space);
  final _formKey = GlobalKey<FormState>();
  final Map<TextEditingController, TextDirection> _textDirections = {};
  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.title);
    contentController = TextEditingController(text: widget.content);
    _addDirectionListener(titleController);
    _addDirectionListener(contentController);
    _dateController = TextEditingController(
      text: widget.date == StringsManager.noDueDate ? dueDateWord:
      intl.DateFormat(StringsManager.dateFormat).format(DateTime.parse(widget.date))
    );
    datePickerIcon =  _dateController == StringsManager.noDueDate?IconsManager.closeIcon:IconsManager.datePickerIcon;
    _checkInitialDirection(titleController);
    _checkInitialDirection(contentController);

    _addDirectionListener(titleController);
    _addDirectionListener(contentController);

    id = widget.id;
  }


  @override
  void dispose() {
    titleController.removeListener((){});
    contentController.removeListener((){});
    titleController.dispose();
    contentController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<MainCubit, MainCubitStates>(
      listener: (context, state) {
        if (state is AdminUpdateAnnouncementSuccessState) {
          showToastMessage(
            message: StringsManager.announcementUpdated,
            states: ToastStates.SUCCESS
          );
          Navigator.pop(context, StringsManager.refresh);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              StringsManager.announcements,
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsetsDirectional.symmetric(horizontal: AppMargins.m15),
                padding: EdgeInsets.all(AppPaddings.p15),
                height: AppQueries.screenHeight(context) / AppSizesDouble.s1_45,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(AppSizesDouble.s20)
                ),
                child: Form(
                  key: _formKey,
                  child: Directionality(
                    textDirection: isArabicLanguage(context)? TextDirection.rtl:TextDirection.ltr,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: titleController,
                          textDirection: getTextDirection(titleController),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return StringsManager.emptyFieldWarning;
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: StringsManager.title,
                            hintStyle: Theme.of(context).textTheme.headlineMedium!.copyWith(color: ColorsManager.lightGrey1),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Provider.of<ThemeProvider>(context).isDark
                                ? ColorsManager.grey
                                : ColorsManager.white
                              )
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: AppSizesDouble.s10),
                        // Description Text Input
                        TextFormField(
                          controller: contentController,
                          textDirection: getTextDirection(contentController),
                          minLines: AppSizes.s12,
                          maxLines: AppSizes.s12,
                          decoration: InputDecoration(
                            hintText: StringsManager.description,
                            hintStyle: Theme.of(context).textTheme.headlineMedium!.copyWith(color: ColorsManager.lightGrey1),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Provider.of<ThemeProvider>(context).isDark
                                ? ColorsManager.grey
                                : ColorsManager.white
                              )
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: AppSizesDouble.s10),
                        SizedBox(
                          width: AppQueries.screenWidth(context) / AppSizes.s3,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_dateController.text != dueDateWord) {
                                setState(() {
                                  datePickerIcon = IconsManager.datePickerIcon;
                                  _dateController.text = dueDateWord;
                                });
                              } else {
                                _datePicker();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: AppSizesDouble.s15),
                                backgroundColor: ColorsManager.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizesDouble.s10))
                            ),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                Text(
                                  _dateController.text,
                                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: ColorsManager.black),
                                ),
                                SizedBox(
                                  width:
                                  AppSizesDouble.s5,
                                ),
                                Icon(
                                  datePickerIcon,
                                  color: ColorsManager.black,
                                ),
                              ],
                            ),
                          )
                        ),
                        const Spacer(),
                        divider(),
                        // Cancel and Accept Buttons
                        Padding(
                          padding: EdgeInsets.all(AppPaddings.p8),
                          child: Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context, 'nigga');
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(AppSizesDouble.s13)),
                                  padding: EdgeInsetsDirectional.symmetric(
                                      horizontal:
                                          AppQueries.screenWidth(context) / AppSizesDouble.s11),
                                  backgroundColor: ColorsManager.white,
                                  foregroundColor: ColorsManager.black,
                                  textStyle: TextStyle(fontSize: AppQueries.screenWidth(context) / AppSizesDouble.s17),
                                ),
                                child: const Text(StringsManager.cancel,),
                              ),
                              const Spacer(),
                              ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      AdminCubit.get(context).updateAnnouncement(
                                        id,
                                        title: titleController.text,
                                        content: contentController.text,
                                        dueDate: dueDateFormatted == StringsManager.noDueDate ? null : dueDateFormatted,
                                      );
                                    } else {
                                      // Show error if validation fails
                                      showToastMessage(
                                        message: StringsManager.fillAllFieldsWarning,
                                        states: ToastStates.ERROR,
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizesDouble.s13)),
                                    padding: EdgeInsetsDirectional.symmetric(
                                        horizontal: AppQueries.screenWidth(context) / AppSizes.s11),
                                    backgroundColor: ColorsManager.lightPrimary,
                                    foregroundColor: ColorsManager.white,
                                    textStyle: TextStyle(fontSize: AppQueries.screenWidth(context) / AppSizes.s17),
                                  ),
                                  child: const Text(StringsManager.submit)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  _datePicker() => showDatePicker(
    context: context,
    initialDate: DateTime.now().add(Duration(days: AppSizes.s1)),
    firstDate: DateTime.now().add(Duration(days: AppSizes.s1)),
    lastDate: DateTime.parse(StringsManager.endDate),
  ).then((value) {
    if (value != null) {
      setState(() {
        DateTime selectedDate = DateTime(value.year, value.month, value.day);
        dueDateFormatted = DateTime.utc(selectedDate.year, selectedDate.month, selectedDate.day).toIso8601String();
        _dateController.text = intl.DateFormat(StringsManager.dateFormat).format(value);
        datePickerIcon = IconsManager.closeIcon;
      });
    }
  });

  void _addDirectionListener(TextEditingController controller) {
    controller.addListener(() {
      final text = controller.text;
      TextDirection newDirection = TextDirection.ltr;
      if (text.isNotEmpty) {
        final firstChar = text[0];
        final isArabic = RegExp(r'^[\u0600-\u06FF]').hasMatch(firstChar);
        newDirection = isArabic ? TextDirection.rtl : TextDirection.ltr;
      }

      if (_textDirections[controller] != newDirection) {
        setState(() {
          _textDirections[controller] = newDirection;
        });
      }
    });
  }

  void _checkInitialDirection(TextEditingController controller) {
    final text = controller.text;
    if (text.isNotEmpty) {
      final firstChar = text[0];
      final isArabic = RegExp(r'^[\u0600-\u06FF]').hasMatch(firstChar);
      _textDirections[controller] = isArabic ? TextDirection.rtl : TextDirection.ltr;
    }
  }

// Update getTextDirection to handle null values
  TextDirection getTextDirection(TextEditingController controller) {
    return _textDirections[controller] ??
        (isArabicLanguage(context) ? TextDirection.rtl : TextDirection.ltr);
  }

}
