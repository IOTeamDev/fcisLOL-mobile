import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/modules/auth/bloc/login_cubit.dart';
import 'package:lol/modules/auth/bloc/login_cubit_states.dart';
import 'package:lol/modules/auth/screens/register.dart';
import 'package:lol/shared/components/components.dart';
import 'package:lol/shared/components/snack.dart';
import 'package:lol/layout/home/bloc/main_cubit.dart';
import 'package:lol/layout/home/bloc/main_cubit_states.dart';
import 'package:lol/modules/year_choose/choosing_year.dart';
import 'package:lol/shared/components/navigation.dart';

class SelectImage extends StatelessWidget {
// final name
  final UserInfo userInfo; //name,email,password,phone
  const SelectImage({super.key, required this.userInfo});

  @override
  Widget build(BuildContext context) {
    print("${userInfo.name}dfskjfldsjkdlfjkljfkl");
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
          if (state is GetUserImageLimitExceed) {
            showToastMessage(
                message:
                    "Image size too large. Please select an image under 1MB.",
                states: ToastStates.WARNING);
          }
          // if (state is RegisterSuccess) {
          //   // token=state.token;
          //   // Cache.writeData(key: "token", value: state.token);
          //   snack(
          //       context: context,
          //       enumColor: Messages.success,
          //       titleWidget: const Text("Successfully signed up !"));
          // }
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
                                'images/default-avatar-icon-of-social-media-user-vector.jpg'),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: () {
                            mainCubit.getUserImage(fromGallery: true);

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

                  const Spacer(),

                  // Next Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await MainCubit.get(context).UploadPImage(
                          image: MainCubit.get(context).userImageFile,
                        );

                        userInfo.photo = mainCubit.userImagePath ??
                            "https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg";
                        print(userInfo.toString());
                        navigate(
                            context,
                            ChoosingYear(
                              loginCubit: LoginCubit(),
                              userInfo: userInfo,
                            ));

                        // loginCubit.register(
                        //     name: userInfo.name,
                        //     email: userInfo.email,
                        //     phone: userInfo.phone,
                        //     photo: mainCubit.userImagePath ??
                        //         "https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg",
                        //     password: userInfo.password,
                        //     semester: "Two"

                        //     );
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
          optionTitle,
          style: const TextStyle(color: Colors.white),
        ),
      ));
}
