import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lol/core/utils/components.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/cubits/main_cubit/main_cubit.dart';
import '../../../core/utils/resources/constants_manager.dart';
import '../../../main.dart';

class ReportBug extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  ReportBug({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report Bug', style: Theme.of(context).textTheme.displayMedium,),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                    color: MainCubit.get(context).isDark ? HexColor('#3B3B3B') : HexColor('#757575'),
                    borderRadius: BorderRadius.circular(15)),
                margin: EdgeInsetsDirectional.symmetric(
                    horizontal: 15, vertical: 30),
                padding: const EdgeInsets.all(15.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _titleController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This field must not be Empty';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Bug title',
                          hintStyle: TextStyle(
                              fontSize: 20, color: Colors.grey[400]),
                          border: UnderlineInputBorder(),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        minLines: 5,
                        maxLines: 10,
                        controller: _descriptionController,
                        keyboardType: TextInputType.multiline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This field must not be Empty';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: 'Bug description',
                            hintStyle: TextStyle(
                                fontSize: 20, color: Colors.grey[400]),
                            border: UnderlineInputBorder(),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white))),
                        style: const TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: 10.0),
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
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(13)),
                                padding: EdgeInsetsDirectional.symmetric(
                                    horizontal: AppQueries.screenWidth(context) / 11),
                                backgroundColor: Colors.white,
                                textStyle: TextStyle(fontSize: AppQueries.screenWidth(context) / 17),
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            const Spacer(),
                            //submit button
                            ElevatedButton(
                                onPressed: () async {
                                  sendBugReport(
                                    bugTitle: _titleController.text,
                                    bugDescription:
                                        _descriptionController.text,
                                  );
                                  _descriptionController.clear();
                                  _titleController.clear();
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(13)),
                                  padding: EdgeInsetsDirectional.symmetric(
                                      horizontal: AppQueries.screenWidth(context) / 11),
                                  backgroundColor:
                                      Color.fromARGB(255, 20, 130, 220),
                                  foregroundColor: Colors.white,
                                  textStyle: TextStyle(fontSize: AppQueries.screenWidth(context) / 17),
                                ),
                                child: const Text('Submit')),
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
}
