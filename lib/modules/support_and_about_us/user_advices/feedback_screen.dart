import 'package:flutter/material.dart';
import 'package:lol/shared/components/components.dart';
import 'package:lol/shared/components/default_text_field.dart';

class FeedbackScreen extends StatelessWidget {
  FeedbackScreen({super.key});

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
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
                Container(
                  margin: const EdgeInsets.only(bottom: 8.0),
                  alignment: Alignment.topLeft,
                  child: MaterialButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 30,
                      )),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.symmetric(horizontal: 20.0),
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
    return SingleChildScrollView(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Form(
          child: Column(
        children: [
          customTextFormField(//
              title: 'Full Name',
              controller: _nameController,
              keyboardtype: TextInputType.text),
              SizedBox(height: 30,),
          customTextFormField(
              title: 'Email',
              controller: _emailController,
              keyboardtype: TextInputType.text),
              SizedBox(height: 30,),
          customTextFormField(
              title: 'feedback here',
              controller: _feedbackController,
              keyboardtype: TextInputType.text,
              maxLines: 8)
        ],
      )),
    );
  }
}
