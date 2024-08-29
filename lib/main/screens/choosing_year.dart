import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:lol/main/screens/home.dart';
import 'package:lol/constants/componants.dart';
import 'package:lol/utilities/shared_prefrence.dart';

class ChoosingYear extends StatelessWidget {
  const ChoosingYear({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: const Text("FCIS ZONDA"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Year(title: "Level 1"),
              Year(title: "Level 2"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Year(title: "Level 3"),
              Year(title: "Level 4"),
            ],
          ),
        ],
      ),
    );
  }
}

class Year extends StatefulWidget {
  final String title;

  const Year({super.key, required this.title});

  @override
  YearState createState() => YearState();
}

class YearState extends State<Year> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Container(
            width: 150,
            height: 100,
            margin: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Center(
              child: Text(
                widget.title,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ),
        if (isExpanded)
          Container(
            width: 150,
            margin: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              children: [
                ListTile(
                  title: const Text('Semester 1'),
                  onTap: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.info,
                      animType: AnimType.rightSlide,
                      title:
                          'You About To Assign In ${widget.title} Semster 1 ',
                      btnOkText: "Confirm",
                      btnCancelOnPress: () {},
                      btnOkOnPress: () {
                        Cache.writeData(key: widget.title, value: 1);
                        navigatReplace(context, const Home());
                      },
                    ).show();
                  },
                ),
                ListTile(
                  title: const Text('Semester 2'),
                  onTap: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.info,
                      animType: AnimType.rightSlide,
                      title:
                          'You About To Assign In ${widget.title} Semster 2 ',
                      btnCancelOnPress: () {},
                      btnOkOnPress: () {
                        Cache.writeData(key: widget.title, value: 2);
                        navigatReplace(context, const Home());
                      },
                    ).show();
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }
}
