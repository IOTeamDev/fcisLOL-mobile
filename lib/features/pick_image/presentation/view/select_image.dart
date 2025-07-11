import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lol/core/models/profile/profile_model.dart';
import 'package:lol/core/utils/service_locator.dart';
import 'package:lol/core/utils/resources/colors_manager.dart';
import 'package:lol/core/utils/resources/constants_manager.dart';
import 'package:lol/core/utils/resources/icons_manager.dart';
import 'package:lol/core/utils/resources/strings_manager.dart';
import 'package:lol/core/utils/resources/values_manager.dart';
import 'package:lol/features/auth/data/models/registration_user_model.dart';
import 'package:lol/features/home/presentation/view/home.dart';
import 'package:lol/features/pick_image/presentation/view_model/pick_image_cubit/pick_image_cubit.dart';
import 'package:lol/main.dart';
import 'package:lol/features/auth/presentation/view/register.dart';
import 'package:lol/core/utils/components.dart';
import 'package:lol/features/auth/presentation/view/choosing_year.dart';
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
    return BlocProvider(
      create: (context) => PickImageCubit(),
      child: BlocListener<PickImageCubit, PickImageState>(
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
            context
                .read<PickImageCubit>()
                .updateProfileImage(imageUrl: state.imageUrl);
          }

          if (state is UpdateUserImageSuccess) {
            showToastMessage(
                message: 'Image Uploaded Successfully',
                states: ToastStates.SUCCESS);

            navigatReplace(context, Home());
          }
        },
        child: Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Text(StringsManager.profileImage,
                    style: Theme.of(context).textTheme.displayMedium!),
                centerTitle: true,
              ),
              body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: AppQueries.screenWidth(context) / AppSizes.s6,
                        backgroundImage: _image == null
                            ? AssetImage(AppConstants.noneLoggedInDefaultImage)
                            : FileImage(File(_image!.path)),
                      ),
                      SizedBox(
                        height: AppSizesDouble.s50,
                      ),
                      SizedBox(
                        width: AppQueries.screenWidth(context) /
                            AppSizesDouble.s1_5,
                        child: ElevatedButton.icon(
                          iconAlignment: IconAlignment.end,
                          icon: Icon(
                            IconsManager.imageIcon,
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
                                  borderRadius: BorderRadius.circular(
                                      AppSizesDouble.s20))),
                          onPressed: () async {
                            _image = await context
                                .read<PickImageCubit>()
                                .pickImage();
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
                        width: AppQueries.screenWidth(context) /
                            AppSizesDouble.s1_5,
                        child: ElevatedButton.icon(
                          iconAlignment: IconAlignment.end,
                          label: Text(StringsManager.next,
                              style: Theme.of(context).textTheme.titleLarge!),
                          icon: Icon(
                            IconsManager.leftArrowIcon,
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
                                  borderRadius: BorderRadius.circular(
                                      AppSizesDouble.s20))),
                          onPressed: () async {
                            if (_image == null) {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => Home(),
                                ),
                                (route) => false,
                              );
                            } else {
                              await context
                                  .read<PickImageCubit>()
                                  .uploadUserImage(
                                    image: _image!,
                                  );
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
                      child: CircularProgressIndicator(), // Loading Indicator
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            )
          ],
        ),
      ),
    );
  }
}
