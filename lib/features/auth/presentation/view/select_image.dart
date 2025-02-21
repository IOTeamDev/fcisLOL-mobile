import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/core/utils/dependencies_helper.dart';
import 'package:lol/features/auth/presentation/view_model/auth_cubit/auth_cubit.dart';
import 'package:lol/main.dart';
import 'package:lol/features/auth/presentation/view_model/login_cubit/login_cubit.dart';
import 'package:lol/features/auth/presentation/view_model/login_cubit/login_cubit_states.dart';
import 'package:lol/features/auth/presentation/view/register.dart';
import 'package:lol/core/utils/components.dart';
import 'package:lol/core/widgets/snack.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit_states.dart';
import 'package:lol/features/auth/presentation/view/choosing_year.dart';
import 'package:lol/core/utils/navigation.dart';

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
          create: (context) => AuthCubit(),
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

          if (state is GetUserImageNoMoreSpace) {
            showToastMessage(
                message: "no more space available :)",
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
                            if (noMoreStorage!) {
                              showToastMessage(
                                  message: "no more space available :)",
                                  states: ToastStates.WARNING);
                            } else {
                              mainCubit.getUserImage(fromGallery: true);
                            }

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
                        await MainCubit.get(context).uploadPImage(
                          image: MainCubit.get(context).userImageFile,
                        );

                        userInfo.photo = mainCubit.userImagePath ??
                            "https://firebasestorage.googleapis.com/v0/b/fcis-da7f4.appspot.com/o/images%2Fdefault-avatar-icon-of-social-media-user-vector.jpg?alt=media&token=5fc138d2-3919-4854-888e-2d8fec45d555";
                        print(userInfo.toString());
                        navigate(
                            context,
                            ChoosingYear(
                              userInfo: userInfo,
                              authCubit: getIt.get<AuthCubit>(),
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

Widget optionWidget({
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
