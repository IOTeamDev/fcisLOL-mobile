import 'package:flutter/material.dart';
import 'package:lol/shared/components/components.dart';
import 'package:url_launcher/url_launcher.dart';

class ReportBug extends StatelessWidget {

  var _formKey = GlobalKey<FormState>();

  var _nameController = TextEditingController();
  var _emailController = TextEditingController();
  var _titleController = TextEditingController();
  var _descriptionController = TextEditingController();

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
                  adminTopTitleWithDrawerButton(title: 'Announcements', size: 32, hasDrawer: false),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _nameController,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty) {
                                return 'This field must not be Empty';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'Title',
                              hintStyle: TextStyle(
                                  fontSize: 20,
                                  color: Colors.grey[400]),
                              border: InputBorder.none,
                            ),
                            style: const TextStyle(
                                color: Colors.white),
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

  Future<void> sendBugReport({required userEmail, userName, required feedbackTitle, required feedbackDescription}) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final Uri emailUri = Uri(
        scheme: 'mailto',
        path: 'taemaomar65@gmail.com , elnawawyseif@gmail.com',
        queryParameters: {
          'subject': feedbackTitle,
          'body': 'Name: ${userName ?? 'Anonymous'}\n\nBug Description: $feedbackDescription',
        },
      );
      await launchUrl(emailUri);
    }
  }
}
