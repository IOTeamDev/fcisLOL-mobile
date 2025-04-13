import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lol/core/models/profile/profile_model.dart';
import 'package:lol/core/network/endpoints.dart';
import 'package:lol/core/network/remote/dio.dart';
import 'package:lol/core/utils/resources/constants_manager.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'pick_image_state.dart';

class PickImageCubit extends Cubit<PickImageState> {
  PickImageCubit() : super(PickImageInitial());
  final _storageRef = FirebaseStorage.instance.ref();

  Future<void> uploadUserImage({required File image}) async {
    emit(UploadImageLoading());
    try {
      final pathRef = _storageRef.child('images/${image.path}');
      UploadTask uploadTask = pathRef.putFile(File(image.path));

      final snapshot = await uploadTask.whenComplete(() => null);
      final imageUrl = await snapshot.ref.getDownloadURL();
      log(imageUrl);

      emit(UploadImageSuccess(imageUrl: imageUrl));
    } catch (e) {
      emit(UploadImageFailed(errMessage: e.toString()));
      return null;
    }
  }

  Future<void> editProfileImage({required String imageUrl}) async {
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
}
