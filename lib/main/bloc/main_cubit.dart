import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lol/shared/network/endpoints.dart';
import '../../layout/home/bloc/main_cubit_states.dart';
import 'package:lol/main/screens/home.dart';
import 'package:lol/models/profile/profile_model.dart';
import 'package:lol/modules/auth/bloc/login_cubit.dart';
import 'package:lol/modules/year_choose/choosing_year.dart';
import 'package:lol/shared/components/constants.dart';
import 'package:lol/shared/components/navigation.dart';
import 'package:lol/shared/network/local/shared_prefrence.dart';
import 'package:lol/shared/network/remote/dio.dart';

//uid null?
class MainCubit extends Cubit<MainCubitStates> {
  MainCubit() : super(InitialMainState());
  static MainCubit get(context) => BlocProvider.of(context);

  bool isDarkMode = false;
  void changeMode() {
    isDarkMode = !isDarkMode;
    emit(ChangeMode());
  }

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
    } on Exception {
      emit(UploadImageFailure());
      // // TODO
    }
    return null;
  }

  ProfileModel? profileModel;
  getProfileInfo() {
    emit(GetProfileLoading());
    profileModel = null;

    DioHelp.getData(path: CURRENTUSER, token: TOKEN).then(
      (value) {
        profileModel = ProfileModel.fromJson(value.data);
        emit(GetProfileSuccess());
      },
    ).catchError((onError) {
      print(onError);
      emit(GetProfileFailure());
    });
  }

  void logout(context) {
    TOKEN = null;
    Cache.removeValue(key: "token");
    navigatReplace(
        context,
        ChoosingYear(
          loginCubit: LoginCubit(),
        ));
    emit(Logout());
  }

}
