import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart' as intl;
import 'package:linkify/linkify.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit_states.dart';
import 'package:lol/core/utils/resources/colors_manager.dart';
import 'package:lol/core/utils/resources/strings_manager.dart';
import 'package:lol/features/admin/presentation/view_model/admin_cubit/admin_cubit_states.dart';
import 'package:lol/core/utils/components.dart';

import '../../../../../core/cubits/main_cubit/main_cubit.dart';
import '../../../../../core/utils/resources/constants_manager.dart';
import '../../../../../main.dart';

class RequestsDetails extends StatefulWidget {
  final int id;
  final String title;
  final String description;
  final String subjectName;
  final String link;
  final String pfp;
  final String type;
  final String authorName;
  final String semester;

  const RequestsDetails(
    {super.key,
    required this.authorName,
    required this.type,
    required this.description,
    required this.link,
    required this.subjectName,
    required this.id,
    required this.title,
    required this.pfp,
    required this.semester}
  );

  @override
  State<RequestsDetails> createState() => _RequestsDetailsState();
}

class _RequestsDetailsState extends State<RequestsDetails> {

  @override
  Widget build(BuildContext context) {

    final content = widget.description.isEmpty ? StringsManager.noContent : widget.description;
    final isContentRtl = intl.Bidi.detectRtlDirectionality(content);
    final textDirection = widget.description.isEmpty
        ? (isArabicLanguage(context) ? TextDirection.rtl : TextDirection.ltr)
        : (isContentRtl ? TextDirection.rtl : TextDirection.ltr);

    return BlocConsumer<MainCubit, MainCubitStates>(
      listener: (context, state) {
        if (state is DeleteMaterialSuccessState) {
          showToastMessage(message: StringsManager.requestRejected, states: ToastStates.WARNING);
          Navigator.pop(context, StringsManager.refresh);
        }

        if (state is AcceptRequestSuccessState) {
          showToastMessage(message: StringsManager.requestAccepted, states: ToastStates.SUCCESS);
          Navigator.pop(context, StringsManager.refresh);
        }
      },
      builder: (context, state) {
        var cubit = MainCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(StringsManager.requestDetails, style: Theme.of(context).textTheme.displayMedium,),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                constraints: BoxConstraints(maxHeight: AppQueries.screenHeight(context) / 1.4),
                margin: const EdgeInsetsDirectional.symmetric(horizontal: 15, vertical: 20),
                padding: const EdgeInsets.all(15),
                width: double.infinity,
                height: AppQueries.screenHeight(context) / 1.4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: MainCubit.get(context).isDark
                    ? ColorsManager.darkPrimary
                    : ColorsManager.lightGrey,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(widget.pfp.toString()),
                          radius: 23,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          widget.authorName.toString(),
                          style: TextStyle(
                              fontSize: 18, color: Colors.grey[300]),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SelectableText(
                              widget.title,
                              textDirection: (isArabicLanguage(context) ? TextDirection.rtl : TextDirection.ltr),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                overflow: TextOverflow.ellipsis,
                              ),
                              maxLines: 3,
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.symmetric(vertical: 5),
                              child: SelectableLinkify(
                                onOpen: (link) => onOpen(context, link),
                                text: widget.description,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16),
                                linkStyle: const TextStyle(
                                    color: Colors.blue, fontSize: 18),
                                linkifiers: const [
                                  UrlLinkifier(),
                                  EmailLinkifier(),
                                  PhoneNumberLinkifier(),
                                ],
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
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                              maxWidth:
                                  AppQueries.screenWidth(context) /
                                      1.7),
                          child: Text(
                            widget.subjectName.replaceAll(StringsManager.underScore, StringsManager.space),
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey[300]),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Spacer(),
                        Text(
                          widget.type,
                          style: TextStyle(
                              fontSize: 13, color: Colors.grey[300]),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.symmetric(vertical: 15),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Row(
                            children: [
                              const Icon(Icons.link,
                                  color: Colors.white),
                              const SizedBox(width: 5),
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                    maxWidth:
                                        constraints.maxWidth - 30),
                                child: GestureDetector(
                                  onTap: () async {
                                    final linkElement =
                                        LinkableElement(widget.link, widget.link);
                                    await onOpen(context, linkElement);
                                  },
                                  child: Text(
                                    widget.link,
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      decoration:
                                          TextDecoration.underline,
                                      decorationColor: Colors.blue,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    ConditionalBuilder(
                      condition: cubit.profileModel != null &&
                          cubit.requests != null &&
                          state is! GetRequestsLoadingState,
                      fallback: (context) => Center(
                        child: CircularProgressIndicator(),
                      ),
                      builder: (context) => Row(
                        children: [
                          //cancel button
                          ElevatedButton(
                            onPressed: () {
                              //print(cubit.requests![id].id);
                              cubit.deleteMaterial(
                                  cubit.requests![widget.id].id!, widget.semester);
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(13)),
                              padding:
                                  const EdgeInsetsDirectional.symmetric(
                                      horizontal: 40),
                              backgroundColor: Colors.white,
                              textStyle: TextStyle(
                                  fontSize:
                                      AppQueries.screenWidth(context) /
                                          17),
                            ),
                            child: const Text(
                              StringsManager.reject,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          const Spacer(),
                          //submit button
                          ElevatedButton(
                              onPressed: () {
                                cubit.acceptRequest(cubit.requests![widget.id].id!, widget.semester);
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                                padding: const EdgeInsetsDirectional.symmetric(horizontal: 40),
                                backgroundColor:ColorsManager.lightPrimary,
                                foregroundColor: Colors.white,
                                textStyle: TextStyle(fontSize: AppQueries.screenWidth(context) / 17),
                              ),
                              child: const Text(StringsManager.accept)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
