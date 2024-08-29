import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lol/constants/color.dart';
import 'package:lol/constants/componants.dart';

class Profile extends StatelessWidget {

  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
  var phoneController=TextEditingController();
    var nameController = TextEditingController();
    var emailController = TextEditingController();
    double height = screenHeight(context);
    double width = screenWidth(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        // backgroundColor: Color,
        //       appBar: AppBar(
        // actions: [

        //   defaultTextButton(onPressed: (){}, text: "Edit Profile")
        // ],

        //       ),
        body: SafeArea(
          child: Container(
            // padding: EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    // Container(height: height,),
                    SizedBox(
                        height: height * 0.3,
                        // width: width,
                        child: Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              height: height * 0.2,
                              color: Colors.brown,
                              width: width,
                            ))),
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        SizedBox(
                          height: 150,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: ClipOval(
                              child: Image.asset(
                                "images/2149084942.jpg",
                                width: 110,
                                height: 110,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const Text(
                          "Sara Hanks ",
                          style: TextStyle(fontSize: 20),
                        )
                      ],
                    )
                    // ,Column()
                  ],
                ),
                // Text("44"),
                const SizedBox(
                  height: 20,
                ),

                const Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Icon(Icons.crib_outlined),
                          SizedBox(height: 10,),
                          Text("101")
                        ],
                  
                      ),
                      Column(
                        children: [  Icon(Icons.crib_outlined),
                          SizedBox(height: 10,),
                          Text("101")],
                      ),Column(
                        children: [  Icon(Icons.crib_outlined),
                          SizedBox(height: 10,),
                          Text("101")],
                      )
                    ],
                  ),
                ),
const SizedBox(
                  height: 10,
                ),
                const TabBar(tabs: [
                  Tab(
                    // icon: Icon(Icons.p),
                    text: "Home",
                  ),
                  Tab(
                    // icon: Icon(Icons.nat),
                    text: "Contributions",
                  )
                ])
                // i wanna make two navigations taps here
                ,
                Expanded(
                  child: TabBarView(children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                      const SizedBox(height: 20,),
                      defaultForm(label: "Name",controller: nameController,dtaPrefIcon: Icons.person),
                      const SizedBox(height: 10,),
                      defaultForm(label: "Email",controller: emailController,dtaPrefIcon: Icons.email),
                      const SizedBox(height: 10,),
                      defaultForm(label: "Phone",controller: phoneController,dtaPrefIcon: Icons.phone),
                      const SizedBox(height: 20,),
                      defaultButton(buttonFunc: (){}, isText: true, buttonWidth: 150,title: "Edit Profile")
                        ],
                      ),
                    ),
                    const Column(
                      children: [Text("Contributions List")],
                    ),
                  ]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


