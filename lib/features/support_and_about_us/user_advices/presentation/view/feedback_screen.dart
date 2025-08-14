import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lol/core/presentation/cubits/main_cubit/main_cubit_states.dart';
import 'package:lol/core/presentation/screen_size.dart';
import 'package:lol/core/utils/components.dart';
import 'package:lol/core/resources/theme/colors_manager.dart';
import 'package:lol/core/resources/theme/values/app_strings.dart';
import 'package:lol/core/resources/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/presentation/cubits/main_cubit/main_cubit.dart';
import '../../../../../core/resources/constants/constants_manager.dart';
import '../../../../../core/resources/theme/values/values_manager.dart';
import '../../../../../main.dart';

class FeedbackScreen extends StatefulWidget {
  FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _feedbackController = TextEditingController();

  final Map<TextEditingController, TextDirection> _textDirections = {};

  @override
  void initState() {
    _addDirectionListener(_feedbackController);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.feedback,
          style: Theme.of(context).textTheme.displayMedium,
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<MainCubit, MainCubitStates>(
        listener: (context, state) {},
        builder: (context, state) => SingleChildScrollView(
          child: _buildFeedBackForm(context),
        ),
      ),
    );
  }

  Widget _buildFeedBackForm(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Provider.of<ThemeProvider>(context).isDark
              ? ColorsManager.darkPrimary
              : ColorsManager.grey3,
          borderRadius: BorderRadius.circular(AppSizesDouble.s15),
          border: Border.all(
              color: Provider.of<ThemeProvider>(context).isDark
                  ? ColorsManager.transparent
                  : ColorsManager.grey.withValues(alpha: AppSizesDouble.s0_3))),
      margin: EdgeInsetsDirectional.symmetric(
          horizontal: AppMargins.m15, vertical: AppMargins.m30),
      padding: const EdgeInsets.all(AppPaddings.p15),
      child: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  minLines: AppSizes.s12,
                  maxLines: AppSizes.s12,
                  controller: _feedbackController,
                  textDirection: getTextDirection(_feedbackController),
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStrings.emptyFieldWarning;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: AppStrings.feedback,
                    hintStyle: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .copyWith(
                            color: Provider.of<ThemeProvider>(context).isDark
                                ? ColorsManager.lightGrey1
                                : ColorsManager.black.withValues(alpha: 0.7)),
                    border: UnderlineInputBorder(),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: ColorsManager.grey)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: ColorsManager.lightPrimary)),
                  ),
                  cursorColor: ColorsManager.lightPrimary,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Provider.of<ThemeProvider>(context).isDark
                          ? ColorsManager.white
                          : ColorsManager.black),
                ),
                SizedBox(
                  height: AppSizesDouble.s10,
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: AppPaddings.p10),
                  child: Row(
                    children: [
                      //cancel button
                      ElevatedButton(
                        onPressed: () {
                          _feedbackController.clear();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppSizesDouble.s13)),
                          padding: EdgeInsetsDirectional.symmetric(
                              horizontal:
                                  ScreenSize.width(context) / AppSizes.s11),
                          backgroundColor: ColorsManager.white,
                          foregroundColor: ColorsManager.black,
                          textStyle: TextStyle(
                              fontSize:
                                  ScreenSize.width(context) / AppSizes.s17),
                        ),
                        child: const Text(
                          AppStrings.cancel,
                        ),
                      ),
                      const Spacer(),
                      //submit button
                      ElevatedButton(
                          onPressed: () async {
                            sendFeedback(
                              feedbackDescription: _feedbackController.text,
                            );
                            _feedbackController.clear();
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(AppSizesDouble.s13)),
                            padding: EdgeInsetsDirectional.symmetric(
                                horizontal:
                                    ScreenSize.width(context) / AppSizes.s11),
                            backgroundColor: ColorsManager.lightPrimary,
                            foregroundColor: Colors.white,
                            textStyle: TextStyle(
                                fontSize:
                                    ScreenSize.width(context) / AppSizes.s17),
                          ),
                          child: const Text(AppStrings.submit)),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Future<void> sendFeedback({required String feedbackDescription}) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      MainCubit.get(context).sendReportBugOrFeedBack(
          '\n\nFeedBack\n\n$feedbackDescription',
          isFeedback: true);
    }
  }

  void _addDirectionListener(TextEditingController controller) {
    controller.addListener(() {
      if (controller.text.isNotEmpty) {
        final firstChar = controller.text[0];
        final isArabic = RegExp(r'^[\u0600-\u06FF]').hasMatch(firstChar);
        setState(() {
          _textDirections[controller] =
              isArabic ? TextDirection.rtl : TextDirection.ltr;
        });
      } else {
        setState(() {
          _textDirections[controller] =
              TextDirection.ltr; // Default to LTR when empty
        });
      }
    });
  }

  TextDirection getTextDirection(TextEditingController controller) {
    return _textDirections[controller] ?? TextDirection.ltr; // Default LTR
  }

  @override
  void dispose() {
    _feedbackController.removeListener(() {});
    _feedbackController.dispose();
    super.dispose();
  }
}
