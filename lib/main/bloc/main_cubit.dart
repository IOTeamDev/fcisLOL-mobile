import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lol/auth/bloc/login_cubit_states.dart';
import 'package:lol/auth/model/login_model.dart';
import 'package:lol/constants/constants.dart';
import 'package:lol/main/bloc/main_cubit_states.dart';
import 'package:lol/main/model/profile_model.dart';
import 'package:lol/utilities/dio.dart';

//uid null?
class MainCubit extends Cubit<MainCubitStates> {
  MainCubit() : super(InitialMainState());
  static MainCubit get(context) => BlocProvider.of(context);

  File? userImageFile;
  String? userImagePath;
  var picker = ImagePicker();

  getUserImage({required bool fromGallery}) async {
    emit(GetUserImageLoading());

    var tempPostImage = await picker.pickImage(
        source: fromGallery ? ImageSource.gallery : ImageSource.camera);
    if (tempPostImage != null) {
      userImageFile = File(tempPostImage.path);
      emit(GetUserImageSuccess());
      userImagePath = await UploadPImage(image: userImageFile!);
    } else {
      emit(GetUserImageFailure());
    }
  }

  Future<String?> UploadPImage({required File image}) async {
    emit(UploadImageLoading());

    final uploadTask = await FirebaseStorage.instance
        .ref()
        .child("images/${Uri.file(image.path).pathSegments.last}")
        .putFile(image);

    try {
      final imagePath = await uploadTask.ref.getDownloadURL();
      emit(UploadImageSuccess());
      return imagePath;
    } on Exception catch (e) {
      emit(UploadImageFailure());
      // // TODO
    }
  }

  ProfileModel? profileModel;
  getProfileInfo() {
    emit(GetProfileLoading());
    profileModel = null;

    DioHelp.getData(
            path: "me",
            token:TOKEN
                
                )
        .then(
      (value) {
        profileModel = ProfileModel.fromJson(value.data);
        emit(GetProfileSuccess());
      },
    ).catchError((onError) {
      print(onError);
      emit(GetProfileFailure());
    });
  }

// deleteImage(){//Used

// }
}
