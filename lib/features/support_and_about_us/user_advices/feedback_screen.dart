import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lol/core/utils/components.dart';
import 'package:lol/core/utils/constants.dart';
import 'package:lol/core/widgets/default_text_field.dart';
import 'package:lol/core/utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../main.dart';

class FeedbackScreen extends StatelessWidget {
  FeedbackScreen({super.key});

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  final _feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = screenWidth(context);
    double height = screenHeight(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: scaffoldKey,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsetsDirectional.only(top: screenHeight(context) / 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Positioned(
                    left: 0,
                    child: backButton(context),
                  ),
                  Center(
                    child: Text(
                      'Feedback',
                      style: TextStyle(
                        fontSize: width / 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              _buildFeedBackForm(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeedBackForm(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: isDark ? HexColor('#3B3B3B') : HexColor('#757575'),
          borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsetsDirectional.symmetric(horizontal: 15, vertical: 30),
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  minLines: 12,
                  maxLines: 15,
                  controller: _feedbackController,
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field must not be Empty';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      hintText: 'Your feedback',
                      hintStyle:
                          TextStyle(fontSize: 20, color: Colors.grey[400]),
                      border: UnderlineInputBorder(),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white))),
                  style: const TextStyle(color: Colors.white),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _feedbackController.text = '';
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13)),
                        padding: EdgeInsetsDirectional.symmetric(
                            horizontal: screenWidth(context) / 11),
                        backgroundColor: Colors.white,
                        textStyle:
                            TextStyle(fontSize: screenWidth(context) / 17),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          sendBugReport(
                            feedbackDescription: _feedbackController.text,
                          );
                          _feedbackController.clear();
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13)),
                          padding: EdgeInsetsDirectional.symmetric(
                              horizontal: screenWidth(context) / 11),
                          backgroundColor: Color.fromARGB(255, 20, 130, 220),
                          foregroundColor: Colors.white,
                          textStyle:
                              TextStyle(fontSize: screenWidth(context) / 17),
                        ),
                        child: const Text('Submit'))
                  ],
                )
              ],
            )),
      ),
    );
  }

  Future<void> sendBugReport({required String feedbackDescription}) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final String subject = Uri.encodeComponent('Feedback');
      final String body = Uri.encodeComponent(feedbackDescription);

      final Uri emailUri = Uri(
        scheme: 'mailto',
        path: 'taemaomar65@gmail.com',
        query: 'subject=$subject&body=$body',
      );
      await launchUrl(emailUri);
    }
  }
}
