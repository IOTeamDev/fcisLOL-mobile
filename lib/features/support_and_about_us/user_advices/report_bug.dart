import 'package:flutter/material.dart';
import 'package:lol/core/utils/components.dart';
import 'package:lol/core/utils/resources/colors_manager.dart';
import 'package:lol/core/utils/resources/strings_manager.dart';
import 'package:lol/core/utils/resources/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/cubits/main_cubit/main_cubit.dart';
import '../../../core/utils/resources/constants_manager.dart';
import '../../../core/utils/resources/values_manager.dart';
import '../../../main.dart';

class ReportBug extends StatefulWidget {

  ReportBug({super.key});

  @override
  State<ReportBug> createState() => _ReportBugState();
}

class _ReportBugState extends State<ReportBug> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final Map<TextEditingController, TextDirection> _textDirections = {};

  @override
  void initState() {
    _addDirectionListener(_titleController);
    _addDirectionListener(_descriptionController);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          StringsManager.reportBug,
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  color: Provider.of<ThemeProvider>(context).isDark ? ColorsManager.darkPrimary : ColorsManager.grey3,
                  borderRadius: BorderRadius.circular(AppSizesDouble.s15),
                  border: Border.all(color: Provider.of<ThemeProvider>(context).isDark? ColorsManager.transparent: ColorsManager.grey.withValues(alpha: AppSizesDouble.s0_3))
                ),
                margin: EdgeInsetsDirectional.symmetric(horizontal: AppMargins.m15, vertical: AppMargins.m30),
                padding: const EdgeInsets.all(AppPaddings.p15),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        textDirection: getTextDirection(_titleController),
                        controller: _titleController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return StringsManager.emptyFieldWarning;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: StringsManager.bugTitle,
                          hintStyle: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Provider.of<ThemeProvider>(context).isDark? ColorsManager.lightGrey1: ColorsManager.black.withValues(alpha: 0.7)),
                          border: UnderlineInputBorder(),
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: ColorsManager.grey)),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: ColorsManager.lightPrimary)),
                        ),
                        cursorColor: ColorsManager.lightPrimary,
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Provider.of<ThemeProvider>(context).isDark? ColorsManager.white: ColorsManager.black)
                      ),
                      SizedBox(height: AppSizesDouble.s10,),
                      TextFormField(
                        minLines: AppSizes.s10,
                        maxLines: AppSizes.s10,
                        controller: _descriptionController,
                        textDirection: getTextDirection(_descriptionController),
                        keyboardType: TextInputType.multiline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return StringsManager.emptyFieldWarning;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: StringsManager.bugDescription,
                          hintStyle: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Provider.of<ThemeProvider>(context).isDark? ColorsManager.lightGrey1: ColorsManager.black.withValues(alpha: 0.7)),
                          border: UnderlineInputBorder(),
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: ColorsManager.grey)),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: ColorsManager.lightPrimary)),
                        ),
                        cursorColor: ColorsManager.lightPrimary,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Provider.of<ThemeProvider>(context).isDark? ColorsManager.white: ColorsManager.black)
                      ),
                      SizedBox(height: AppSizesDouble.s10,),
                      Padding(
                        padding: const EdgeInsetsDirectional.symmetric(horizontal: AppPaddings.p10),
                        child: Row(
                          children: [
                            //cancel button
                            ElevatedButton(
                              onPressed: () {
                                _titleController.clear();
                                _descriptionController.clear();
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizesDouble.s13)),
                                padding: EdgeInsetsDirectional.symmetric(horizontal: AppQueries.screenWidth(context) / AppSizes.s11),
                                backgroundColor: ColorsManager.white,
                                foregroundColor: ColorsManager.black,
                                textStyle: TextStyle(fontSize: AppQueries.screenWidth(context) / AppSizes.s17),
                              ),
                              child: const Text(StringsManager.cancel,),
                            ),
                            const Spacer(),
                            //submit button
                            ElevatedButton(
                              onPressed: () async {
                                sendBugReport(
                                  bugTitle: _titleController.text,
                                  bugDescription: _descriptionController.text,
                                );
                                _descriptionController.clear();
                                _titleController.clear();
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizesDouble.s13)),
                                padding: EdgeInsetsDirectional.symmetric(horizontal: AppQueries.screenWidth(context) / AppSizes.s11),
                                backgroundColor: ColorsManager.lightPrimary,
                                foregroundColor: Colors.white,
                                textStyle: TextStyle(fontSize: AppQueries.screenWidth(context) / AppSizes.s17),
                              ),
                              child: const Text(StringsManager.submit)
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future<void> sendBugReport({
    required String bugTitle,
    required String bugDescription,
  }) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final String subject = Uri.encodeComponent(bugTitle);
      final String body = Uri.encodeComponent(
        bugDescription,
      );

      final Uri emailUri = Uri(
        scheme: 'mailto',
        path: 'taemaomar65@gmail.com',
        query: 'subject=$subject&body=$body',
      );

      await launchUrl(emailUri);
    }
  }

  void _addDirectionListener(TextEditingController controller) {
    controller.addListener(() {
      if (controller.text.isNotEmpty) {
        final firstChar = controller.text[0];
        final isArabic = RegExp(r'^[\u0600-\u06FF]').hasMatch(firstChar);
        setState(() {
          _textDirections[controller] = isArabic ? TextDirection.rtl : TextDirection.ltr;
        });
      } else {
        setState(() {
          _textDirections[controller] = TextDirection.ltr; // Default to LTR when empty
        });
      }
    });
  }

  TextDirection getTextDirection(TextEditingController controller) {
    return _textDirections[controller] ?? TextDirection.ltr; // Default LTR
  }

  @override
  void dispose() {
    _titleController.removeListener(() {});
    _descriptionController.removeListener(() {});
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
