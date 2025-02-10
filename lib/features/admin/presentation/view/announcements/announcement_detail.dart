import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;
import 'package:linkify/linkify.dart';
import 'package:lol/core/utils/resources/colors_manager.dart';
import 'package:lol/core/utils/resources/strings_manager.dart';
import 'package:lol/core/utils/resources/values_manager.dart';
import 'package:lol/main.dart';
import 'package:lol/features/admin/presentation/view_model/admin_cubit/admin_cubit_states.dart';
import 'package:lol/features/admin/presentation/view/announcements/announcement_detail.dart';
import 'package:lol/core/utils/resources/constants_manager.dart';
import 'package:lol/core/utils/components.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:lol/core/utils/navigation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lol/core/utils/webview_screen.dart';
import '../../../../../core/cubits/main_cubit/main_cubit.dart';
import '../../view_model/admin_cubit/admin_cubit.dart';

class AnnouncementDetail extends StatefulWidget {
  final String title;
  final String description;
  final dynamic date;
  final String semester;

  const AnnouncementDetail(
    {
      super.key,
      required this.title,
      required this.description,
      required this.date,
      required this.semester
    }
  );

  @override
  State<AnnouncementDetail> createState() => _AnnouncementDetailState();
}

class _AnnouncementDetailState extends State<AnnouncementDetail> {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCubit, AdminCubitStates>(
      listener: (context, state) {},
      builder: (context, state) {

        final content = widget.description.isEmpty ? StringsManager.noContent : widget.description;
        final isContentRtl = intl.Bidi.detectRtlDirectionality(content);
        final textDirection = widget.description.isEmpty
            ? (isArabicLanguage(context) ? TextDirection.rtl : TextDirection.ltr)
            : (isContentRtl ? TextDirection.rtl : TextDirection.ltr);

        return Scaffold(
          appBar: AppBar(
            title: Text(
              StringsManager.announcements,
              style: Theme.of(context).textTheme.displayMedium,
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Container(
                constraints: BoxConstraints(
                  maxHeight: AppQueries.screenHeight(context) / AppSizesDouble.s1_4,
                ),
                margin: const EdgeInsets.symmetric(horizontal: AppMargins.m15, vertical: AppMargins.m20),
                padding: const EdgeInsets.all(AppPaddings.p18),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: MainCubit.get(context).isDark ?
                  ColorsManager.darkPrimary :
                  ColorsManager.lightPrimary,
                  borderRadius: BorderRadius.circular(AppSizesDouble.s20)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectableText(
                      widget.title,
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        fontSize: AppQueries.screenWidth(context) / AppSizes.s13,
                      ),
                      textDirection: isArabicLanguage(context) ? TextDirection.rtl : TextDirection.ltr,
                    ),
                    SizedBox(height: AppSizesDouble.s5,),
                    divider(),
                    const SizedBox(
                      height: AppSizesDouble.s20,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Directionality(
                          textDirection: textDirection,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Builder(
                                builder: (context) {
                                  return SelectableLinkify(
                                    onOpen: (link) => onOpen(context, link),
                                    text: content,
                                    style: const TextStyle(
                                      color: ColorsManager.white,
                                    ),
                                    linkStyle: const TextStyle(color: ColorsManager.dodgerBlue, decorationColor: ColorsManager.dodgerBlue),
                                    linkifiers: const [
                                      UrlLinkifier(),
                                      EmailLinkifier(),
                                      PhoneNumberLinkifier(),
                                    ],
                                    textAlign: TextAlign.start,
                                    textDirection: textDirection,
                                    contextMenuBuilder: (context, state) {
                                      final textController = state.textEditingValue;
                                      final selection = textController.selection;
                                      String selectedText = widget.description.substring(
                                        selection.baseOffset.clamp(0, widget.description.length),
                                        selection.extentOffset.clamp(0, widget.description.length),
                                      );
                                      return AdaptiveTextSelectionToolbar(
                                        anchors: state.contextMenuAnchors,
                                        children: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              if (selectedText.isNotEmpty) {
                                                Clipboard.setData(ClipboardData(text: selectedText));
                                              }
                                            },
                                            child: const Text(StringsManager.copy),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              // Select all text
                                              state.selectAll(SelectionChangedCause.tap);
                                            },
                                            child: const Text(StringsManager.selectAll),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(top: AppPaddings.p5),
                      child: Text(
                        StringsManager.deadLine +
                        StringsManager.colon +
                        StringsManager.space +
                        (widget.date == StringsManager.noDueDate ? widget.date : intl.DateFormat(StringsManager.dateFormat).format(DateTime.parse(widget.date)).toString()),
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

}
