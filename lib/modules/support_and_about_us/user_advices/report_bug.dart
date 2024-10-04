import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lol/shared/components/components.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../layout/home/bloc/main_cubit.dart';

class ReportBug extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  ReportBug({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          backgroundEffects(),
          Container(
            width: double.infinity,
            margin: const EdgeInsetsDirectional.only(top: 50),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  backButton(context),
                  adminTopTitleWithDrawerButton(
                      title: 'Announcements', size: 32, hasDrawer: false),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _nameController,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              hintText: 'Name',
                              hintStyle: TextStyle(
                                  fontSize: 20, color: Colors.grey[400]),
                              border: InputBorder.none,
                            ),
                            style: const TextStyle(color: Colors.white),
                          ),
                          divider(),
                          SizedBox(
                            height: 10,
                          ),
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
                              border: InputBorder.none,
                            ),
                            style: const TextStyle(color: Colors.white),
                          ),
                          divider(),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            minLines: 5,
                            maxLines: 5,
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
                              border: InputBorder.none,
                            ),
                            style: const TextStyle(color: Colors.white),
                          ),
                          divider(),
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
                                    _nameController.clear();
                                    _titleController.clear();
                                    _descriptionController.clear();
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding:
                                        const EdgeInsetsDirectional.symmetric(
                                            horizontal: 35),
                                    backgroundColor:
                                        HexColor('D9D9D9').withOpacity(0.2),
                                    foregroundColor: Colors.white,
                                    textStyle: const TextStyle(fontSize: 15),
                                  ),
                                  child: const Text('Cancel'),
                                ),
                                const Spacer(),
                                //submit button
                                ElevatedButton(
                                    onPressed: () async {
                                      sendBugReport(
                                          bugTitle: _titleController.text,
                                          bugDescription:
                                              _descriptionController.text,
                                          userName: _nameController.text);
                                      _descriptionController.clear();
                                      _titleController.clear();
                                      _nameController.clear();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding:
                                          const EdgeInsetsDirectional.symmetric(
                                              horizontal: 40),
                                      backgroundColor: HexColor('B8A8F9'),
                                      foregroundColor: Colors.white,
                                      textStyle: const TextStyle(fontSize: 15),
                                    ),
                                    child: const Text('Submit')),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> sendBugReport({
    String? userName,
    required String bugTitle,
    required String bugDescription,
  }) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final String subject = Uri.encodeComponent(bugTitle);
      final String body = Uri.encodeComponent(
        'Name: ${userName != '' ? userName ?? 'Anonymous' : 'Anonymous'}\n\nBug Description: \n$bugDescription',
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
