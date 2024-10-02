import 'package:flutter/material.dart';
import 'package:lol/shared/components/components.dart';
import 'package:lol/shared/components/constants.dart';
import 'package:lol/shared/components/default_text_field.dart';
import 'package:lol/shared/styles/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedbackScreen extends StatelessWidget {
  FeedbackScreen({super.key});

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: scaffoldKey,
      drawer: drawerBuilder(context),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          backgroundEffects(),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 50,
                ),
                backButton(context),
                Padding(
                  padding:
                      const EdgeInsetsDirectional.symmetric(horizontal: 20.0),
                  child: Text(
                    "Give Your Feedback",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white, fontSize: 30),
                    textAlign: TextAlign.start,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: divider(),
                ),
                _buildFeedBackForm(context)
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFeedBackForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
            child: Column(
          children: [
            customTextFormField(
                //
                title: 'Full Name',
                controller: _nameController,
                keyboardtype: TextInputType.text
            ),
            SizedBox(
              height: 20,
            ),
            customTextFormField(
                title: 'Your Feedback',
                controller: _feedbackController,
                keyboardtype: TextInputType.multiline,
                maxLines: 8,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MaterialButton(
                    minWidth: screenWidth(context) / 3,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    textColor: a,
                    shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    color: additional1,
                    onPressed: () {
                      _nameController.text = '';
                      _feedbackController.text = '';
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(fontSize: 25),
                    )),
                MaterialButton(
                  minWidth: screenWidth(context) / 3,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  textColor: a,
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  color: additional1,
                  onPressed: () {
                    sendBugReport(feedbackDescription: _feedbackController.text, userName: _nameController.text);
                    _nameController.clear();
                    _feedbackController.clear();

                  },
                  child: Text(
                    'Send',
                    style: TextStyle(fontSize: 25),
                  ),
                )
              ],
            )
          ],
        )),
      ),
    );
  }

  Future<void> sendBugReport({String? userName, required String feedbackDescription}) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final String subject = Uri.encodeComponent('Feedback');
      final String body = Uri.encodeComponent(
        'Name: ${userName != ''? userName ?? 'Anonymous':'Anonymous'}\n\nFeedback Description: \n$feedbackDescription',
      );

      final Uri emailUri = Uri(
        scheme: 'mailto',
        path: 'taemaomar65@gmail.com , elnawawyseif@gmail.com',
        query: 'subject=$subject&body=$body',
      );
      await launchUrl(emailUri);
    }
  }
}
