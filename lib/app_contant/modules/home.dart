import 'package:flutter/material.dart';
import 'package:lol/constants/componants.dart';
import 'package:lol/main.dart';

bool leftMargin = true;

List subjectNamesList = [
  "Physics",
  "Electronics",
  "English",
  "Psychology",
  "Physics",
  "Electronics",
  "English",
  "Psychology"
];

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    double width = screenWidth(context);
    //   double height = ScreenHeight(context);
    return Scaffold(
      backgroundColor: Colors.grey[400],
      drawer: Drawer(
        //We Will Put In It Things

        width: width / 2.5,
        backgroundColor: const Color(0xff27363D),
      ),
      appBar: AppBar(
        title: const InkWell(
            child:
                Row()), //The Logo With Name And Make it Always Navigate to the Home
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff27363D),
        actions: [
          // if ( !isLogin!)
          if (!isLogin!)
            Container(
              decoration: BoxDecoration(
                  color: const Color(0xff631313),
                  borderRadius: BorderRadius.circular(10)),
              child: MaterialButton(
                onPressed: () {},
                child: const Text(
                  "Sign In",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisSpacing: 22, crossAxisSpacing: 22),
          itemBuilder: (context, index) =>
              subjectItem(subjectName: subjectNamesList[index]),
          itemCount: subjectNamesList.length,
        ),
      ),
    );
  }
}

Widget subjectItem({required String subjectName}) {
  return InkWell(
    onTap: () {
      print("object");
    },
    child: Container(
      width: 150,
      height: 100,
      margin: const EdgeInsets.symmetric(horizontal: 7),

      // margin: left_margin?EdgeInsets.only(left: 5):EdgeInsets.only(right: 5),
      // left_margin = !left_margin;//Will Be Solved With State Management

      decoration: BoxDecoration(
        color: const Color(0xff98857C),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Center(
        child: Text(
          subjectName,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    ),
  );
}
