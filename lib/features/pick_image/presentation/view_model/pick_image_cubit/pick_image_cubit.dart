import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lol/core/models/profile/profile_model.dart';
import 'package:lol/core/network/endpoints.dart';
import 'package:lol/core/network/remote/dio.dart';
import 'package:lol/core/utils/resources/constants_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'pick_image_state.dart';

class PickImageCubit extends Cubit<PickImageState> {
  PickImageCubit() : super(PickImageInitial());
  final _storageRef = FirebaseStorage.instance.ref();

  static const profileImagesFolder = 'images';
  Future<void> uploadUserImage({required File image}) async {
    emit(UploadImageLoading());
    try {
      final pathRef = _storageRef.child('$profileImagesFolder/${image.path.split('/').last}');

      UploadTask uploadTask = pathRef.putFile(File(image.path));

      final snapshot = await uploadTask.whenComplete(() => null);
      final imageUrl = await snapshot.ref.getDownloadURL();

      emit(UploadImageSuccess(imageUrl: imageUrl));
    } on FirebaseException catch (e) {
      String errMessage;
      if (e.code == 'canceled') {
        errMessage = 'Operation canceled';
      } else if (e.code == 'object-not-found') {
        errMessage = 'Object not found';
      } else if (e.code == 'retry-limit-exceeded') {
        errMessage =
            'The maximum time limit on an operation has been excceded. Try uploading again.';
      } else {
        errMessage = 'Opps. Unknown error occured!';
      }
      emit(UploadImageFailed(errMessage: errMessage));
    } catch (e) {
      emit(UploadImageFailed(errMessage: e.toString()));
      return null;
    }
  }

  Future<void> deleteUserImage({required String image}) async {
    try {
      final String imageName = getImageNameFromUrl(imageUrl: image);
      final pathRef = _storageRef.child('images/${imageName}');
      await pathRef.delete();
    } on FirebaseException catch (e) {
      String errMessage;
      if (e.code == 'canceled') {
        errMessage = 'Operation canceled';
      } else if (e.code == 'object-not-found') {
        errMessage = 'Object not found';
      } else if (e.code == 'retry-limit-exceeded') {
        errMessage =
            'The maximum time limit on an operation has been excceded. Try uploading again.';
      } else {
        errMessage = 'Opps. Unknown error occured!';
      }
      debugPrint(errMessage);
    } catch (e) {
      return debugPrint(e.toString());
    }
  }

  Future<void> updateProfileImage({required String imageUrl}) async {
    emit(UpdateUserImageLoading());
    try {
      final response = await DioHelp.patchData(
          path: EDITCURRENTUSER,
          data: {
            'photo': imageUrl,
          },
          token: AppConstants.TOKEN);
      if (response.data['error'] != null) {
        emit(UpdateUserImageFailed(errMessage: response.data['error']));
      } else {
        emit(UpdateUserImageSuccess());
      }
    } catch (e) {
      emit(UpdateUserImageFailed(errMessage: e.toString()));
    }
  }

  Future<File?> pickImage() async {
    final XFile? selectedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (selectedImage != null) {
      return File(selectedImage.path);
    }
    return null;
  }

  String getImageNameFromUrl({required String imageUrl}) {
    final path = Uri.parse(imageUrl).path;
    final encodedFileName = path.split('/').last;
    return Uri.decodeComponent(encodedFileName).split('/').last;
  }
}
