import 'package:flutter/material.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit.dart';
import 'package:lol/core/utils/components.dart';
import 'package:lol/main.dart';

class ImageSelector extends StatelessWidget {
  const ImageSelector({
    super.key,
    required this.mainCubit,
  });

  final MainCubit mainCubit;

  @override
  Widget build(BuildContext context) {
    return Stack(
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
              child: const Icon(Icons.camera_alt, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
