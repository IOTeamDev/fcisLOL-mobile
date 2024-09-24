import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/components/default_button.dart';
import 'package:lol/components/default_text_field.dart';
import 'package:lol/constants/colors.dart';
import 'package:lol/constants/constants.dart';
import 'package:lol/main/bloc/main_cubit.dart';
import 'package:lol/main/bloc/main_cubit_states.dart';
import 'package:lol/main/screens/home.dart';
import 'package:lol/utilities/navigation.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    var phoneController = TextEditingController();
    var nameController = TextEditingController();
    var emailController = TextEditingController();
    double height = screenHeight(context);
    double width = screenWidth(context);
    return BlocProvider(
        create: (context) => MainCubit()..getProfileInfo(),
        child: BlocConsumer<MainCubit, MainCubitStates>(
          builder: (context, state) {
            var mainCubit = MainCubit.get(context);
            if (mainCubit.profileModel != null) {
              if (mainCubit.profileModel!.phone != null) {
                phoneController.text = mainCubit.profileModel!.phone!;
              }
              nameController.text = mainCubit.profileModel!.name;
              emailController.text = mainCubit.profileModel!.email;
            }
            return DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: AppBar(
                  title: InkWell(
                    onTap: () => navigatReplace(context,Home()),// in all pages
                  
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text("temp"), Icon(Icons.label)],
                  )),
                ),
                body: mainCubit.profileModel==null?Center(child: CircularProgressIndicator(),): Column(
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
                                  color: Color(0xff0F4C75),
                                  width: width,
                                ))),
                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            SizedBox(
                              height: 150,
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundImage: NetworkImage(
                                    mainCubit.profileModel!.photo,
                                  ),
                                  // child: Image.network(
                
                                  //   width: 110,
                                  //   height: 110,
                                  //   fit: BoxFit.cover,
                                  // ),
                                ),
                              ),
                            ),
                            Text(
                              mainCubit.profileModel!.name,
                              style: const TextStyle(fontSize: 20),
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
                              SizedBox(
                                height: 10,
                              ),
                              Text("101")
                            ],
                          ),
                          Column(
                            children: [
                              Icon(Icons.crib_outlined),
                              SizedBox(
                                height: 10,
                              ),
                              Text("101")
                            ],
                          ),
                          Column(
                            children: [
                              Icon(Icons.crib_outlined),
                              SizedBox(
                                height: 10,
                              ),
                              Text("101")
                            ],
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
                        text: "Personal Info",
                      ),
                      Tab(
                        // icon: Icon(Icons.nat),
                        text: "My Uploads",
                      )
                    ])
                    // i wanna make two navigations taps here
                    ,
                    Expanded(
                      child: TabBarView(
                          physics: const BouncingScrollPhysics(),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  defaultTextField(
                                      enabled: false,
                                      label: "Name",
                                      controller: nameController,
                                      dtaPrefIcon: Icons.person),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  defaultTextField(
                                      enabled: false,
                                      label: "Email",
                                      controller: emailController,
                                      dtaPrefIcon: Icons.email),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  defaultTextField(
                                      enabled: false,
                                      label: "Phone",
                                      controller: phoneController,
                                      dtaPrefIcon: Icons.phone),
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
            );
          },
          listener: (context, state) {},
        ));
  }
}
