import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lol/config/navigation/routes.dart';
import 'package:lol/core/models/profile/profile_model.dart';
import 'package:lol/core/presentation/screen_size.dart';
import 'package:lol/core/dependency_injection/service_locator.dart';
import 'package:lol/core/resources/theme/colors_manager.dart';
import 'package:lol/core/resources/constants/constants_manager.dart';
import 'package:lol/core/presentation/app_icons.dart';
import 'package:lol/core/resources/theme/values/app_strings.dart';
import 'package:lol/core/resources/theme/values/values_manager.dart';
import 'package:lol/features/auth/data/models/register_request_model.dart';
import 'package:lol/features/home/presentation/view/home.dart';
import 'package:lol/features/pick_image/presentation/cubits/pick_image_cubit/pick_image_cubit.dart';
import 'package:lol/main.dart';
import 'package:lol/features/auth/presentation/view/register/register.dart';
import 'package:lol/core/utils/components.dart';
import 'package:lol/features/auth/presentation/view/choosing_year/choosing_year.dart';
import 'package:lol/core/utils/navigation.dart';

class SelectImage extends StatefulWidget {
// final name
  const SelectImage({
    super.key,
  });

  @override
  State<SelectImage> createState() => _SelectImageState();
}

class _SelectImageState extends State<SelectImage> {
  File? _image;
  @override
  Widget build(BuildContext context) {
    return BlocListener<PickImageCubit, PickImageState>(
      listener: (context, state) {
        if (state is UploadImageFailed) {
          showToastMessage(
              message: state.errMessage, states: ToastStates.ERROR);
        }
        if (state is UpdateUserImageFailed) {
          showToastMessage(
              message: state.errMessage, states: ToastStates.ERROR);
        }

        if (state is UploadImageSuccess) {
          _updateProfileImage(imageUrl: state.imageUrl);
        }

        if (state is UpdateUserImageSuccess) {
          showToastMessage(
              message: 'Image Uploaded Successfully',
              states: ToastStates.SUCCESS);
          context.goNamed(ScreensName.home);
        }
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(AppStrings.profileImage,
                  style: Theme.of(context).textTheme.displayMedium!),
              centerTitle: true,
            ),
            body: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: ScreenSize.width(context) / AppSizes.s6,
                      backgroundImage: _image == null
                          ? AssetImage(AppConstants.noneLoggedInDefaultImage)
                          : FileImage(File(_image!.path)),
                    ),
                    SizedBox(
                      height: AppSizesDouble.s50,
                    ),
                    SizedBox(
                      width: ScreenSize.width(context) / AppSizesDouble.s1_5,
                      child: ElevatedButton.icon(
                        iconAlignment: IconAlignment.end,
                        icon: Icon(
                          AppIcons.imageIcon,
                          color: ColorsManager.black,
                          size: AppSizesDouble.s25,
                        ),
                        label: Text(
                          _image == null ? 'Choose Image' : _image!.path,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(color: ColorsManager.black),
                          overflow: TextOverflow.ellipsis,
                        ),
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              vertical: AppPaddings.p20,
                            ),
                            backgroundColor: ColorsManager.white,
                            foregroundColor: ColorsManager.black,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(AppSizesDouble.s20))),
                        onPressed: () async {
                          _image =
                              await context.read<PickImageCubit>().pickImage();
                          if (_image != null) {
                            setState(() {});
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: AppSizesDouble.s15,
                    ),

                    // Next Button
                    SizedBox(
                      width: ScreenSize.width(context) / AppSizesDouble.s1_5,
                      child: ElevatedButton.icon(
                        iconAlignment: IconAlignment.end,
                        label: Text(AppStrings.next,
                            style: Theme.of(context).textTheme.titleLarge!),
                        icon: Icon(
                          AppIcons.leftArrowIcon,
                          color: ColorsManager.white,
                          size: AppSizesDouble.s30,
                        ),
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              vertical: AppPaddings.p20,
                            ),
                            backgroundColor: ColorsManager.lightPrimary,
                            foregroundColor: ColorsManager.white,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(AppSizesDouble.s20))),
                        onPressed: () async {
                          if (_image != null) {
                            await context
                                .read<PickImageCubit>()
                                .uploadUserImage(image: _image!);
                          }
                        },
                      ),
                    ),
                  ]),
            ),
          ),
          BlocBuilder<PickImageCubit, PickImageState>(
            builder: (context, state) {
              if (state is UploadImageLoading ||
                  state is UpdateUserImageLoading) {
                return ColoredBox(
                  color: Colors.black.withValues(
                    alpha: 0.5,
                  ), // Transparent black background
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          )
        ],
      ),
    );
  }

  Future<void> _updateProfileImage({required String imageUrl}) async {
    await context.read<PickImageCubit>().updateProfileImage(imageUrl: imageUrl);
  }
}
