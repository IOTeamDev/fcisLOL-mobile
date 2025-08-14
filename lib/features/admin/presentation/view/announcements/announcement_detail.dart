import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;
import 'package:linkify/linkify.dart';
import 'package:lol/core/presentation/screen_size.dart';
import 'package:lol/core/resources/theme/colors_manager.dart';
import 'package:lol/core/resources/theme/values/app_strings.dart';
import 'package:lol/core/resources/theme/theme_provider.dart';
import 'package:lol/core/resources/theme/values/values_manager.dart';
import 'package:lol/main.dart';
import 'package:lol/features/admin/presentation/view_model/admin_cubit/admin_cubit_states.dart';
import 'package:lol/features/admin/presentation/view/announcements/announcement_detail.dart';
import 'package:lol/core/resources/constants/constants_manager.dart';
import 'package:lol/core/utils/components.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:lol/core/utils/navigation.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lol/core/utils/webview_screen.dart';
import '../../../../../core/presentation/cubits/main_cubit/main_cubit.dart';
import '../../view_model/admin_cubit/admin_cubit.dart';

class AnnouncementDetail extends StatefulWidget {
  final String title;
  final String description;
  final dynamic date;
  final String semester;

  const AnnouncementDetail(
      {super.key,
      required this.title,
      required this.description,
      required this.date,
      required this.semester});

  @override
  State<AnnouncementDetail> createState() => _AnnouncementDetailState();
}

class _AnnouncementDetailState extends State<AnnouncementDetail> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCubit, AdminCubitStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final content = widget.description.isEmpty
            ? AppStrings.noContent
            : widget.description;
        final isContentRtl = intl.Bidi.detectRtlDirectionality(content);
        final textDirection = widget.description.isEmpty
            ? (isArabicLanguage(context)
                ? TextDirection.rtl
                : TextDirection.ltr)
            : (isContentRtl ? TextDirection.rtl : TextDirection.ltr);

        return Scaffold(
          appBar: AppBar(
            title: Text(
              AppStrings.announcements,
              style: Theme.of(context).textTheme.displayMedium,
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Container(
                constraints: BoxConstraints(
                  maxHeight: ScreenSize.height(context) / AppSizesDouble.s1_4,
                ),
                margin: const EdgeInsets.symmetric(
                    horizontal: AppMargins.m15, vertical: AppMargins.m20),
                padding: const EdgeInsets.all(AppPaddings.p18),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(AppSizesDouble.s20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      child: SelectableText(
                        widget.title,
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge!
                            .copyWith(
                                fontSize:
                                    ScreenSize.width(context) / AppSizes.s13,
                                color: ColorsManager.white),
                      ),
                      alignment: isArabicLanguage(context)
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                    ),
                    SizedBox(
                      height: AppSizesDouble.s30,
                      child: divider(),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Directionality(
                          textDirection: textDirection,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Builder(builder: (context) {
                                return SelectableLinkify(
                                  onOpen: (link) => onOpen(context, link),
                                  text: content,
                                  style: const TextStyle(
                                    color: ColorsManager.white,
                                  ),
                                  linkStyle: const TextStyle(
                                      color: ColorsManager.dodgerBlue,
                                      decorationColor:
                                          ColorsManager.dodgerBlue),
                                  linkifiers: const [
                                    UrlLinkifier(),
                                    EmailLinkifier(),
                                    PhoneNumberLinkifier(),
                                  ],
                                  textAlign: TextAlign.start,
                                  textDirection: textDirection,
                                  contextMenuBuilder: (context, state) {
                                    final textController =
                                        state.textEditingValue;
                                    final selection = textController.selection;
                                    String selectedText =
                                        widget.description.substring(
                                      selection.baseOffset
                                          .clamp(0, widget.description.length),
                                      selection.extentOffset
                                          .clamp(0, widget.description.length),
                                    );
                                    return AdaptiveTextSelectionToolbar(
                                      anchors: state.contextMenuAnchors,
                                      children: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            if (selectedText.isNotEmpty) {
                                              Clipboard.setData(ClipboardData(
                                                  text: selectedText));
                                            }
                                            //Navigator.of(context).pop(); // Close context menu
                                          },
                                          child: const Text(
                                            AppStrings.copy,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            // Select all text
                                            state.selectAll(
                                                SelectionChangedCause.tap);
                                          },
                                          child:
                                              const Text(AppStrings.selectAll),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.only(top: AppPaddings.p5),
                      child: Text(
                        AppStrings.deadLine +
                            AppStrings.colon +
                            AppStrings.space +
                            (widget.date == AppStrings.noDueDate
                                ? widget.date
                                : intl.DateFormat(AppStrings.dateFormat)
                                    .format(DateTime.parse(widget.date))
                                    .toString()),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  bool isArabicLanguage(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ar';
  }
}
