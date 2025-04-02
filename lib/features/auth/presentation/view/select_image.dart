import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/core/utils/dependencies_helper.dart';
import 'package:lol/core/utils/resources/colors_manager.dart';
import 'package:lol/core/utils/resources/constants_manager.dart';
import 'package:lol/core/utils/resources/icons_manager.dart';
import 'package:lol/core/utils/resources/strings_manager.dart';
import 'package:lol/core/utils/resources/values_manager.dart';
import 'package:lol/features/auth/data/models/registration_user_model.dart';
import 'package:lol/features/auth/presentation/view_model/auth_cubit/auth_cubit.dart';
import 'package:lol/main.dart';
import 'package:lol/features/auth/presentation/view_model/login_cubit/login_cubit.dart';
import 'package:lol/features/auth/presentation/view_model/login_cubit/login_cubit_states.dart';
import 'package:lol/features/auth/presentation/view/register.dart';
import 'package:lol/core/utils/components.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit_states.dart';
import 'package:lol/features/auth/presentation/view/choosing_year.dart';
import 'package:lol/core/utils/navigation.dart';

class SelectImage extends StatefulWidget {
// final name
  final RegistrationUserModel userInfo; //name,email,password,phone
  const SelectImage({super.key, required this.userInfo});

  @override
  State<SelectImage> createState() => _SelectImageState();
}

class _SelectImageState extends State<SelectImage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocConsumer<MainCubit, MainCubitStates>(
        listener: (context, state) {
          // if (state is GetUserImageLimitExceed) {
          //   showToastMessage(
          //     message: "Image size too large. Please select an image under 1MB.",
          //     states: ToastStates.WARNING
          //   );
          // }

          if (state is GetUserImageNoMoreSpace) {
            showToastMessage(
                message: "no more space available :)",
                states: ToastStates.WARNING);
          }
        },
        builder: (context, state) {
          var mainCubit = MainCubit.get(context);

          return Scaffold(
            backgroundColor: ColorsManager.white,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    IconsManager.backIcon,
                    color: ColorsManager.black,
                  )),
              backgroundColor: ColorsManager.white,
              title: Text(StringsManager.profileImage,
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(color: ColorsManager.black)),
              centerTitle: true,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: AppQueries.screenWidth(context) / AppSizes.s6,
                    backgroundImage: mainCubit.userImageFile != null
                        ? FileImage(mainCubit.userImageFile!)
                        : AssetImage(AppConstants.noneLoggedInDefaultImage),
                  ),
                  SizedBox(
                    height: AppSizesDouble.s50,
                  ),
                  SizedBox(
                    width:
                        AppQueries.screenWidth(context) / AppSizesDouble.s1_5,
                    child: ElevatedButton(
                      onPressed: () {
                        if (mainCubit.userImageFile == null) {
                          if (noMoreStorage!) {
                            showToastMessage(
                                message: "no more space available :)",
                                states: ToastStates.WARNING);
                          } else {
                            mainCubit.getUserImage(fromGallery: true);
                          }
                        } else {
                          setState(() {
                            mainCubit.userImageFile = null;
                            mainCubit.imageName = StringsManager.selectImage;
                            mainCubit.pickerIcon = IconsManager.imageIcon;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: AppPaddings.p20,
                          ),
                          backgroundColor: ColorsManager.lightGrey1,
                          foregroundColor: ColorsManager.black,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppSizesDouble.s20))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(mainCubit.imageName!,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(color: ColorsManager.black)),
                          SizedBox(
                            width: AppSizesDouble.s10,
                          ),
                          Icon(
                            mainCubit.pickerIcon,
                            color: ColorsManager.black,
                            size: AppSizesDouble.s25,
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: AppSizesDouble.s15,
                  ),

                  // Next Button
                  SizedBox(
                    width:
                        AppQueries.screenWidth(context) / AppSizesDouble.s1_5,
                    child: ElevatedButton(
                      onPressed: () async {
                        // await MainCubit.get(context).uploadPImage(
                        //   image: MainCubit.get(context).userImageFile,
                        // );

                        // widget.userInfo.photo = mainCubit.userImagePath ??
                        //     "https://firebasestorage.googleapis.com/v0/b/fcis-da7f4.appspot.com/o/images%2Fdefault-avatar-icon-of-social-media-user-vector.jpg?alt=media&token=5fc138d2-3919-4854-888e-2d8fec45d555";
                        // print(widget.userInfo.toString());
                        // navigate(
                        //     context,
                        //     ChoosingYear(
                        //       userInfo: widget.userInfo,
                        //       authCubit: getIt.get<AuthCubit>(),
                        //     ));
                      },
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: AppPaddings.p20,
                          ),
                          backgroundColor: ColorsManager.lightPrimary,
                          foregroundColor: ColorsManager.white,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppSizesDouble.s20))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(StringsManager.next,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(color: ColorsManager.white)),
                          SizedBox(
                            width: AppSizesDouble.s10,
                          ),
                          Icon(
                            IconsManager.leftArrowIcon,
                            color: ColorsManager.white,
                            size: AppSizesDouble.s30,
                          )
                        ],
                      ),
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

// Widget optionWidget({
//   required VoidCallback optionFunction,
//   required String optionTitle,
// }) {
//   return Container(
//       decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), color: Colors.blue),
//       child: MaterialButton(
//         onPressed: optionFunction,
//         child: Text(
//           optionTitle,
//           style: const TextStyle(color: Colors.white),
//         ),
//       ));
// }
