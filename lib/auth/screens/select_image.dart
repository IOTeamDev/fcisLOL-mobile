import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/auth/bloc/login_cubit.dart';
import 'package:lol/auth/bloc/login_cubit_states.dart';
import 'package:lol/auth/screens/register.dart';
import 'package:lol/components/snack.dart';
import 'package:lol/main/bloc/main_cubit.dart';
import 'package:lol/main/bloc/main_cubit_states.dart';

class SelectImage extends StatelessWidget {
// final name
  final UserInfo userInfo; //name,email,password,phone
  const SelectImage({super.key, required this.userInfo});

  @override
  Widget build(BuildContext context) {
    print(userInfo.name + "dfskjfldsjkdlfjkljfkl");
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginCubit(),
        ),
        BlocProvider(
          create: (context) => MainCubit(),
        ),
      ],
      child: BlocConsumer<MainCubit, MainCubitStates>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            // token=state.token;
            // Cache.writeData(key: "token", value: state.token);
            snack(
                context: context,
                enumColor: Messages.success,
                titleWidget: const Text("Successfully signed up !"));
          }
        },
        builder: (context, state) {
          var loginCubit = LoginCubit.get(context);
          var mainCubit = MainCubit.get(context);

          return Scaffold(
            appBar: AppBar(title: const Text("Select Profile Image")),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Profile Image picker
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: mainCubit.userImageFile != null
                            ? FileImage(mainCubit.userImageFile!)
                            : AssetImage(
                                'images/default-avatar-profile-icon-social-600nw-1677509740.png'),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Select the image source"),
                                  actionsAlignment:
                                      MainAxisAlignment.spaceAround,
                                  actions: [
                                    OptionWidget(
                                        optionFunction: () async{
                                        mainCubit.getUserImage(
                                              fromGallery: false);
                                          Navigator.pop(context);
                                        },
                                        optionTitle: "Camera"),
                                    OptionWidget(
                                        optionFunction: ()async {
                                          mainCubit.getUserImage(
                                              fromGallery: true);
                                          Navigator.pop(context);
                                        },
                                        optionTitle: "Gallery"),
                                  ],
                                );
                              },
                            );

                            // Code to pick image
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.camera_alt,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Pick Image Button
                  ElevatedButton.icon(
                    onPressed: () {
                      // Code to pick image
                    },
                    icon: const Icon(Icons.photo_library),
                    label: const Text("Pick an Image"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                    ),
                  ),

                  const Spacer(),

                  // Next Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {


                        loginCubit.register(
                            name: userInfo.name,
                            email: userInfo.email,
                            phone: userInfo.phone,
                            photo: mainCubit.userImagePath ??
                                "https://i.pinimg.com/736x/0d/64/98/0d64989794b1a4c9d89bff571d3d5842.jpg",
                            password: userInfo.password,
                            semester: "Two");
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text("Next", style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget OptionWidget({
  required VoidCallback optionFunction,
  required String optionTitle,
}) {
  return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40), color: Colors.blue),
      child: MaterialButton(
        onPressed: optionFunction,
        child: Text(
          "$optionTitle",
          style: TextStyle(color: Colors.white),
        ),
      ));
}
