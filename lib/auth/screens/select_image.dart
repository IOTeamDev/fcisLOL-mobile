import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/auth/bloc/login_cubit.dart';
import 'package:lol/auth/bloc/login_cubit_states.dart';
import 'package:lol/auth/screens/register.dart';
import 'package:lol/constants/componants.dart';

class SelectImage extends StatelessWidget {
// final name
  final UserInfo userInfo; //name,email,password,phone
  const SelectImage({super.key, required this.userInfo});

  @override
  Widget build(BuildContext context) {
    print(userInfo.name + "dfskjfldsjkdlfjkljfkl");
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var loginCubit = LoginCubit.get(context);

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
                        backgroundImage: loginCubit.profileImage != null
                            ? FileImage(loginCubit.profileImage!)
                            : AssetImage(
                                'images/default-avatar-profile-icon-social-600nw-1677509740.png'),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: () {
// dialgoAwesome(title: title, type: type)

                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Select the image source"),
                                  actionsAlignment:
                                      MainAxisAlignment.spaceAround,
                                  actions: [
                                    OptionWidget(
                                        optionFunction: () {
                                          loginCubit.pickProfileImage(true);
                                          Navigator.pop(context);
                                        },
                                        optionTitle: "Camera"),
                                    OptionWidget(
                                        optionFunction: () {
                                          loginCubit.pickProfileImage(false);
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
                            photo: userInfo.phone,
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
